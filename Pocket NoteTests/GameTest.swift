//
//  GameTest.swift
//  PocketNote
//
//  Created by Hanet on 4/6/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import XCTest
@testable import PocketNote

class GameTest: XCTestCase {
        
    let game = Game()
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testGameStartsAtZero() {
        XCTAssertTrue(game.score == 0)
    }
    
    
    func testOnPlayScoreIncremented() {
        _ = game.play(move: .number)
        XCTAssertTrue(game.score == 1)
    }
    
    func testOnPlayTwiceScoreIncremented() {
        game.score = 1
        _ = game.play(move: .number)
        XCTAssertTrue(game.score == 2)
    }
    
    
    func testIfMoveIsRight() {
        game.score = 2
        let result = game.play(move: .fizz)
        XCTAssertEqual(result.right, true)
    }
    
    func testIfPlayFizzScoreIsOne() {
        game.score = 1
        let result = game.play(move: .fizz)
        XCTAssertEqual(result.right, false)
    }
    
    func testIfCorrectBuzzMove() {
        game.score = 4
        let result = game.play(move: .buzz)
        XCTAssertEqual(result.right, true)
    }
    
    
    func testIfIncorrecBuzzMove() {
        game.score = 1
        let result = game.play(move: .buzz)
        XCTAssertEqual(result.right, false)
    }
    
    
    func testIfCorrectFizzBuzzMove() {
        game.score = 14
        let result = game.play(move: .fizzBuzz)
        XCTAssertEqual(result.right, true)
    }
    
    
    func testIfIncorrectFizzBuzzMove() {
        game.score = 1
        let result = game.play(move: .fizzBuzz)
        XCTAssertEqual(result.right, false)
    }
    
    
    func testIfCorrectNumberMove() {
        game.score = 1
        let result = game.play(move:.number)
        XCTAssertEqual(result.right, true)
    }
    
    func testIfIncorrectNumberMove() {
        game.score = 2
        let result = game.play(move:.number)
        XCTAssertEqual(result.right, false)
        
    }
    
    func testIfWrongMoveNotIncremented() {
        game.score = 1
        let _ = game.play(move: .fizz)
        XCTAssertEqual(game.score, 1)
    }
    
    func testPlayShouldReturnIfMoveRight() {
        let response = game.play(move: .number)
        XCTAssertNotNil(response.right)
    }
    
    func testPlayShouldReturnNewScore() {
        let response = game.play(move: .number)
        XCTAssertNotNil(response.score)
    }

    
}
