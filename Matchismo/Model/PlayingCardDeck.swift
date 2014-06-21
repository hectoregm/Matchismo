//
//  PlayingCardDeck.swift
//  Matchismo
//
//  Created by Hector Enrique Gomez Morales on 6/17/14.
//  Copyright (c) 2014 Hector Enrique Gomez Morales. All rights reserved.
//

import Foundation

class PlayingCardDeck: Deck {
    init() {
        super.init()
        for suit in PlayingCard.validSuits() {
            for var rank = 1; rank <= PlayingCard.maxRank(); rank++ {
                var card = PlayingCard(suit: suit, rank: rank)
                self.addCard(card)
                println(card.contents)
            }
        }
    }
}
