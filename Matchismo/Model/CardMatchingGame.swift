//
//  CardMatchingGame.swift
//  Matchismo
//
//  Created by Hector Enrique Gomez Morales on 6/20/14.
//  Copyright (c) 2014 Hector Enrique Gomez Morales. All rights reserved.
//

import Foundation

class CardMatchingGame {
    var score = 0
    var cards: Card[] = []

    let mismatchPenalty = 2
    let matchBonus =  4
    let costToChoose = 1
    
    init(count: Int, deck: Deck) {
        for i in 0..count {
            var card = deck.drawRandomCard()
            
            if card {
                self.cards.append(card!)
            } else {
                assert(false, "Deck is not large enough")
            }
        }
    }
    
    func cardAtIndex(index: Int) -> Card? {
        return (index  < self.cards.count) ? self.cards[index] : nil;
    }
    
    func chooseCardAtIndex(index: Int) {
        var card = self.cardAtIndex(index)
        
        if let c = card {
            if !c.matched {
                if c.chosen {
                    c.chosen = false
                } else {
                    for otherCard in self.cards {
                        if otherCard.chosen && !otherCard.matched {
                            let matchScore = c.match([otherCard])
                            if matchScore != 0 {
                                self.score += matchScore * self.matchBonus
                                c.matched = true
                                otherCard.matched = true
                            } else {
                                self.score -= self.mismatchPenalty
                                otherCard.chosen = false
                            }
                        }
                    }
                    self.score -= self.costToChoose
                    c.chosen = true
                }
            }
        }
    }
}
