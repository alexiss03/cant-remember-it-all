//
//  PNCreatePostTest.swift
//  Pocket Note
//
//  Created by Hanet on 4/3/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import XCTest
@testable import PocketNote

class BrainTest: XCTestCase {
    
    let brain = Brain()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
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
    
    func testIsDivisibleByThree() {
        let result = brain.isDivisible(dividend: 3, divisor: 3)
        XCTAssertEqual(result, true)
    }
    
    
    func testIsNotDivisibleByThree() {
        let result = brain.isDivisible(dividend: 1, divisor: 3)
        XCTAssertEqual(result, false)
    }
    
    
    func testIsDivisibleByFive() {
        let result = brain.isDivisible(dividend: 5, divisor: 5)
        XCTAssertEqual(result, true)
    }
    
    
    func testIsNotDivisibleByFive() {
        let result = brain.isDivisible(dividend: 1, divisor: 5)
        XCTAssertEqual(result, false)
    }
    
    func testIsDivisibleByFifteen() {
        let result = brain.isDivisible(dividend: 15, divisor: 15)
        XCTAssertEqual(result, true)
    }
    
    func testIsNotDivisibleByFifteen() {
        let result = brain.isDivisible(dividend: 1, divisor: 15)
        XCTAssertEqual(result, false)
    }
    
    
    func testSayFizz() {
        let result = brain.check(number:3)
        XCTAssertEqual(result, .fizz)
    }
    
    func testSayBuzz() {
        let result = brain.check(number:5)
        XCTAssertEqual(result, .buzz)
    }
    
    func testSayFizzBuzz() {
        let result = brain.check(number:15)
        XCTAssertEqual(result, .fizzBuzz)
    }
    
    
    func testSay1() {
        let result = brain.check(number: 1)
        XCTAssertEqual(result, .number)
    }
    
}

