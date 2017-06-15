//
//  ViewController.swift
//  Song Genius
//
//  Created by Kordian Ledzion on 14.06.2017.
//  Copyright © 2017 KordianLedzion. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var songs = [Song]()

    override func viewDidLoad() {
        songs = DataAccess.access.getSongs()
        tableView.dataSource = self
        searchBar.delegate = self
        tableView.delegate = self
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel!.text = songs[indexPath.row].primaryKey
        return cell
    }

}

extension ViewController: UITableViewDelegate {
    
}

extension ViewController: UISearchBarDelegate {
    
}
