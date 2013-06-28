//
//  BaseCardGameViewController.m
//  Matchismo
//
//  Created by Hector Enrique Gomez Morales on 6/23/13.
//  Copyright (c) 2013 Hector Enrique Gomez Morales. All rights reserved.
//

#import "BaseCardGameViewController.h"

@interface BaseCardGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int flipCount;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (strong, nonatomic) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastActionLabel;
@end

@implementation BaseCardGameViewController

- (CardMatchingGame *)game
{
    if (!_game) {
        _game = [[CardMatchingGame alloc] initWithCardCount:self.cardButtons.count
                                                  usingDeck:[self createDeck]];
        [self setGameSettings:_game];
    }
    return _game;
}

- (Deck *)createDeck // Abstract
{
    // Implement on your subclass
    return nil;
}

- (void)setGameSettings:(CardMatchingGame *)game // Abstract
{
    // Implement on your subclass
}

- (void)setCardButtons:(NSArray *)cardButtons
{
    _cardButtons = cardButtons;
    [self updateUI];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.lastActionLabel.text = @"";
}

- (void)updateUI
{
    [self updateGrid];
    [self updateLastAction];
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
}

- (void)updateGrid
{
    // Implement on your subclass
}

- (void)updateLastAction
{
    // Implement on your subclass
}

- (void)setFlipCount:(int)flipCount
{
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
}

- (IBAction)flipCard:(UIButton *)sender {
    [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
    self.flipCount++;
    [self updateUI];
}

- (IBAction)dealNewGame {
    NSLog(@"Dealing New Game...");
    self.game = nil;
    self.flipCount = 0;
    self.lastActionLabel.text = @"";
    [self updateUI];
}

@end
