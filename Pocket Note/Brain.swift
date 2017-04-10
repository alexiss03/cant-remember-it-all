//
//  Brain.swift
//  Pocket Note
//
//  Created by Hanet on 4/5/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.

import UIKit

class Brain {
    
    func isDivisibleByThree(number: Int) -> Bool {
        return (number % 3 == 0)
    }
    
    func isDivisibleByFive(number: Int) -> Bool {
        return (number % 5 == 0)
    }
    
    
    func isDivisibleByFifteen(number: Int) -> Bool {
        return (number % 15 == 0)
    }
    
    func isDivisible(dividend: Int, divisor: Int) -> Bool {
        return (dividend % divisor == 0)
    }
    
    func check(number: Int) -> Move {
        if self.isDivisibleByFifteen(number: number) {
            return .fizzBuzz
        }
        else if self.isDivisibleByThree(number: number) {
            return .fizz
        }
        else if self.isDivisibleByFive(number: number) {
             return .buzz
        } else {
             return .number
        }
        
    }
}
