//
//  PlayingCard.swift
//  Matchismo
//
//  Created by Hector Enrique Gomez Morales on 6/17/14.
//  Copyright (c) 2014 Hector Enrique Gomez Morales. All rights reserved.
//

import Foundation

class PlayingCard: Card {
    var _suit: String?
    var suit: String?  {
    get {
        return _suit ? _suit : "?"
    }
    set {
        if let value = newValue {
            if contains(PlayingCard.validSuits(), value) {
                _suit = value
            }
        } else {
            _suit = nil
        }
    }
    }
    var rank: Int?
    
    init(suit: String, rank: Int) {
        self._suit = suit
        self.rank = rank
        super.init()
    }
    
    override func contents() -> String {
        let rankStrings = PlayingCard.rankStrings()
        let urank = rank ? rank : 0
        return "\(rankStrings[urank!])\(suit)"
    }
    
    class func validSuits() -> String[] {
        return ["♥", "♦", "♠", "♣"]
    }
    
    class func rankStrings() -> String[] {
        return ["?", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"]
    }
    
    class func maxRank() -> Int {
        return PlayingCard.rankStrings().count - 1
    }
}