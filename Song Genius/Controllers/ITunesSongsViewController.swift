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

class ITunesSongsViewController: UIViewController{//, UITableViewDataSource {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private lazy var searchText: Observable<String> = { //lazy for late init (on use init)
        return self.searchBar.rx.text.orEmpty.asObservable()
            .skip(1) //skip no text searched for
    }()
    
    private lazy var lookUp: Observable<String> = {
        return self.searchText
            .debounce(0.6, scheduler: MainScheduler.instance) //API limits to 25 calls per minute so we'll search if we are pretty sure that user is finished writing
            .filter(self.filterQuery())
    }()
    
    private func filterQuery() -> (String) -> Bool {
        return { query in
            return query.characters.count >= 3 //API limits to 25 calls per minute so we'll search for >2 chars
        }
    }
    
    private var clearPreviousTracksOnTextChanged: Observable<[SongRenderable]> {
        return searchText
            .filter(self.filterQuery())
            .map { _ in
                return [SongRenderable]()
        }
    }
    
}

extension ITunesSongsViewController: UITableViewDelegate {
    
}

extension ITunesSongsViewController: UISearchBarDelegate {
    
}
