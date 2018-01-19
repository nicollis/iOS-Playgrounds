//
//  TestingWithSwiftTests.swift
//  TestingWithSwiftTests
//
//  Created by Nic Ollis on 1/18/18.
//  Copyright © 2018 Ollis. All rights reserved.
//

import XCTest
@testable import TestingWithSwift

class TestingWithSwiftTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAllWordsLoaded() {
        let playData = PlayData()
        XCTAssertEqual(playData.allWords.count, 18440, "allWords was not 18440")
    }
    
    func testWordCountsAreCorrect() {
        let playData = PlayData()
        XCTAssertEqual(playData.wordCounts.count(for: "home"), 174, "Home doesn't appear correct")
        XCTAssertEqual(playData.wordCounts.count(for: "fun"), 4, "Home doesn't appear correct")
        XCTAssertEqual(playData.wordCounts.count(for: "mortal"), 41, "Home doesn't appear correct")
    }
    
    func testWordsLoadQuickly() {
        measure {
            _ = PlayData()
        }
    }
    
    func testUserFilterWorks() {
        let playData = PlayData()
        
        playData.applyUser(filter: "100")
        XCTAssertEqual(playData.filteredWords.count, 495)
        
        playData.applyUser(filter: "1000")
        XCTAssertEqual(playData.filteredWords.count, 55)
        
        playData.applyUser(filter: "10000")
        XCTAssertEqual(playData.filteredWords.count, 1)
        
        playData.applyUser(filter: "test")
        XCTAssertEqual(playData.filteredWords.count, 56)
        
        playData.applyUser(filter: "swift")
        XCTAssertEqual(playData.filteredWords.count, 7)
        
        playData.applyUser(filter: "objective-c")
        XCTAssertEqual(playData.filteredWords.count, 0)
    }
}
