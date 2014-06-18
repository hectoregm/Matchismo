//
//  BaseCardGameViewController.m
//  Matchismo
//
//  Created by Hector Enrique Gomez Morales on 6/23/13.
//  Copyright (c) 2013 Hector Enrique Gomez Morales. All rights reserved.
//

#import "BaseCardGameViewController.h"
#import "GameResult.h"

@interface BaseCardGameViewController () <UICollectionViewDataSource>
@property (strong, nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) GameResult *gameResult;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastActionLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *cardCollectionView;
@end

@implementation BaseCardGameViewController

- (CardMatchingGame *)game
{
    if (!_game) {
        _game = [[CardMatchingGame alloc] initWithCardCount:self.startingCardCount
                                                  usingDeck:[self createDeck]];
        [self setGameSettings:_game];
    }
    return _game;
}

- (Deck *)createDeck // Abstract
{
    // Abstract - Implement in your subclass
    return nil;
}

- (void)setGameSettings:(CardMatchingGame *)game // Abstract
{
    // Abstract - Implement in your subclass
}

- (NSString *)gameType
{
    // Abstract - Implement in your subclass
    return nil;
}

- (GameResult *)gameResult
{
    if (!_gameResult) _gameResult = [[GameResult alloc] init];
    _gameResult.gameType = [self gameType];
    return _gameResult;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.lastActionLabel.text = @"";
}

- (void)updateUI:(BOOL)animate
{
    for (UICollectionViewCell *cell in [self.cardCollectionView visibleCells]) {
        NSIndexPath *indexPath = [self.cardCollectionView indexPathForCell:cell];
        Card *card = [self.game cardAtIndex:indexPath.item];
        [self updateCell:cell usingCard:card animate:animate];
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
}

- (void)updateGrid
{
    // Abstract - Implement in your subclass
}

- (void)updateLastAction:(CardGameMove *)move
{
    // Abstract - Implement in your subclass
}

- (IBAction)flipCard:(UITapGestureRecognizer *)sender {
    CGPoint tapLocation = [sender locationInView:self.cardCollectionView];
    NSIndexPath *indexPath = [self.cardCollectionView indexPathForItemAtPoint:tapLocation];
    if (indexPath) {
        CardGameMove *move = [self.game flipCardAtIndex:indexPath.item];
        
        [self updateLastAction:move];
        
        // If move is a match and we want to remove matches we go ahead and do it
        if ((move.moveKind == MoveKindMatch) && self.removeCardMatches) {
            NSMutableArray *paths = [[NSMutableArray alloc] init];
            for (Card *card in move.cardsInPlay) {
                [paths addObject:[self indexPathOfCard:card]];
            }
            [self.game removeCardsFromGame:move.cardsInPlay];
            [self.cardCollectionView deleteItemsAtIndexPaths:paths];
        }
        [self updateUI:YES];
        self.gameResult.score = self.game.score;
    }
}

- (IBAction)dealNewGame {
    NSLog(@"Dealing New Game...");
    self.game = nil;
    self.gameResult = nil;
    self.lastActionLabel.text = @"";
    [self.cardCollectionView reloadData];
    [self resetUI];
    [self updateUI:NO];
}

- (void)resetUI
{
    // Abstract - Implement in your subclass
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.game numberOfCardsInPlay];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.reuseIdentifier
                                                                           forIndexPath:indexPath];
    Card *card = [self.game cardAtIndex:indexPath.item];
    [self updateCell:cell usingCard:card animate: NO];
    return cell;
}

- (void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card animate:(BOOL)animate;
{
    // Abstract - Implement in your subclass
}

- (NSIndexPath *)indexPathOfCard:(Card *)card
{
    return [NSIndexPath indexPathForItem:[self.game indexOfCard:card] inSection:0];;
}

@end
