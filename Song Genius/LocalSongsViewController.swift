//
//  ViewController.swift
//  Song Genius
//
//  Created by Kordian Ledzion on 14.06.2017.
//  Copyright © 2017 KordianLedzion. All rights reserved.
//

import UIKit

class LocalSongsViewController: UIViewController, UITableViewDataSource {
    
    let searchBar = UISearchBar()
    let tableView = UITableView()
    let songsManager = SongsManager()
    var sortedByNameAscending = false
    var sortedByArtistAscending = false
    var sortedByReleaseYearAscending = false

    override func viewDidLoad() {
        view.backgroundColor = UIColor(red: 244/255, green: 143/255, blue: 177/255, alpha: 1.0)
        songsManager.loadSongsFromLocal()
        super.viewDidLoad()
        setUpConstraints()
        tableView.dataSource = self
        searchBar.delegate = self
        tableView.delegate = self
        tableView.register(LocalSongsCell.self, forCellReuseIdentifier: "localSongsCell")
        tableView.rowHeight = 48.0
        let backButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(goBack(_:)))
        navigationItem.leftBarButtonItem = backButton
        let sortButton = UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(sortBy(_:)))
        navigationItem.rightBarButtonItem = sortButton
        automaticallyAdjustsScrollViewInsets = false
        tableView.contentInset = .zero
        navigationItem.title = "Local Storage"
        searchBar.isTranslucent = false
        searchBar.barTintColor = UIColor(red: 244/177, green: 143/255, blue: 177/255, alpha: 1.0)
    }
    
    func goBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func sortBy(_ sender: Any) {
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
    
    func setUpConstraints() {
        view.addSubview(tableView)
        view.addSubview(searchBar)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 0).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
    }
    
}




//Extenstion for TableView Delegate

extension LocalSongsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songsManager.getCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "localSongsCell") as! LocalSongsCell
        let song = songsManager.getSong(indexPath.row)
        cell.titleLabel.text = "\(song.artist) - \(song.name)"
        cell.releaseYearLabel.text = song.releaseYear
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        dismissKeyboard()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let song = songsManager.getSong(indexPath.row)
        let alertController = UIAlertController(title: "Song", message:
            "You've chosen a song \(song.primaryKey) released in \(song.releaseYear != "" ? song.releaseYear : "year only artists knows : (").", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Ok, cool", style: UIAlertActionStyle.default,handler: nil))
        
        self.present(alertController, animated: true, completion: {
            tableView.deselectRow(at: indexPath, animated: true)
        })
    }

}




//Extensions for SearchBar Delegate

extension LocalSongsViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dismissKeyboard()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            songsManager.setSongs(searchText)
        self.tableView.reloadSections(IndexSet(integer: 0), with: .fade)
    }
    
}
