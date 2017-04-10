//
//  ViewControllerUnitTests.swift
//  PocketNote
//
//  Created by Hanet on 4/7/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import XCTest
@testable import PocketNote

class ViewControllerUnitTests: XCTestCase {
    
    
    var viewController: ViewController!
    
    override func setUp() {
        super.setUp()
        
        let storyboard = UIStoryboard(name:"FizzBuzz", bundle: Bundle.main)
        viewController = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        UIApplication.shared.keyWindow!.rootViewController = viewController
        
        
        let _ = viewController.view
    }
    
    
    override func tearDown() {
        super.tearDown()
    }
    
    
    func testMoveIncrementScore() {
        viewController.play(move:.number)
        let newScore = viewController.gameScore
        XCTAssertEqual(newScore, 1)
    }
    
    func testMove2IncrementScore() {
        viewController.play(move: .number)
        viewController.play(move: .number)
        let newScore = viewController.gameScore
        XCTAssertEqual(newScore, 2)
    }
    
    func testHasAGame() {
        XCTAssertNotNil(viewController.game)
    }
    
    
    func testFizzIncrementScore() {
        viewController.game?.score = 2
        viewController.play(move: .fizz)
        let newScore = viewController.gameScore
        XCTAssertEqual(newScore, 3)
    }
    
    func testFizzNotIncrementScore(){
        viewController.game?.score = 1
        viewController.play(move: .fizz)
        let newScore = viewController.gameScore
        XCTAssertEqual(newScore, 1)
    }
    
    
    func testBuzzIncrementScore() {
        viewController.game?.score = 4
        viewController.play(move: .buzz)
        let newScore = viewController.gameScore
        XCTAssertEqual(newScore, 5)
    }
    
    
    func testBuzzNotIncrementScore() {
        viewController.game?.score = 3
        viewController.play(move: .buzz)
        let newScore = viewController.gameScore
        XCTAssertEqual(newScore, 3)
    }
    
    func testFizzBuzzIncrementScore() {
        viewController.game?.score = 14
        viewController.play(move: .fizzBuzz)
        let newScore = viewController.gameScore
        XCTAssertEqual(newScore, 15)
    }
    
    func testFizzBuzzNotIncrementScore() {
        viewController.game?.score = 13
        viewController.play(move: .fizzBuzz)
        let newScore = viewController.gameScore
        XCTAssertEqual(newScore, 13)
    }
    
}
