//
//  ViewController.swift
//  Song Genius
//
//  Created by Kordian Ledzion on 14.06.2017.
//  Copyright © 2017 KordianLedzion. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var songs = [Song]()

    override func viewDidLoad() {
        songs = DataAccess.access.getSongs()
        print(songs[0].name)
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

