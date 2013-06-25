//
//  BaseCardGameViewController.m
//  Matchismo
//
//  Created by Hector Enrique Gomez Morales on 6/23/13.
//  Copyright (c) 2013 Hector Enrique Gomez Morales. All rights reserved.
//

#import "BaseCardGameViewController.h"
#import "CardMatchingGame.h"

@interface BaseCardGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int flipCount;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (strong, nonatomic) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastActionLabel;
@end

@implementation BaseCardGameViewController

- (void)setCardButtons:(NSArray *)cardButtons
{
    _cardButtons = cardButtons;
    NSLog(@"Setting buttons labels");
    [self updateUI];
}

- (void)viewDidLoad {
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
    NSString *lastActionText = nil;
    if ([[self.game.history lastObject] isKindOfClass:[CardGameMove class]]) {
        CardGameMove *lastMove = (CardGameMove *)[self.game.history lastObject];
        
        NSMutableArray *cardContents = [[NSMutableArray alloc] init];
        for (Card *card in lastMove.cardsInPlay) {
            [cardContents addObject:card.contents];
        }
        
        switch (lastMove.modeKind) {
            case MoveKindFlipUp:
                lastActionText = [NSString stringWithFormat:@"Flipped up %@", [cardContents lastObject]];
                break;
            case MoveKindMatch:
                lastActionText = [NSString stringWithFormat:@"Matched %@ for %d points", [cardContents componentsJoinedByString:@" & "], lastMove.scoreDelta];
                break;
            case MoveKindMismatch:
                lastActionText = [NSString stringWithFormat:@"%@ don't match! %d point penalty!", [cardContents componentsJoinedByString:@" & "], lastMove.scoreDelta];
                break;
            default:
                lastActionText = @"";
                break;
        }
        self.lastActionLabel.text = lastActionText;
    }
}

- (void)setFlipCount:(int)flipCount
{
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
}

- (IBAction)flipCard:(UIButton *)sender {
    NSLog(@"In flipCard");
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
