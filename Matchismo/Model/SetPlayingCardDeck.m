//
//  SetPlayingCardDeck.m
//  Matchismo
//
//  Created by Hector Enrique Gomez Morales on 6/23/13.
//  Copyright (c) 2013 Hector Enrique Gomez Morales. All rights reserved.
//

#import "SetPlayingCardDeck.h"

@implementation SetPlayingCardDeck

- (id) init
{
    self = [super init];
    if (self) {
        for (NSUInteger number = 1; number <= [SetPlayingCard maxNumber]; number++) {
            for (NSString *symbol in [SetPlayingCard validSymbols]) {
                for (NSString *shading in [SetPlayingCard validShadings]) {
                    for (NSString *color in [SetPlayingCard validColors]) {
                        SetPlayingCard *card = [[SetPlayingCard alloc] init];
                        card.number = number;
                        card.symbol = symbol;
                        card.shading = shading;
                        card.color = color;
                        [self addCard:card atTop:YES];
                    }
                }
            }
        }
        
    }
    
    return self;
}

@end
