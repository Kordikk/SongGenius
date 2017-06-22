//
//  NoRxITunesViewController.swift
//  Song Genius
//
//  Created by Kordian Ledzion on 17.06.2017.
//  Copyright © 2017 KordianLedzion. All rights reserved.
//

import Foundation
import UIKit

class NoRxITunesViewController: UIViewController, UITableViewDataSource{
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var songs = [Song]()
    let api = API()
    var sortedByNameAscending = false
    var sortedByArtistAscending = false
    var sortedByReleaseYearAscending = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        searchBar.delegate = self
        tableView.delegate = self
    }
    
    func dismissKeyboard(){
        view.endEditing(true)
    }
    
    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func updateTableView(searchText: String) {
        songs.removeAll()
        _ = api.request(.getSongs(forTerm: searchText)){ success, songs in
            if(success) {
                for song in songs! {
                    self.songs.append(song)
                }
                self.tableView.reloadSections(IndexSet(integer: 0), with: .fade)
            } else {
                let alertController = UIAlertController(title: "ERROR", message: "No results or there was a connection problem", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func sortBy(_ sender: Any) {
        let alertController = UIAlertController(title: "Filters", message:
            "You can choose one way of sorting songs.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "By name", style: .default, handler: { [unowned self] _ in
            if(self.sortedByNameAscending) {
                self.songs.sort{$0.name.lowercased() < $1.name.lowercased()}
            } else {
                self.songs.sort{$0.name.lowercased() > $1.name.lowercased()}
            }
            self.sortedByNameAscending = !self.sortedByNameAscending
            self.tableView.reloadSections(IndexSet(integer: 0), with: .fade)
        }))
        
        alertController.addAction(UIAlertAction(title: "By artist", style: .default, handler: { [unowned self] _ in
            if(self.sortedByArtistAscending) {
                self.songs.sort{$0.artist.lowercased() < $1.artist.lowercased()}
            } else {
                self.songs.sort{$0.artist.lowercased() > $1.artist.lowercased()}
            }
            self.sortedByArtistAscending = !self.sortedByArtistAscending
            self.tableView.reloadSections(IndexSet(integer: 0), with: .fade)
        }))
        
        alertController.addAction(UIAlertAction(title: "By year", style: .default, handler: { [unowned self] _ in
            if(self.sortedByReleaseYearAscending) {
                self.songs.sort{$0.releaseYear < $1.releaseYear}
            } else {
                self.songs.sort{$0.releaseYear > $1.releaseYear}
            }
            self.sortedByReleaseYearAscending = !self.sortedByReleaseYearAscending
            self.tableView.reloadSections(IndexSet(integer: 0), with: .fade)
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    
}

extension NoRxITunesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "noRxITunesSongCell") as! NoRxITunesSongsCell
        let song = songs[indexPath.row]
        cell.title.text = "\(song.artist) - \(song.name)"
        cell.releaseYear.text = song.releaseYear
        return cell
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        dismissKeyboard()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let song = songs[indexPath.row]
        let alertController = UIAlertController(title: "Song", message:
            "You've chosen a song \(song.primaryKey) released in \(song.releaseYear ).", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Ok, cool", style: UIAlertActionStyle.default,handler: nil))
        alertController.addAction(UIAlertAction(title: "Go to iTunes", style: .default, handler: { _ in
            UIApplication.shared.open(URL(string: song.url)!, options: [:], completionHandler: nil)
        }))
        self.present(alertController, animated: true, completion: {
            tableView.deselectRow(at: indexPath, animated: true)
        })
    }
    
}

extension NoRxITunesViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if((searchText.characters.count > 2) && ((((searchText.components(separatedBy: " ")).count)-1) < searchText.characters.count)){
            NSObject.cancelPreviousPerformRequests(withTarget: self)
            perform(#selector(self.updateTableView(searchText:)), with: searchText, afterDelay: 0.45) //API limited calls so we can't filter during typing cause that would result in A LOT
        } else {
            NSObject.cancelPreviousPerformRequests(withTarget: self)
            songs.removeAll()
            self.tableView.reloadSections(IndexSet(integer: 0), with: .fade)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        dismissKeyboard()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dismissKeyboard()
    }
}
