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
@property (strong, nonatomic) Deck* deck;
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

- (NSUInteger)numberOfCardsInPlay
{
    return [self.cards count];
}

- (id)initWithCardCount:(NSUInteger)cardCount usingDeck:(Deck *)deck
{
    self = [super init];
    if (self) {
        _numberOfMatchingCards = 2;
        _flipCost = 1;
        _matchBonus = 4;
        _mismatchPenalty = 2;
        
        _deck = deck;

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

- (NSArray *)addCardsToGame:(NSUInteger)count
{
    NSMutableArray *newCards = [[NSMutableArray alloc] init];
    Card *newCard;
    for (int i = 0; i < count; i++) {
        newCard = [self.deck drawRandomCard];
        if (!newCard)
            break;
        
        [newCards addObject:newCard];
        [self.cards addObject:newCard];
    }
    
    return newCards;
}

- (void)removeCardsFromGame:(NSArray *)cards
{
    for (Card *card in cards) {
        [self.cards removeObject:card];
    }
}

- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index < self.cards.count) ? self.cards[index] : nil;
}

- (NSUInteger)indexOfCard:(Card *)card
{
    return [self.cards indexOfObject:card];
}

- (CardGameMove *)flipCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];
    CardGameMove *cardGameMove;

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
                cardGameMove = [[CardGameMove alloc] initWithMoveKind:MoveKindFlipUp
                                                          cardsInPlay:allCards
                                                           scoreDelta:0];
                [self.history addObject:cardGameMove];
            } else {
                int matchScore = [card match:otherCards];
                if (matchScore) {
                    card.unplayable = YES;
                    for (Card *otherCard in otherCards) {
                        otherCard.unplayable = YES;
                    }
                    self.score += matchScore * self.matchBonus;
                    cardGameMove = [[CardGameMove alloc] initWithMoveKind:MoveKindMatch
                                                              cardsInPlay:allCards
                                                               scoreDelta:matchScore * self.matchBonus];
                    [self.history addObject:cardGameMove];
                } else {
                    for (Card *otherCard in otherCards) {
                        otherCard.faceUp = NO;
                    }

                    self.score -= self.mismatchPenalty;
                    cardGameMove = [[CardGameMove alloc] initWithMoveKind:MoveKindMismatch
                                                              cardsInPlay:allCards
                                                               scoreDelta:self.mismatchPenalty];
                    [self.history addObject:cardGameMove];
                }
            }
            self.score -= self.flipCost;
        }
        card.faceUp = !card.isFaceUp;
    }
    
    return cardGameMove;
}
@end
