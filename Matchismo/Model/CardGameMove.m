//
//  GameMove.m
//  Matchismo
//
//  Created by Hector Enrique Gomez Morales on 6/25/13.
//  Copyright (c) 2013 Hector Enrique Gomez Morales. All rights reserved.
//

#import "CardGameMove.h"

@implementation CardGameMove

-(id)initWithMoveKind:(MoveKindType)aMoveKind cardsInPlay:(NSArray *)anArrayOfCards scoreDelta:(NSInteger)aScoreDelta
{
    self = [super init];
    
    if (self) {
        _moveKind = aMoveKind;
        _cardsInPlay = anArrayOfCards;
        _scoreDelta = aScoreDelta;
    }
    return self;
}

@end
