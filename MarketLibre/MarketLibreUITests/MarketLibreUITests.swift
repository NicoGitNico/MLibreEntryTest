//
//  MarketLibreUITests.swift
//  MarketLibreUITests
//
//  Created by Nicolas Di Santi on 9/6/22.
//

import XCTest

class MarketLibreUITests: XCTestCase {
    
    let device = XCUIDevice.shared

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        
        let app = XCUIApplication()
        app.launch()
        device.orientation = UIDeviceOrientation.portrait
        
        
        app.textFields.firstMatch.tap()
        let navnTextField = app.textFields["SearchText"]
        navnTextField.tap()
        navnTextField.typeText("Auto")
        app.buttons["Search"].tap()
        sleep(2)
        app.staticTexts["ProductCell"].firstMatch.tap()
        sleep(1)
        app.images["ProductPicture"].firstMatch.tap()
        sleep(1)
        app.buttons["Close"].firstMatch.tap()
        app.buttons["Back"].firstMatch.tap()
        
        app.terminate()
        
    }
    
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
