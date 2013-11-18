//
//  DTSummaryBlock.h
//  det-ios
//
//  Created by Justin Huang on 11/14/13.
//  Copyright (c) 2013 Justin Huang. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kDTCellSize 140.0f

@interface DTSummaryBlock : UICollectionViewCell

@property (nonatomic, strong) UIImageView *profileImage;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic) double amount;
@end
