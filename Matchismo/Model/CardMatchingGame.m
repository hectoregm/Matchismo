//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Hector Enrique Gomez Morales on 6/18/13.
//  Copyright (c) 2013 Hector Enrique Gomez Morales. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()
@property (strong, nonatomic) NSMutableArray *cards;
@property (readwrite, nonatomic) int score;
@property (readwrite, nonatomic) NSMutableArray *history;
@end


@implementation CardMatchingGame

- (NSMutableArray *)history
{
    if (!_history) _history = [[NSMutableArray alloc] init];
    return _history;
}

@synthesize numberOfMatchingCards = _numberOfMatchingCards;

- (NSUInteger)numberOfMatchingCards
{
    if(!_numberOfMatchingCards) {
        _numberOfMatchingCards = 2;
    }
    return _numberOfMatchingCards;
}

- (void)setNumberOfMatchingCards:(NSUInteger)numberOfMatchingCards
{
    if (numberOfMatchingCards < 2) {
        _numberOfMatchingCards = 2;
    } else if (numberOfMatchingCards > 3) {
        _numberOfMatchingCards = 3;
    } else {
        _numberOfMatchingCards = numberOfMatchingCards;
    }
}

- (NSMutableArray *)cards
{
    if(!_cards) _cards =[[NSMutableArray alloc] init];
    return _cards;
}

- (id)initWithCardCount:(NSUInteger)cardCount usingDeck:(Deck *)deck cardMatchMode:(NSUInteger)numCards
{
    self = [super init];
    if (self) {
        _numberOfMatchingCards = numCards;
        _flipCost = 1;
        _matchBonus = 4;
        _mismatchPenalty = 2;

        for (int i = 0; i < cardCount; i++) {
            Card *card = [deck drawRandomCard];
            if (!card) {
                self = nil;
            } else {
                self.cards[i] = card;
            }
        }
        
    }
    
    return self;
}

- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index < self.cards.count) ? self.cards[index] : nil;
}

- (void)flipCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];
    if (!card.isUnplayable) {
        if (!card.isFaceUp) {
            NSMutableArray *otherCards = [[NSMutableArray alloc] init];
            
            for (Card *otherCard in self.cards) {
                if(otherCard.isFaceUp && !otherCard.isUnplayable) {
                    [otherCards addObject:otherCard];
                }
            }
            
            NSMutableArray *allCards = [otherCards mutableCopy];
            [allCards addObject:card];
            
            if ([otherCards count] < self.numberOfMatchingCards - 1) {
                [self.history addObject:[[CardGameMove alloc] initWithMoveKind:MoveKindFlipUp
                                                                   cardsInPlay:allCards
                                                                    scoreDelta:0]];
            } else {
                int matchScore = [card match:otherCards];
                NSLog(@"Score: %d", matchScore);
                if (matchScore) {
                    card.unplayable = YES;
                    for (Card *otherCard in otherCards) {
                        otherCard.unplayable = YES;
                    }
                    self.score += matchScore * self.matchBonus;
                    [self.history addObject:[[CardGameMove alloc] initWithMoveKind:MoveKindMatch
                                                                       cardsInPlay:allCards
                                                                        scoreDelta:matchScore * self.matchBonus]];
                } else {
                    for (Card *otherCard in otherCards) {
                        otherCard.faceUp = NO;
                    }

                    self.score -= self.mismatchPenalty;
                    [self.history addObject:[[CardGameMove alloc] initWithMoveKind:MoveKindMismatch
                                                                       cardsInPlay:allCards
                                                                        scoreDelta:self.mismatchPenalty]];
                }
            }
            self.score -= self.flipCost;
        }
        card.faceUp = !card.isFaceUp;
    }
}
@end
