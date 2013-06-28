//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Hector Enrique Gomez Morales on 6/15/13.
//  Copyright (c) 2013 Hector Enrique Gomez Morales. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"

@interface CardGameViewController ()
@property (strong, nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *lastActionLabel;
@end

@implementation CardGameViewController

@dynamic game;
@dynamic cardButtons;
@dynamic lastActionLabel;

- (Deck *)createDeck
{
    return [[PlayingCardDeck alloc] init];
}

- (void)updateGrid
{
    UIImage *cardBackImage = [UIImage imageNamed:@"cardback.jpg"];
    for (UIButton *cardButton in self.cardButtons) {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        [cardButton setTitle:card.contents forState:UIControlStateSelected];
        [cardButton setTitle:card.contents forState:UIControlStateSelected|UIControlStateDisabled];
        cardButton.selected = card.isFaceUp;
        if (!card.isFaceUp) {
            [cardButton setImage:cardBackImage forState:UIControlStateNormal];
        } else {
            [cardButton setImage:nil forState:UIControlStateNormal];
        }
        cardButton.enabled = !card.isUnplayable;
        cardButton.alpha = card.isUnplayable ? 0.3 : 1.0;
    }
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

@end
