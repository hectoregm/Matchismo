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
    
    return score;
}

- (NSString *)contents
{
    return [NSString stringWithFormat:@"%d %@ %@ %@", self.number, self.color, self.shading, self.symbol];
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

@synthesize symbol = _symbol;

+ (NSArray *)validSymbols
{
    static NSArray *validSymbols = nil;
    if(!validSymbols) validSymbols = @[@"▲", @"●", @"■"];
    return validSymbols;
}

- (void)setSymbol:(NSString *)symbol
{
    if ([[SetPlayingCard validSymbols] containsObject:symbol]) {
        _symbol = symbol;
    }
}

- (NSString *)symbol
{
    return _symbol ? _symbol : @"?";
}

@synthesize shading = _shading;

+ (NSArray *)validShadings
{
    static NSArray *validShadings = nil;
    if(!validShadings) validShadings = @[@"solid", @"stripped", @"outline"];
    return validShadings;
}

- (void)setShading:(NSString *)shading
{
    if([[SetPlayingCard validShadings] containsObject:shading]) {
        _shading = shading;
    }
}

- (NSString *)shading
{
    return _shading ? _shading : @"?";
}

@synthesize color = _color;

+ (NSArray *)validColors
{
    static NSArray *validColors = nil;
    if(!validColors) validColors = @[@"red", @"green", @"purple"];
    return validColors;
}

- (void)setColor:(NSString *)color
{
    if ([[SetPlayingCard validColors] containsObject:color]) {
        _color = color;
    }
}

- (NSString *)color
{
    return _color ? _color : @"?";
}

@end
