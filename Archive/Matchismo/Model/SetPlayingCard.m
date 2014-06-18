//
//  SetPlayingCard.m
//  Matchismo
//
//  Created by Hector Enrique Gomez Morales on 6/23/13.
//  Copyright (c) 2013 Hector Enrique Gomez Morales. All rights reserved.
//

#import "SetPlayingCard.h"

@implementation SetPlayingCard

- (int)match:(NSArray *)otherCards
{
    int score = 0;
    
    if ([otherCards count] == 2) {
        NSUInteger numberSum = 0;
        NSUInteger symbolSum = 0;
        NSUInteger shadingSum = 0;
        NSUInteger colorSum = 0;
        
        NSMutableArray *allCards = [otherCards mutableCopy];
        [allCards addObject:self];
        for (SetPlayingCard *card in allCards) {
            numberSum += card.number;
            symbolSum += card.symbol;
            shadingSum += card.shading;
            colorSum += card.color;
        }
        
        if ((numberSum % 3 == 0) && (symbolSum % 3 == 0) &&
            (shadingSum % 3 == 0) && (colorSum % 3 == 0)) {
            score = 1;
        }
        
    }
    
    return score;
}

- (NSString *)contents
{
    return [NSString stringWithFormat:@"%luu-%@-%@-%@",(unsigned long) self.number, [self colorString], [self shadingString], [self symbolString]];
}

#define SET_MAX_NUMBER 3

+ (NSUInteger)maxNumber
{
    return SET_MAX_NUMBER;
}

- (void)setNumber:(NSUInteger)number
{
    if (number <= SET_MAX_NUMBER) {
        _number = number;
    }
}

+ (NSArray *)validSymbols
{
    static NSArray *validSymbols = nil;
    if(!validSymbols) validSymbols = @[@"diamond", @"squiggle", @"oval"];
    return validSymbols;
}

- (void)setSymbol:(NSUInteger)symbol
{
    if (symbol < [[SetPlayingCard validSymbols] count]) {
        _symbol = symbol;
    }
}

- (NSString *)symbolString
{
    return [SetPlayingCard validSymbols][self.symbol];
}

+ (NSArray *)validShadings
{
    static NSArray *validShadings = nil;
    if(!validShadings) validShadings = @[@"solid", @"stripped", @"outline"];
    return validShadings;
}

- (void)setShading:(NSUInteger)shading
{
    if(shading < [[SetPlayingCard validShadings] count]) {
        _shading = shading;
    }
}

- (NSString *)shadingString
{
    return [SetPlayingCard validShadings][self.shading];
}

+ (NSArray *)validColors
{
    static NSArray *validColors = nil;
    if(!validColors) validColors = @[@"red", @"green", @"purple"];
    return validColors;
}

- (void)setColor:(NSUInteger)color
{
    if (color < [[SetPlayingCard validColors] count]) {
        _color = color;
    }
}

- (NSString *)colorString
{
    return [SetPlayingCard validColors][self.color];
}

@end
