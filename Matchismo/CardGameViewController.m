//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Hector Enrique Gomez Morales on 6/15/13.
//  Copyright (c) 2013 Hector Enrique Gomez Morales. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"

@interface CardGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int flipCount;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (strong, nonatomic) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastActionLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *cardModeSelector;
@property (weak, nonatomic) IBOutlet UISlider *historySlider;
@end

@implementation CardGameViewController

- (CardMatchingGame *)game
{
    if (!_game) {
        _game = [[CardMatchingGame alloc] initWithCardCount:self.cardButtons.count
                                                  usingDeck:[[PlayingCardDeck alloc] init]];
        [self cardModeChanged:self.cardModeSelector];   
    }
    return _game;
}

- (void)setCardButtons:(NSArray *)cardButtons
{
    _cardButtons = cardButtons;
    NSLog(@"Setting buttons labels");
    [self updateUI];
}

- (void)updateUI
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
    
    self.scoreLabel.text = [NSString stringWithFormat:@"Score %d", self.game.score];
    [self updateSlider];
}

- (void)updateSlider
{
    int maxValue = [self.game.history count] - 1;
    if (maxValue < 0) maxValue = 0;
    self.lastActionLabel.alpha = 1.0;
    self.lastActionLabel.text = [self.game.history lastObject];
    self.historySlider.maximumValue = maxValue;
    NSLog(@"Items in history: %d", maxValue);
    [self.historySlider setValue:maxValue animated:YES];
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
    self.cardModeSelector.enabled = NO;
}

- (IBAction)dealNewGame {
    NSLog(@"Dealing New Game...");
    self.game = nil;
    self.flipCount = 0;
    self.cardModeSelector.enabled = YES;
    [self updateUI];
}

- (IBAction)cardModeChanged:(UISegmentedControl *)sender {
    NSLog(@"Change Game Mode to: %d", sender.selectedSegmentIndex);
    switch ([sender selectedSegmentIndex]) {
        case 0:
            self.game.numberOfMatchingCards = 2;
            break;
        case 1:
            self.game.numberOfMatchingCards = 3;
            break;
        default:
            self.game.numberOfMatchingCards = 2;
            break;
    }
}

- (IBAction)historySliderChanged:(UISlider *)sender {
    int sliderValue;
    sliderValue = lroundf(self.historySlider.value);
    [self.historySlider setValue:sliderValue animated:NO];
    
    if ([self.game.history count]) {
        self.lastActionLabel.alpha = (sliderValue + 1 < [self.game.history count]) ? 0.6 : 1.0;
        self.lastActionLabel.text = [self.game.history objectAtIndex:sliderValue];
    }
}

@end
