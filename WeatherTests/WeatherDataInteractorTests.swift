//
//  WeatherDataInteractorTests.swift
//  WeatherTests
//
//  Created by Amar Sawant on 20/11/20.
//  Copyright © 2020 atsawant.com. All rights reserved.
//

import XCTest
@testable import Weather

class WeatherDataInteractorTests: XCTestCase {
    private var interactor: WeatherDataInteractor?
    
    override func setUpWithError() throws {
        interactor = WeatherDataInteractor()
    }
    
    override func tearDownWithError() throws {
    }
    
    func testRemoteCall() {
        let expectation = self.expectation(description: "Error recieving response")
        
        if let interactor = self.interactor {
            interactor.featchWeatherData(for: ["2643743": 2643743]) { (report, error) in
                if error != nil{
                    XCTFail("Test Failed: call to fetchRemoteData")
                }
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
}
