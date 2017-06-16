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
}

extension LocalSongsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "localSongsCell") as! LocalSongsCell
        let song = songs[indexPath.row]
        cell.title.text = "\(song.artist) - \(song.name)"
        cell.releaseYear.text = song.releaseYear
        return cell
    }
    
}

extension LocalSongsViewController: UISearchBarDelegate {
    
    
    
}
