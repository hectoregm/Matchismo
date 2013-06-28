//
//  SetCardGameViewController.m
//  Matchismo
//
//  Created by Hector Enrique Gomez Morales on 6/23/13.
//  Copyright (c) 2013 Hector Enrique Gomez Morales. All rights reserved.
//

#import "SetCardGameViewController.h"
#import "SetPlayingCardDeck.h"

@interface SetCardGameViewController ()
@property (strong, nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *lastActionLabel;
@end

@implementation SetCardGameViewController

@dynamic cardButtons;
@dynamic game;
@dynamic lastActionLabel;

- (Deck *)createDeck
{
    return [[SetPlayingCardDeck alloc] init];
}

- (NSString *)gameType
{
    return @"Set Game";
}

- (void)setGameSettings:(CardMatchingGame *)game
{
    game.numberOfMatchingCards = 3;
    game.flipCost = 0;
    game.matchBonus = 30;
    game.mismatchPenalty = 5;
}

- (void)updateGrid
{
    for (UIButton *cardButton in self.cardButtons) {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        [cardButton setAttributedTitle:[self styleCard:card] forState:UIControlStateNormal];
        [cardButton setAttributedTitle:[self styleCard:card] forState:UIControlStateSelected|UIControlStateDisabled];
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

- (void)updateLastAction
{
    NSMutableAttributedString *lastActionText;
    if ([[self.game.history lastObject] isKindOfClass:[CardGameMove class]]) {
        CardGameMove *lastMove = (CardGameMove *)[self.game.history lastObject];
        
        switch (lastMove.modeKind) {
            case MoveKindFlipUp:
                lastActionText = [[NSMutableAttributedString alloc] initWithString:@"Flipped up "];
                [lastActionText appendAttributedString:[self styleCard:[lastMove.cardsInPlay lastObject]]];
                break;
            case MoveKindMatch:
                lastActionText = [[NSMutableAttributedString alloc] initWithString:@"Matched "];
                [lastActionText appendAttributedString:[self createAttributedfromCards:lastMove.cardsInPlay]];
                [lastActionText appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" for %d points", lastMove.scoreDelta]]];
                break;
            case MoveKindMismatch:
                lastActionText = [[NSMutableAttributedString alloc] initWithAttributedString:[self createAttributedfromCards:lastMove.cardsInPlay]];
                [lastActionText appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" don't match! %d point penalty!", lastMove.scoreDelta]]];
                break;
            default:
                break;
        }
        self.lastActionLabel.attributedText = lastActionText;
    }
}

- (NSMutableAttributedString *)createAttributedfromCards:(NSArray *)cards
{
    NSMutableAttributedString *stringOfCards = nil;
    NSAttributedString *separator = [[NSAttributedString alloc] initWithString:@" & "];
    Card* currentCard = nil;

    if ([cards count] > 0) {
        currentCard = cards[0];
        stringOfCards = [[NSMutableAttributedString alloc] initWithAttributedString:[self styleCard:currentCard]];
        for (int i = 1; i < [cards count]; i++) {
            currentCard = cards[i];
            [stringOfCards appendAttributedString:separator];
            [stringOfCards appendAttributedString:[self styleCard:currentCard]];
        }
    }

    return stringOfCards;
}

- (NSAttributedString *)styleCard:(Card *)card
{
    NSMutableAttributedString *styledContent;
    
    if ([card isKindOfClass:[SetPlayingCard class]]) {
        SetPlayingCard *setCard = (SetPlayingCard *)card;
        NSArray *symbols = @[@"▲", @"●", @"■"];
        NSArray *colors = @[[UIColor redColor], [UIColor greenColor], [UIColor purpleColor]];
        NSArray *shadings = @[@1.0, @0.3, @0.0];

        NSString *symbolsContent = [symbols[setCard.symbol] stringByPaddingToLength:setCard.number
                                                                         withString:symbols[setCard.symbol]
                                                                    startingAtIndex:0];

        styledContent = [[NSMutableAttributedString alloc] initWithString:symbolsContent];
        NSRange range = [[styledContent string] rangeOfString:symbolsContent];

        UIColor *colorWithShading = [colors[setCard.color] colorWithAlphaComponent:[(NSNumber *)shadings[setCard.shading] floatValue]];
        [styledContent addAttributes:@{NSForegroundColorAttributeName: colorWithShading,
                                           NSStrokeColorAttributeName: colors[setCard.color],
                                           NSStrokeWidthAttributeName: @-5}
                               range:range];
        
        // Hack around circle size issues on iOS 7
        //if ([setCard.symbol isEqualToString:@"●"]) {
        //    [styledContent addAttributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:30] } range: range];
        //}
    }
    
    return styledContent;
}

@end
