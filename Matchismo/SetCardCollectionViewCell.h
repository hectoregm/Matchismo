//
//  SetCardCollectionViewCell.h
//  Matchismo
//
//  Created by Hector Enrique Gomez Morales on 6/28/13.
//  Copyright (c) 2013 Hector Enrique Gomez Morales. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SetCardView.h"

@interface SetCardCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet SetCardView *setCardView;
@end
