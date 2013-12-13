//
//  DTSummaryBlock.m
//  det-ios
//
//  Created by Justin Huang on 11/14/13.
//  Copyright (c) 2013 Justin Huang. All rights reserved.
//

#import "DTSummaryBlock.h"

@interface DTSummaryBlock ()
@property (nonatomic, strong) UIView *detailBackground;
@property (nonatomic, strong) UILabel *amountLabel;
@property (nonatomic, strong) UILabel *oweLabel;
@end

@implementation DTSummaryBlock

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //self.backgroundColor = [UIColor clearColor];
        
        // Profile
        self.profileImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        self.profileImage.contentMode = UIViewContentModeScaleAspectFill;
        self.profileImage.clipsToBounds = YES;
        [self.contentView addSubview:self.profileImage];
        
        self.detailBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 90.0f, kDTCellSize, 50.0f)];
        self.detailBackground.backgroundColor = [UIColor blackColor];
        self.detailBackground.alpha = 0.7;
        self.detailBackground.layer.allowsGroupOpacity = YES;
        [self.contentView addSubview:self.detailBackground];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 90.0f, kDTCellSize, 25.0f)];
        self.nameLabel.font = [UIFont systemFontOfSize:18.0];
        self.nameLabel.textColor = [UIColor whiteColor];
        self.nameLabel.textAlignment = NSTextAlignmentCenter;
        self.nameLabel.minimumScaleFactor = 0.7;
        [self.contentView addSubview:self.nameLabel];
        
        self.amountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 115.0f, kDTCellSize, 25.0f)];
        self.amountLabel.font = [DTFonts proximaNovaSemiboldSize:18.0];
        [self.contentView addSubview:self.amountLabel];
        
        self.oweLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 115.0f, 36.0f, 25.0f)];
        self.oweLabel.font = [UIFont systemFontOfSize:12.0];
        self.oweLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:self.oweLabel];
        
//        
//        self.layer.cornerRadius = 4.0;
//        self.contentView.layer.cornerRadius = 4.0;
        self.contentView.clipsToBounds = YES;
        
        
    }
    return self;
}

#pragma mark - 
#pragma mark - Private Methods

- (void)setAmount:(double)amount {
    _amount = amount;
    self.amountLabel.text = [NSString stringWithFormat:@"$%.2f", fabs(amount)];
    self.amountLabel.textColor = (amount >= 0.0) ? [DTColors colorForGreen] : [DTColors colorForRed];
    [self.amountLabel sizeToFit];
    
    self.oweLabel.text = (amount >= 0.0) ? @"owes" : @"owed";
    
    
    // Position Elements so that both of them together are centered.
    CGFloat totalWidth = self.oweLabel.frame.size.width + self.amountLabel.frame.size.width;
    CGFloat xMargin = (kDTCellSize - totalWidth)/2;
    self.oweLabel.frame = CGRectMake(xMargin, 115.0f, self.oweLabel.frame.size.width, self.oweLabel.frame.size.height);
    self.amountLabel.frame = CGRectMake(xMargin + self.oweLabel.frame.size.width, 115.0f, self.amountLabel.frame.size.width, self.amountLabel.frame.size.height);
    
}

#pragma mark - 
#pragma mark - Reuse

- (void)prepareForReuse {
    [super prepareForReuse];
    
    self.profileImage.image = nil;
}


@end
