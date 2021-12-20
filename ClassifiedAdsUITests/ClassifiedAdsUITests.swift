//
//  ClassifiedAdsUITests.swift
//  ClassifiedAdsUITests
//
//  Created by Jeffrey Tabios on 12/20/21.
//

import XCTest

class ClassifiedAdsUITests: XCTestCase {

    func test_loadAppShouldDisplayItems() {
        let app = XCUIApplication()

        app.launch()
        
        let timeInSeconds = 10.0 // time you need for other tasks to be finished
        let expectation = XCTestExpectation(description: "Test data loads in cells")

        DispatchQueue.main.asyncAfter(deadline: .now() + timeInSeconds) {
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: timeInSeconds + 1.0)
        
        XCTAssert(app.collectionViews.children(matching: .cell).count > 0)
    }
}
