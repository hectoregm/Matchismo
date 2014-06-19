//
//  Deck.swift
//  Matchismo
//
//  Created by Hector Enrique Gomez Morales on 6/17/14.
//  Copyright (c) 2014 Hector Enrique Gomez Morales. All rights reserved.
//

import Foundation

class Deck {
    var cards: Card[] = []

    func addCard(card: Card, atTop: Bool) {
        if atTop {
            cards.insert(card, atIndex: 0)
        } else {
            cards.append(card)
        }
    }
    
    func addCard(card: Card) {
        addCard(card, atTop: false)
    }
    
    func drawRandomCard() -> Card? {
        var randomCard: Card?
        
        if cards.count > 0 {
            let index = Int(arc4random()) % cards.count
            
            randomCard = self.cards[index]
            cards.removeAtIndex(index)
        }

        return randomCard
    }
}