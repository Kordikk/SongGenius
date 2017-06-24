//
//  ViewController.swift
//  Song Genius
//
//  Created by Kordian Ledzion on 14.06.2017.
//  Copyright © 2017 KordianLedzion. All rights reserved.
//

import UIKit

class LocalSongsViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    let songsManager = SongsManager()
    var sortedByNameAscending = false
    var sortedByArtistAscending = false
    var sortedByReleaseYearAscending = false

    override func viewDidLoad() {
        songsManager.loadSongsFromLocal()
        super.viewDidLoad()
        tableView.dataSource = self
        searchBar.delegate = self
        tableView.delegate = self
    }

    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sortBy(_ sender: Any) {
        let alertController = UIAlertController(title: "Filters", message:
            "You can choose one way of sorting songs.", preferredStyle: .alert)
        
        //sorting by song's name
        alertController.addAction(UIAlertAction(title: "By name", style: .default, handler: { [unowned self] _ in
            if(self.sortedByNameAscending) {
                self.songsManager.sort(.byNameDescending)
            } else {
                self.songsManager.sort(.byNameAscending)
            }
            self.sortedByNameAscending = !self.sortedByNameAscending
            self.tableView.reloadSections(IndexSet(integer: 0), with: .fade)
        }))

        //sorting by Artist's name
        alertController.addAction(UIAlertAction(title: "By artist", style: .default, handler: { [unowned self] _ in
            if(self.sortedByArtistAscending) {
            self.songsManager.sort(.byArtistDescending)
            } else {
                self.songsManager.sort(.byArtistAscending)
            }
            self.sortedByArtistAscending = !self.sortedByArtistAscending
            self.tableView.reloadSections(IndexSet(integer: 0), with: .fade)
        }))
        
        //sorting by releaseYear
        alertController.addAction(UIAlertAction(title: "By year", style: .default, handler: { [unowned self] _ in
            if(self.sortedByReleaseYearAscending) {
            self.songsManager.sort(.byReleaseYearDescending)
            } else {
                self.songsManager.sort(.byReleaseYearAscending)
            }
            self.sortedByReleaseYearAscending = !self.sortedByReleaseYearAscending
            self.tableView.reloadSections(IndexSet(integer: 0), with: .fade)
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func dismissKeyboard(){
        view.endEditing(true)
    }
    
}

extension LocalSongsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songsManager.getCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "localSongsCell") as! LocalSongsCell
        let song = songsManager.getSong(indexPath.row)
        cell.title.text = "\(song.artist) - \(song.name)"
        cell.releaseYear.text = song.releaseYear
        return cell
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        dismissKeyboard()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let song = songsManager.getSong(indexPath.row)
        let alertController = UIAlertController(title: "Song", message:
            "You've chosen a song \(song.primaryKey) released in \(song.releaseYear == "" ? song.releaseYear : "year only artists knows : (").", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Ok, cool", style: UIAlertActionStyle.default,handler: nil))
        
        self.present(alertController, animated: true, completion: {
            tableView.deselectRow(at: indexPath, animated: true)
        })
    }

}

extension LocalSongsViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dismissKeyboard()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchText == "") {
            songsManager.loadSongsFromLocal()
        } else {
            songsManager.setSongs(searchText)
        }
        self.tableView.reloadSections(IndexSet(integer: 0), with: .fade)
    }
    
}
