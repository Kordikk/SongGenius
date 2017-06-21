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
    var songs = [Song]()
    var filtered = [Song]()
    var searchActive = false

    override func viewDidLoad() {
        super.viewDidLoad()
        songs = DataAccess.access.getSongs()
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
        alertController.addAction(UIAlertAction(title: "By name", style: .default, handler: { [unowned self] _ in
            self.songs.sort{$0.name < $1.name}
            self.tableView.reloadSections(IndexSet(integer: 0), with: .fade)
        }))

        alertController.addAction(UIAlertAction(title: "By artist", style: .default, handler: { [unowned self] _ in
            self.songs.sort{$0.artist < $1.artist}
            self.tableView.reloadSections(IndexSet(integer: 0), with: .fade)
        }))
        alertController.addAction(UIAlertAction(title: "By year", style: .default, handler: { [unowned self] _ in
            self.songs.sort{$0.releaseYear < $1.releaseYear}
            self.tableView.reloadSections(IndexSet(integer: 0), with: .fade)
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func dismissKeyboard(){
        searchActive = false
        view.endEditing(true)
    }
    
}

extension LocalSongsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchActive) {
            return filtered.count
        } else {
            return songs.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "localSongsCell") as! LocalSongsCell
        var song: Song?
        if(!searchActive) {
            song = songs[indexPath.row]
        } else {
            song = filtered[indexPath.row]
        }
        cell.title.text = "\(song!.artist) - \(song!.name)"
        cell.releaseYear.text = song!.releaseYear
        return cell
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        dismissKeyboard()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var song: Song?
        if(!searchActive) {
            song = songs[indexPath.row]
        } else {
            song = filtered[indexPath.row]
        }
        let alertController = UIAlertController(title: "Song", message:
            "You've chosen a song \(song?.primaryKey ?? "") released in \(song?.releaseYear ?? "year only artists knows : (").", preferredStyle: UIAlertControllerStyle.alert)
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
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filtered = songs.filter{ (song:Song) -> Bool in
            var searchText = searchText.replacingOccurrences(of: "'", with: "")
            searchText = searchText.replacingOccurrences(of: "/", with: "")
            searchText = searchText.replacingOccurrences(of: "!", with: "")
            searchText = searchText.replacingOccurrences(of: "-", with: "")
            var name = song.name
            var artist = song.artist
            name = name.replacingOccurrences(of: "'", with: "")
            name = name.replacingOccurrences(of: "!", with: "")
            name = name.replacingOccurrences(of: "-", with: "")
            name = name.replacingOccurrences(of: "/", with: "/")
            artist = artist.replacingOccurrences(of: "-", with: "")
            artist = artist.replacingOccurrences(of: "!", with: "")
            artist = artist.replacingOccurrences(of: "/", with: "")
            artist = artist.replacingOccurrences(of: "'", with: "")
            let isName = name.lowercased().contains(searchText.lowercased())
            let isArtist = artist.lowercased().contains(searchText.lowercased())
            let isYear = song.releaseYear.lowercased().contains(searchText.lowercased())
            return isName || isArtist || isYear
        }
        if(searchText == ""){
            searchActive = false
        } else {
            searchActive = true
        }
        self.tableView.reloadSections(IndexSet(integer: 0), with: .fade)
    }
    
}
