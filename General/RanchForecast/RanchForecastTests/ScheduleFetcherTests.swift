//
//  ScheduleFetcherTests.swift
//  RanchForecastTests
//
//  Created by Nicholas Ollis on 3/27/18.
//  Copyright © 2018 Big Nerd Ranch. All rights reserved.
//

import XCTest

@testable import RanchForecast

class ScheduleFetcherTests: XCTestCase {
    
    var fetcher: ScheduleFetcher!
    
    override func setUp() {
        super.setUp()
        fetcher = ScheduleFetcher(urlSession: Constants.session)
    }
    
    override func tearDown() {
        fetcher = nil
        super.tearDown()
    }
    
    func testCreateCourseFromValidDictionary() {
        let course: Course! = fetcher.parse(courseDictionary: Constants.validCourseDict)
        
        XCTAssertNotNil(course)
        XCTAssertEqual(course.title, Constants.title)
        XCTAssertEqual(course.url, Constants.url)
        XCTAssertEqual(course.nextStartDate, Constants.date)
    }
    
    func testCreateCourseFromInvalidDictionary() {
        let course: Course? = fetcher.parse(courseDictionary: Constants.invalidCourseDict)
        
        XCTAssertNil(course)
    }
    
    func testResultFromValidHttpResponseAndValidData() {
        let result = fetcher.digest(data: Constants.jsonData, response: Constants.okResponse, error: nil)
        
        switch result {
        case .success(let courses):
            XCTAssert(courses.count == 1)
            let theCourse = courses[0]
            XCTAssertEqual(theCourse.title, Constants.title)
            XCTAssertEqual(theCourse.url, Constants.url)
            XCTAssertEqual(theCourse.nextStartDate, Constants.date)
        default:
            XCTFail("Result contains Failure, but Success was expected.")
        }
    }
    
    func testFetchCoursesCompletionQueue() {
        let completionExpectation = expectation(description: "Execute completion closure")
        fetcher.fetchCourses { (result) -> (Void) in
            XCTAssertEqual(OperationQueue.current, OperationQueue.main, "Completion handler should run on the main thread; it did not")
            completionExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testResultFrom404HttpResponseAndNoData() {
        let result = fetcher.digest(data: nil, response: Constants.badResponse, error: nil)
        
        switch  result{
        case .failure(let error):
            XCTAssertEqual(error.localizedDescription, ScheduleFetcher.Error.unexpectedResponse(nil,nil).localizedDescription)
        default:
            XCTFail("Result contins Success, but Failure was expected.")
        }
    }
    
    func testResultsFromValidHTTPResponseAndInvalidData() {
        let result = fetcher.digest(data: Constants.badJsonData, response: Constants.okResponse, error: nil)
        
        switch  result{
        case .failure(let error):
            XCTAssertEqual(error.localizedDescription, ScheduleFetcher.Error.invalidJSON(Constants.badJsonData!).localizedDescription)
        default:
            XCTFail("Result contins Success, but Failure was expected.")
        }
    }
    
}
