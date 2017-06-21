//
//  DataAccessTests.swift
//  Song Genius
//
//  Created by Kordian Ledzion on 15.06.2017.
//  Copyright © 2017 KordianLedzion. All rights reserved.
//

import XCTest
import RealmSwift
@testable import Song_Genius

class MockDataAccess {
    
    static let access = MockDataAccess()
    static var exp: XCTestExpectation?
    private var db: Realm!
    
    private init() {
        self.db = try! Realm()
    }
    
    public func getSongs() -> [Song] {
        let ret = Array(db.objects(Song.self))
        MockDataAccess.exp?.fulfill()
        return ret
    }
    
    public func getSongsFor(keyword: String) -> [Song] {
        let predicate = NSPredicate(format: "name CONTAINS %@ OR artist CONTAINS %@ OR releaseYear CONTAINS %@", keyword, keyword, keyword)
        let ret = Array(db.objects(Song.self).filter(predicate))
        MockDataAccess.exp?.fulfill()
        return ret
    }
}

class DataAccessTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testDatabaseLoadsUnderOneTenthOfSecond() {
        //GIVEN
        MockDataAccess.exp = expectation(description: "returned data")
        
        //WHEN
        
        let db = MockDataAccess.access.getSongs()
        
        //THEN
        
        wait(for: [(MockDataAccess.exp)!], timeout: 0.1)
        XCTAssert(db.count > 0)
    }
    
    func testFilteredDataUnderOneTenthOfSecond() {
        //GIVEN
        MockDataAccess.exp = expectation(description: "returned filtered data")
        
        //WHEN
        
        let db = MockDataAccess.access.getSongsFor(keyword: "1997")
        
        //THEN
        
        wait(for: [(MockDataAccess.exp)!], timeout: 0.1)
        XCTAssert(db[0].releaseYear == "1997" && db[db.count-1].releaseYear == "1997")
    }
    
}
