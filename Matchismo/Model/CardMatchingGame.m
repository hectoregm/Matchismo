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

- (int)numberOfMatchingCards
{
    if(!_numberOfMatchingCards) {
        _numberOfMatchingCards = 2;
    }
    return _numberOfMatchingCards;
}

- (void)setNumberOfMatchingCards:(int)numberOfMatchingCards
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

- (id)initWithCardCount:(NSUInteger)cardCount usingDeck:(Deck *)deck
{
    self = [super init];
    if (self) {
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

#define FLIP_COST 1
#define MATCH_BONUS 4
#define MISMATCH_PENALTY 2

- (void)flipCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];
    if (!card.isUnplayable) {
        if (!card.isFaceUp) {
            NSMutableArray *otherCards = [[NSMutableArray alloc] init];
            NSMutableArray *otherContents = [[NSMutableArray alloc] init];
            NSString *lastAction;
            
            for (Card *otherCard in self.cards) {
                if(otherCard.isFaceUp && !otherCard.isUnplayable) {
                    [otherCards addObject:otherCard];
                    [otherContents addObject:otherCard.contents];
                }
            }
            
            if ([otherCards count] < self.numberOfMatchingCards - 1) {
                [self.history addObject:[NSString stringWithFormat:@"Flipped up %@", card.contents]];
            } else {
                int matchScore = [card match:otherCards];
                NSLog(@"Score: %d", matchScore);
                if (matchScore) {
                    card.unplayable = YES;
                    for (Card *otherCard in otherCards) {
                        otherCard.unplayable = YES;
                    }
                    self.score += matchScore * MATCH_BONUS;
                    lastAction = [NSString stringWithFormat:@"Matched %@ & %@ for %d points",
                                                card.contents,
                                                [otherContents componentsJoinedByString:@" & "],
                                                matchScore * MATCH_BONUS];
                } else {
                    for (Card *otherCard in otherCards) {
                        otherCard.faceUp = NO;
                    }

                    self.score -= MISMATCH_PENALTY;
                    lastAction = [NSString stringWithFormat:@"%@ and %@ don't match! %d point penalty!",
                                                card.contents,
                                                [otherContents componentsJoinedByString:@" & "],
                                                MISMATCH_PENALTY];
                }
                [self.history addObject:lastAction];
            }
            self.score -= FLIP_COST;
        }
        card.faceUp = !card.isFaceUp;
    }
}
@end
