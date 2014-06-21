//
//  CardGameViewController.swift
//  Matchismo
//
//  Created by Hector Enrique Gomez Morales on 6/17/14.
//  Copyright (c) 2014 Hector Enrique Gomez Morales. All rights reserved.
//

import UIKit

class CardGameViewController: UIViewController {
    @IBOutlet var scoreLabel: UILabel
    @lazy  var deck: Deck = PlayingCardDeck()
    @lazy var cardButtons : UIButton[] = {
        var tempBtn: UIButton[] = []
        for v:AnyObject in self.view.subviews {
            if v is UIButton {
                tempBtn.append(v as UIButton)
            }
        }
        return tempBtn
        }()
    var _game: CardMatchingGame!
    var game: CardMatchingGame {
        get {
            if !_game {
                _game = CardMatchingGame(count: self.cardButtons.count,
                    deck: self.deck)
            }
            return _game
        }
    }

    @IBAction func touchCardButton(sender: UIButton) {
        var chosenButtonIndex:Int = 0
        for (i, val) in enumerate(cardButtons) {
            if sender == val {
                chosenButtonIndex = i
            }
        }
        game.chooseCardAtIndex(chosenButtonIndex)
        self.updateUI()
    }
    
    func updateUI() {
        for (i,cardButton) in enumerate(cardButtons) {
            var card = game.cards[i]
            cardButton.setTitle(self.titleForCard(card), forState: UIControlState.Normal)
            cardButton.setBackgroundImage(self.backgroundImageForCard(card), forState: UIControlState.Normal)
            cardButton.enabled = !card.matched
            scoreLabel.text = "Score: \(self.game.score)"
        }
    }
    
    func titleForCard(card:Card) -> String
    {
        return card.chosen ? card.contents() : ""
    }
    
    func backgroundImageForCard(card:Card) -> UIImage
    {
        return UIImage(named: card.chosen ? "cardfront" : "cardback")
    }
}

