//
//  SetCardView.h
//  Matchismo
//
//  Created by Hector Enrique Gomez Morales on 6/28/13.
//  Copyright (c) 2013 Hector Enrique Gomez Morales. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetCardView : UIView
@property (nonatomic) NSUInteger number;
@property (nonatomic) NSUInteger symbol;
@property (nonatomic) NSUInteger shading;
@property (nonatomic) NSUInteger color;
@property (nonatomic) BOOL faceUp;
@end
