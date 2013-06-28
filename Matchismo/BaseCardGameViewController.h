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

- (Deck *)createDeck; // Abstract

- (NSString *)gameType; // Abstract

- (void)setGameSettings:(CardMatchingGame *)game; // Abstract

- (void)updateGrid; // Abstract

- (void)updateLastAction; // Abstract

@end
