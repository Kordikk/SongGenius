//
//  Song_GeniusUITests.swift
//  Song GeniusUITests
//
//  Created by Kordian Ledzion on 14.06.2017.
//  Copyright © 2017 KordianLedzion. All rights reserved.
//

import XCTest

class Song_GeniusUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        XCUIDevice.shared().orientation = .portrait
        XCUIDevice.shared().orientation = .portrait
        XCUIDevice.shared().orientation = .landscapeLeft
        XCUIDevice.shared().orientation = .landscapeRight
        
        let app = XCUIApplication()
        app.otherElements.containing(.image, identifier:"logo").children(matching: .other).element.tap()
        app.buttons["BETA RX"].tap()
        app.navigationBars["iTunes Songs"].buttons["Back"].tap()
        app.buttons["iTunes"].tap()
        XCUIDevice.shared().orientation = .portrait
        XCUIDevice.shared().orientation = .landscapeLeft
        
        let searchForMin2CharactersSpacesNotIncludedSearchField = app.searchFields["Search for min 2 characters (spaces not included)"]
        searchForMin2CharactersSpacesNotIncludedSearchField.tap()
        searchForMin2CharactersSpacesNotIncludedSearchField.typeText("Adel")
        XCUIDevice.shared().orientation = .portrait
        searchForMin2CharactersSpacesNotIncludedSearchField.tap()
        searchForMin2CharactersSpacesNotIncludedSearchField.typeText("Cigarettes")
        app.keys["spacja"].tap()
        searchForMin2CharactersSpacesNotIncludedSearchField.typeText(" aft")
        searchForMin2CharactersSpacesNotIncludedSearchField.buttons["Clear text"].tap()
        
    }
    
}
