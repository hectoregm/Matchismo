//
//  Deck.h
//  Matchismo
//
//  Created by Hector Enrique Gomez Morales on 6/16/13.
//  Copyright (c) 2013 Hector Enrique Gomez Morales. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface Deck : NSObject

-(void)addCard:(Card *)card atTop:(BOOL)atTop;

-(Card *)drawRandomCard;

-(NSUInteger)numberOfCards;

@end
