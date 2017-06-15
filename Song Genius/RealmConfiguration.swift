//
//  RealmConfiguration.swift
//  Song Genius
//
//  Created by Kordian Ledzion on 14.06.2017.
//  Copyright © 2017 KordianLedzion. All rights reserved.
//

import Foundation
import RealmSwift

//Class used to init Realm db via AppDelegate and songs.csv file

public final class RealmConfiguration {

    public static func configure() {
        let realm = try! Realm()
        guard realm.isEmpty else {
            return
        }
        if let path = Bundle.main.path(forResource: "songs", ofType: "csv") {
            let contents = try! String(contentsOfFile: path)
            try! realm.write {
                contents.enumerateLines { (line, _) in
                    let split = line.components(separatedBy: ";")
                    let elem = Song(name: split[0], artist: split[1], releaseYear: split[2])
                    realm.add(elem)
                }
            }
        } else { return }
    }
    
}
