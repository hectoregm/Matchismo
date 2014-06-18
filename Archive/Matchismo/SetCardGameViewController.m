//
//  SetCardGameViewController.m
//  Matchismo
//
//  Created by Hector Enrique Gomez Morales on 6/23/13.
//  Copyright (c) 2013 Hector Enrique Gomez Morales. All rights reserved.
//

#import "SetCardGameViewController.h"
#import "SetPlayingCardDeck.h"
#import "SetCardCollectionViewCell.h"
#import "SetPlayingCard.h"

@interface SetCardGameViewController ()
@property (strong, nonatomic) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UILabel *lastActionLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *cardCollectionView;
@property (weak, nonatomic) IBOutlet UIButton *drawButton;
@property (weak, nonatomic) IBOutlet UIView *selectionView;
@end

@implementation SetCardGameViewController

@dynamic game;
@dynamic lastActionLabel;
@dynamic cardCollectionView;

#define STARTING_CARD_COUNT 12

- (Deck *)createDeck
{
    return [[SetPlayingCardDeck alloc] init];
}

- (NSUInteger)startingCardCount
{
    return STARTING_CARD_COUNT;
}

- (NSString *)gameType
{
    return @"Set Game";
}

- (NSString *)reuseIdentifier
{
    return @"SetCard";
}

- (BOOL)removeCardMatches
{
    return YES;
}

- (void)setGameSettings:(CardMatchingGame *)game
{
    game.numberOfMatchingCards = 3;
    game.flipCost = 0;
    game.matchBonus = 30;
    game.mismatchPenalty = 5;
}

- (void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card animate:(BOOL)animate
{
    if ([cell isKindOfClass:[SetCardCollectionViewCell class]]) {
        SetCardView *setCardView = ((SetCardCollectionViewCell *)cell).setCardView;
        if ([card isKindOfClass:[SetPlayingCard class]]) {
            SetPlayingCard *setCard = (SetPlayingCard *)card;
            setCardView.number = setCard.number;
            setCardView.symbol = setCard.symbol;
            setCardView.shading = setCard.shading;
            setCardView.color = setCard.color;
            setCardView.faceUp = setCard.isFaceUp;
            setCardView.alpha = setCard.isUnplayable ? 0.3 : 1.0;
        }
    }
}

- (void)resetUI
{
    self.drawButton.enabled = YES;
    self.drawButton.alpha = 1.0;
    [[self.selectionView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

#define NUMBER_OF_CARDS_DRAW 3

- (IBAction)drawCards:(UIButton *)sender
{
    if ([self.game.deck numberOfCards] != 0) {
        NSArray *newCards = [self.game addCardsToGame: NUMBER_OF_CARDS_DRAW];
        NSMutableArray *paths = [[NSMutableArray alloc] init];
        for (Card *card in newCards) {
            [paths addObject:[self indexPathOfCard:card]];
        }
        [self.cardCollectionView insertItemsAtIndexPaths:paths];
        [self.cardCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:(self.game.numberOfCardsInPlay - 1) inSection:0]  atScrollPosition:UICollectionViewScrollPositionBottom animated:YES];
    } else {
        sender.enabled = NO;
        sender.alpha = 0.3;
        UIAlertView *noMoreCardsAlert = [[UIAlertView alloc] initWithTitle:@"Deck is empty" message:@"You can't draw more cards, deck is empty!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [noMoreCardsAlert show];
    }
}

#define CARDVIEW_SELECTION_HEIGHT 40
#define CARDVIEW_SELECTION_WIDTH 40
#define CARDVIEW_SELECTION_OFFSET 40

- (void)updateLastAction:(CardGameMove *)move
{
    Card *card;
    NSMutableArray *selection;
    
    [[self.selectionView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];

    if (move.moveKind == MoveKindFlipUp) {
        selection = [[NSMutableArray alloc] init];
        for (int i = 0; i < [self.game numberOfCardsInPlay]; i++) {
            card = [self.game cardAtIndex:i];
            if (card.isFaceUp && !card.isUnplayable) {
                [selection addObject:card];
            }
        }
        self.lastActionLabel.text = @"Current Selection:";
    } else {
        selection = [move.cardsInPlay mutableCopy];
        self.lastActionLabel.text =  (move.moveKind == MoveKindMatch) ? @"Match!!!" : @"Mismatch :(";
    }
    
    SetCardView *setCardView;
    SetPlayingCard *setCard;
    int index = 0;
    for (Card *card in selection) {
        setCardView = [[SetCardView alloc] initWithFrame:CGRectMake(index * CARDVIEW_SELECTION_OFFSET, 0, CARDVIEW_SELECTION_WIDTH, CARDVIEW_SELECTION_HEIGHT)];
        setCardView.opaque = NO;
        setCard = (SetPlayingCard *)card;
        setCardView.number = setCard.number;
        setCardView.symbol = setCard.symbol;
        setCardView.shading = setCard.shading;
        setCardView.color = setCard.color;
        setCardView.faceUp = setCard.isFaceUp;
        [self.selectionView addSubview:setCardView];
        index += 1;
    }
}

@end
