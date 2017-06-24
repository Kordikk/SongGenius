//
//  ViewController.swift
//  Song Genius
//
//  Created by Kordian Ledzion on 14.06.2017.
//  Copyright © 2017 KordianLedzion. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SwiftyJSON

class ITunesSongsViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    private let disposeBag = DisposeBag()
    private var rc: UIRefreshControl?
    
    let api = API()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp() // additional func for tidier viewDidLoad
        self.tableView.register(ITunesSongsCell.self, forCellReuseIdentifier: "ITunesSongsCell")
    }
    
    func setUp() {
        tableView.delegate = nil
        tableView.rx.setDelegate(self)
            .addDisposableTo(disposeBag)
        tableView.dataSource = nil
        tableView.rx.itemSelected.subscribe(onNext: { [tableView] index in
            tableView?.deselectRow(at: index, animated: false)
        }).addDisposableTo(disposeBag)
        let refreshControl = UIRefreshControl()
        tableView.addSubview(refreshControl)
        tableView.refreshControl = refreshControl
        self.rc = tableView.refreshControl
        let shouldShowCancelButton = Observable.of(
            searchBar.rx.textDidBeginEditing.map { return true },
            searchBar.rx.textDidEndEditing.map { return false } )
            .merge()
        
        shouldShowCancelButton.subscribe(onNext: { [searchBar] shouldShow in
            searchBar?.showsCancelButton = shouldShow
            if(!shouldShow){
                
            }
        }).addDisposableTo(disposeBag)
        
        searchBar.rx.cancelButtonClicked.subscribe(onNext: { [searchBar] in
            searchBar?.resignFirstResponder()
        }).addDisposableTo(disposeBag)
        
        songs.bind(to: tableView.rx.items(cellIdentifier: "ITunesSongsCell", cellType: ITunesSongsCell.self)) { index, song, cell in
            cell.render(songRenderable: song)
            }.addDisposableTo(disposeBag)
    }
    
    
    @IBAction func goBack(_ sender: Any) {
        Sound.stopAll()
        self.dismiss(animated: true, completion: nil)
    }
    
    private lazy var searchText: Observable<String> = {
        return self.searchBar.rx.text.orEmpty.asObservable()
            .skip(1) //skip looking for empty string
    }()
    
    var songs: Observable<[SongRenderable]> {
        return Observable.of(fetchSongs.do(onNext: {[unowned self] _ in
            self.tableView.refreshControl?.endRefreshing() }),
                             clearPreviousTracksOnTextChanged).merge()
    }
    
    private var fetchSongs: Observable<[SongRenderable]> {
        let refreshLastQueryOnPullToRefresh = isRefreshing.filter { $0 == true }
            .withLatestFrom(term)
        
        return Observable.of(term, refreshLastQueryOnPullToRefresh).merge()
            .flatMapLatest { [api] term in
                return api.rx.request(Endpoint.getSongs(forTerm: term))
                    .map { return $0.map(SongRenderable.init) }
        }
    }
    
    private lazy var term: Observable<String> = {
        return self.searchText
            .debounce(0.45, scheduler: MainScheduler.instance) //0.7 cause API limits number of calls per minute to 25
            .filter(self.filterTerm(containsLessCharactersThan: 3)) // min 3 chars for the same reason as ^
    }()
    
    private func filterTerm(containsLessCharactersThan minimumCharacters: Int) -> (String) -> Bool {
        return { term in
            return term.characters.count >= minimumCharacters
        }
    }
    
    private lazy var isRefreshing: Observable<Bool> = {
        let refreshControl = self.tableView.refreshControl
        return refreshControl?.rx.controlEvent(.valueChanged)
            .map { return refreshControl?.isRefreshing ?? false }
            ?? .just(false)
    }()
    
    private var clearPreviousTracksOnTextChanged: Observable<[SongRenderable]> {
        return searchText
            .filter(self.filterTerm(containsLessCharactersThan: 3))
            .map { _ in
                return [SongRenderable]()
        }
    }
    
}
