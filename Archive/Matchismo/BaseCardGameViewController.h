//
//  BaseCardGameViewController.h
//  Matchismo
//
//  Created by Hector Enrique Gomez Morales on 6/23/13.
//  Copyright (c) 2013 Hector Enrique Gomez Morales. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardMatchingGame.h"

@interface BaseCardGameViewController : UIViewController
@property (readonly, nonatomic) NSUInteger startingCardCount; // abstract
@property (readonly, nonatomic) BOOL removeCardMatches; // abstract
@property (readonly, nonatomic) NSString *reuseIdentifier; //abstract

- (Deck *)createDeck; // Abstract
- (NSString *)gameType; // Abstract
- (void)setGameSettings:(CardMatchingGame *)game; // Abstract
- (void)updateLastAction:(CardGameMove *)move; // Abstract
- (void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card animate:(BOOL) animate; // abstract
- (NSIndexPath *)indexPathOfCard:(Card *)card; // Abstract
- (void)resetUI;

@end
