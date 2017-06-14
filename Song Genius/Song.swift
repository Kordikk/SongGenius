//
//  Song.swift
//  Song Genius
//
//  Created by Kordian Ledzion on 14.06.2017.
//  Copyright © 2017 KordianLedzion. All rights reserved.
//

import Foundation
import RealmSwift

public class Song: Object {
    
    dynamic var name: String = ""
    dynamic var artist: String = ""
    dynamic var releaseYear: String = ""
    dynamic var primaryKey: String = ""
    
    convenience init(name: String, artist: String, releaseYear: String) {
        self.init()
        self.name = name
        self.artist = artist
        self.releaseYear = releaseYear
        self.primaryKey = "\(self.name) by \(self.artist)"
    }
    
}