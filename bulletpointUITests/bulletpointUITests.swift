//
//  bulletpointUITests.swift
//  bulletpointUITests
//
//  Created by Chris on 2015-12-10.
//
//

import XCTest

class bulletpointUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.


        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that theyrrr test. Doing this in setup will make sure it happens for each test method.
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()


        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {

        let app = XCUIApplication()
        snapshot("screenshot1")
        app.images["tutorial-slide1.png"].swipeLeft()
        app.images["tutorial-slide2.png"].swipeLeft()
        app.images["tutorial-slide3.png"].swipeLeft()
        app.images["tutorial-slide4.png"].swipeLeft()
        app.images["tutorial-slide5.png"].swipeLeft()
        app.images["tutorial-slide6.png"].swipeLeft();
        app.buttons["next button"].tap()
        snapshot("screenshot2")
        app.tables.staticTexts["Films to watch"].tap()
        snapshot("screenshot3")
        app.navigationBars["Films to watch"].buttons["backbutton"].tap()



        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
}
