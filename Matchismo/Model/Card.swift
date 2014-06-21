//
//  Card.swift
//  Matchismo
//
//  Created by Hector Enrique Gomez Morales on 6/17/14.
//  Copyright (c) 2014 Hector Enrique Gomez Morales. All rights reserved.
//

import Foundation

class Card {
    var chosen = false
    var matched = false
    
    func match(otherCards: Card[]) -> Int {
        var score = 0
        
        for card in otherCards {
            if card.contents() == self.contents() {
                score = 1
            }
        }
        
        return score
    }
    
    func contents() -> String {
        return "123"
    }
}