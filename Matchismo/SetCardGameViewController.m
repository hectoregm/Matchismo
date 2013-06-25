//
//  SetCardGameViewController.m
//  Matchismo
//
//  Created by Hector Enrique Gomez Morales on 6/23/13.
//  Copyright (c) 2013 Hector Enrique Gomez Morales. All rights reserved.
//

#import "SetCardGameViewController.h"
#import "CardMatchingGame.h"
#import "SetPlayingCardDeck.h"

@interface SetCardGameViewController ()
@property (strong, nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *lastActionLabel;
@end

@implementation SetCardGameViewController

@dynamic cardButtons;

- (CardMatchingGame *)game
{
    if (!_game) {
        _game = [[CardMatchingGame alloc] initWithCardCount:self.cardButtons.count
                                                  usingDeck:[[SetPlayingCardDeck alloc] init]
                                              cardMatchMode:3];
        _game.flipCost = 0;
        _game.matchBonus = 30;
        _game.mismatchPenalty = 5;
    }
    return _game;
}

- (void)updateGrid
{
    NSLog(@"In subclass updateUI");
    for (UIButton *cardButton in self.cardButtons) {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        [cardButton setAttributedTitle:[self styleCard:card] forState:UIControlStateNormal];
        [cardButton setTitle:card.contents forState:UIControlStateSelected|UIControlStateDisabled];
        if (card.isFaceUp) {
            cardButton.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.2];
        } else {
            cardButton.backgroundColor = nil;
        }
        cardButton.selected = card.isFaceUp;
        cardButton.enabled = !card.isUnplayable;
        cardButton.alpha = card.isUnplayable ? 0.3 : 1.0;
    }
}

- (NSAttributedString *)styleCard:(Card *)card
{
    NSMutableAttributedString *styledContent = nil;
    
    if ([card isKindOfClass:[SetPlayingCard class]]) {
        SetPlayingCard *setCard = (SetPlayingCard *)card;
        NSString *symbols = [setCard.symbol stringByPaddingToLength:setCard.number
                                                         withString:setCard.symbol
                                                    startingAtIndex:0];
        styledContent = [[NSMutableAttributedString alloc] initWithString:symbols];
        
        NSRange range = [[styledContent string] rangeOfString:symbols];
        NSDictionary *colors = @{@"red": [UIColor redColor], @"green": [UIColor greenColor], @"purple": [UIColor purpleColor]};
        NSDictionary *shadings = @{@"solid": @1.0, @"stripped": @0.3, @"outline": @0.0};
        NSLog(@"Shading is: %@ %f", setCard.shading, [(NSNumber *)shadings[setCard.shading] floatValue]);
        UIColor *colorWithShading = [colors[setCard.color] colorWithAlphaComponent:[(NSNumber *)shadings[setCard.shading] floatValue]];
        [styledContent addAttributes:@{NSForegroundColorAttributeName: colorWithShading,
          NSStrokeColorAttributeName: colors[setCard.color], NSStrokeWidthAttributeName: @-5} range:range];
        
    }
    
    return styledContent;
}

@end
