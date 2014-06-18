//
//  CardGameViewController.swift
//  Matchismo
//
//  Created by Hector Enrique Gomez Morales on 6/17/14.
//  Copyright (c) 2014 Hector Enrique Gomez Morales. All rights reserved.
//

import UIKit

class CardGameViewController: UIViewController {
    @IBOutlet var flipsLabel: UILabel
    var flipCount: Int = 0 {
        didSet {
            flipsLabel.text = "Flips: \(flipCount)"
        }
    }
    
    @IBAction func touchCardButton(sender: UIButton) {
        
        if sender.currentTitle.bridgeToObjectiveC().length != 0 {
            sender.setBackgroundImage(UIImage(named: "cardback"),
                forState: UIControlState.Normal)
            
            sender.setTitle("", forState: UIControlState.Normal)
        } else {
            sender.setBackgroundImage(UIImage(named: "cardfront"),
                forState: UIControlState.Normal)
            
            sender.setTitle("A♣︎", forState: UIControlState.Normal)
        }
        
        flipCount++
    }
}

