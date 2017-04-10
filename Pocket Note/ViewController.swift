//
//  ViewController.swift
//  Pocket Note
//
//  Created by Hanet on 3/28/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var game: Game?
    
    var gameScore: Int? {
        didSet{
            guard let unwrappedGameScore = gameScore else {
                print("Game score is nil")
                return
            }
            
            numberButton.setTitle("\(unwrappedGameScore)", for: .normal)
        }
    }
    
    @IBOutlet weak var numberButton: UIButton!
    @IBOutlet weak var fizzButton: UIButton!
    @IBOutlet weak var buzzButton: UIButton!
    @IBOutlet weak var fizzBuzzButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        game = Game()
        gameScore = 0
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func play(move:Move){
        guard let unwrappedGame = game else {
            print("Game is nil!")
            return
        }
        
        let response = unwrappedGame.play(move: move)
        gameScore = response.score
    }
    
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        switch sender {
            case numberButton:
                play(move: .number)
            case fizzButton:
                play(move: .fizz)
            case buzzButton:
                play(move: .buzz)
            case fizzBuzzButton:
                play(move: .fizzBuzz)
            default:
                break
        }
    }
    


}

