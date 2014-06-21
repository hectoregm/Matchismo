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
    @lazy var deck: Deck = PlayingCardDeck()

    var flipCount: Int = 0 {
        didSet {
            flipsLabel.text = "Flips: \(flipCount)"
        }
    }
    
    @IBAction func touchCardButton(sender: UIButton) {
        
        if let title = sender.currentTitle {
            if title.bridgeToObjectiveC().length != 0 {
                sender.setBackgroundImage(UIImage(named: "cardback"),
                    forState: UIControlState.Normal)
                
                sender.setTitle("", forState: UIControlState.Normal)
                flipCount++
            } else {
                if let card = self.deck.drawRandomCard() {
                    sender.setBackgroundImage(UIImage(named: "cardfront"),
                        forState: UIControlState.Normal)
                    sender.setTitle(card.contents(), forState: UIControlState.Normal)
                    flipCount++
                }
            }
        } else {
            if let card = self.deck.drawRandomCard() {
                sender.setBackgroundImage(UIImage(named: "cardfront"),
                    forState: UIControlState.Normal)
                sender.setTitle(card.contents(), forState: UIControlState.Normal)
                flipCount++
            }
        }
    }
}

