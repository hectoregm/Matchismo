//
//  GameMove.h
//  Matchismo
//
//  Created by Hector Enrique Gomez Morales on 6/25/13.
//  Copyright (c) 2013 Hector Enrique Gomez Morales. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, MoveKindType) {
    MoveKindFlipUp,
    MoveKindMatch,
    MoveKindMismatch
};

@interface CardGameMove : NSObject

- (id) initWithMoveKind:(MoveKindType)aMoveKind
            cardsInPlay:(NSArray *)anArrayOfCards
             scoreDelta:(NSInteger)aScoreDelta;

@property (readonly, nonatomic) MoveKindType modeKind;
@property (readonly, nonatomic) NSArray *cardsInPlay; // of Cards
@property (readonly, nonatomic) NSInteger scoreDelta;

@end
