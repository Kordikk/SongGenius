//
//  DataAccess.swift
//  Song Genius
//
//  Created by Kordian Ledzion on 14.06.2017.
//  Copyright © 2017 KordianLedzion. All rights reserved.
//

import Foundation
import RealmSwift

//Not final for testing purposes

public class DataAccess {
    
    static let access = DataAccess()
    private var db: Realm!
    
    private init() {
        self.db = try! Realm()
    }
    
    //Used for filtering/fetching songs. Just fetch all songs to your local var and display filtered result
    
    public func getSongs() -> [Song] {
        return Array(db.objects(Song.self))
    }
    
    // Keep that db thread-safe 🙏
    
    public func synchronize(song: Song) {
        try! db.write {
            db.add(song)
        }
    }
    
    //If you'd rather do filtering with calls do the database instead of local var, use this
    
    public func getSongsFor(keyword: String) -> [Song] {
        let predicate = NSPredicate(format: "name CONTAINS %@ OR artist CONTAINS %@ OR releaseYear CONTAINS %@", keyword, keyword, keyword)
        return Array(db.objects(Song.self).filter(predicate))
    }
}
