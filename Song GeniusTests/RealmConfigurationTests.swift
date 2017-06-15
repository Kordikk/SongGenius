//
//  RealmConfigurationTests.swift
//  Song Genius
//
//  Created by Kordian Ledzion on 15.06.2017.
//  Copyright © 2017 KordianLedzion. All rights reserved.
//

import XCTest
import RealmSwift
@testable import Song_Genius

class MockRealmConfiguration {
    
    static var exp: XCTestExpectation?
    
    static func run() {
        let realm = try! Realm()
        if let path = Bundle.main.path(forResource: "songs", ofType: "csv") {
            let contents = try! String(contentsOfFile: path)
            try! realm.write {
                realm.deleteAll()
                contents.enumerateLines { (line, _) in
                    let split = line.components(separatedBy: ";")
                    let elem = Song(name: split[0], artist: split[1], releaseYear: split[2])
                    realm.add(elem)
                }
            }
        } else { return }
        MockRealmConfiguration.exp?.fulfill()
    }
}

class RealmConfigurationTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testInitialDatabaseLoadUnderOneTenthOfSecond() {
        //GIVEN
        
        MockRealmConfiguration.exp = expectation(description: "LOADED")
        
        //WHEN
        
        MockRealmConfiguration.run()
        let db = DataAccess.access.getSongs()
        
        //THEN
        
        wait(for: [(MockRealmConfiguration.exp)!], timeout: 0.1)
        XCTAssert(db.count > 0)
    }
    
}
