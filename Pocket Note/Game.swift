//
//  Game.swift
//  PocketNote
//
//  Created by Hanet on 4/6/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import UIKit

class Game {

    var score: Int
    let brain = Brain()
    
    init() {
        score = 0
    }
    

    func play(move: Move) -> (right:Bool, score:Int) {
        let result = brain.check(number: score + 1)
        
        if result == move {
            score += 1
            return (true, score)
        } else {
            return (false, score)
        }
    }
}
