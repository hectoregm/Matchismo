//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Hector Enrique Gomez Morales on 6/15/13.
//  Copyright (c) 2013 Hector Enrique Gomez Morales. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "PlayingCardView.h"
#import "PlayingCardCollectionViewCell.h"

@interface CardGameViewController ()
@property (strong, nonatomic) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UILabel *lastActionLabel;
@end

@implementation CardGameViewController

@dynamic game;
@dynamic lastActionLabel;

#define STARTING_CARD_COUNT 22

- (Deck *)createDeck
{
    return [[PlayingCardDeck alloc] init];
}

- (NSUInteger)startingCardCount
{
    return STARTING_CARD_COUNT;
}

- (NSString *)gameType
{
     return @"Card Game";
}

- (NSString *)reuseIdentifier
{
    return @"PlayingCard";
}

- (BOOL)removeCardMatches
{
    return NO;
}

- (void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card animate:(BOOL)animate
{
    if ([cell isKindOfClass:[PlayingCardCollectionViewCell class]]) {
        PlayingCardView *playingCardView = ((PlayingCardCollectionViewCell *)cell).playingCardView;
        if ([card isKindOfClass:[PlayingCard class]]) {
            PlayingCard *playingCard = (PlayingCard *)card;
            playingCardView.rank = playingCard.rank;
            playingCardView.suit = playingCard.suit;
            
            if ((playingCardView.faceUp != playingCard.faceUp) && animate) {
                [UIView transitionWithView:playingCardView
                                  duration:0.5
                                   options:UIViewAnimationOptionTransitionFlipFromLeft
                                animations:^{
                                    playingCardView.faceUp = playingCard.isFaceUp;
                                }
                                completion:NULL];
            } else {
                playingCardView.faceUp = playingCard.isFaceUp;
            }
            
            playingCardView.alpha = playingCard.isUnplayable ? 0.3 : 1.0;
        }
    }
}

- (void)updateLastAction
{
    NSString *lastActionText;
    if ([[self.game.history lastObject] isKindOfClass:[CardGameMove class]]) {
        CardGameMove *lastMove = (CardGameMove *)[self.game.history lastObject];
        
        NSMutableArray *cardContents = [[NSMutableArray alloc] init];
        for (Card *card in lastMove.cardsInPlay) {
            [cardContents addObject:card.contents];
        }
        
        switch (lastMove.moveKind) {
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
