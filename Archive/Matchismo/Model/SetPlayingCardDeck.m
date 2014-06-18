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
            for (NSUInteger symbol = 0; symbol < [[SetPlayingCard validSymbols] count]; symbol++) {
                for (NSUInteger shading = 0; shading < [[SetPlayingCard validShadings] count]; shading++) {
                    for (NSUInteger color = 0; color < [[SetPlayingCard validColors] count]; color++) {
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
