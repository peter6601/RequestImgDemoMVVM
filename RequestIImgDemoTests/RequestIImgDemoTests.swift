//
//  RequestIImgDemoTests.swift
//  RequestIImgDemoTests
//
//  Created by PeterDing on 2018/5/5.
//  Copyright © 2018年 DinDin. All rights reserved.
//

import XCTest
@testable import RequestIImgDemo

class RequestIImgDemoTests: XCTestCase {
    var api: APIManager!

    override func setUp() {
        super.setUp()
        
        api = APIManager.shared
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    func testGetData() {
        let urlException = expectation(description: "get data")
        api.getSearchRequest(text: "test", url: TestURL.getSearch.rawValue, page: 1) { (data, error) in
            XCTAssertNotNil(data, "not nil data")
            XCTAssertNotNil(error, "not nil error")
            if let data = data {
                urlException.fulfill()

            }

        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testMockData() {
        api.setProvider(session: MockURLSession())
        api.getSearchRequest(text: "mock", url: "", page: 0) { (data, error) in
            XCTAssertNotNil(data, "not nil data")
            XCTAssertTrue("43069445870" == (data?.first?.id ?? ""), data?.first?.id ?? "")
        }
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
