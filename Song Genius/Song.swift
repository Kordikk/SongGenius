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
    dynamic var url: String = ""
    
    convenience init(name: String, artist: String, releaseYear: String, url: String = "") {
        self.init()
        self.name = name
        self.artist = artist
        self.releaseYear = releaseYear
        self.primaryKey = "\(self.name) by \(self.artist)"
        self.url = url
    }
    
    convenience init(song: Song) {
        self.init()
        self.name = song.name
        self.artist = song.artist
        self.releaseYear = song.releaseYear
        self.primaryKey = song.primaryKey
        self.url = song.url
    }
    
}
