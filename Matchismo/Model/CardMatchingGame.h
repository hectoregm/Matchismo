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
              usingDeck:(Deck *)deck;

- (CardGameMove *)flipCardAtIndex:(NSUInteger)index;

- (Card *)cardAtIndex:(NSUInteger)index;

- (NSUInteger)indexOfCard:(Card *)card;

- (NSUInteger)numberOfCardsInPlay;

- (NSArray *)addCardsToGame:(NSUInteger)count;

- (void)removeCardsFromGame:(NSArray *)cards;

@property (nonatomic, readonly) int score;
@property (nonatomic) NSUInteger numberOfMatchingCards;
@property (nonatomic, readonly) NSMutableArray *history;
@property (nonatomic) int flipCost;
@property (nonatomic) int matchBonus;
@property (nonatomic) int mismatchPenalty;
@property (nonatomic, readonly) Deck* deck;

@end
