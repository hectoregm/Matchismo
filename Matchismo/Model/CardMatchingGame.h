//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Hector Enrique Gomez Morales on 6/18/13.
//  Copyright (c) 2013 Hector Enrique Gomez Morales. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"
#import "CardGameMove.h"

@interface CardMatchingGame : NSObject

- (id)initWithCardCount:(NSUInteger)cardCount
              usingDeck:(Deck *)deck
          cardMatchMode:(NSUInteger)numCards;

- (void)flipCardAtIndex:(NSUInteger)index;

- (Card *)cardAtIndex:(NSUInteger)index;

@property (nonatomic, readonly) int score;
@property (nonatomic) NSUInteger numberOfMatchingCards;
@property (nonatomic, readonly) NSMutableArray *history;
@property (nonatomic) NSUInteger flipCost;
@property (nonatomic) NSUInteger matchBonus;
@property (nonatomic) NSUInteger mismatchPenalty;

@end
