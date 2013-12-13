//
//  DTHomeSummaryView.m
//  det-ios
//
//  Created by Justin Huang on 11/18/13.
//  Copyright (c) 2013 Justin Huang. All rights reserved.
//

#import "DTHomeSummaryView.h"

@interface DTHomeSummaryView()

@property (nonatomic, strong) UILabel *totalAmount;
@property (nonatomic, strong) UILabel *owedToYouLabel;
@property (nonatomic, strong) UILabel *youOweLabel;

@property (nonatomic, strong) UIView *positiveBackground;
@property (nonatomic, strong) UIView *negativeBackground;

@property (nonatomic, strong) UIView *positiveForeground;
@property (nonatomic, strong) UIView *negativeForeground;

@property (nonatomic) double amount;

@end

@implementation DTHomeSummaryView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UILabel *totalBalance = [[UILabel alloc] initWithFrame:CGRectMake(12.0f, 5.0f, 100.0f, 20.0f)];
        totalBalance.text = @"total balance";
        totalBalance.font = [UIFont systemFontOfSize:12.0];
        totalBalance.textColor = [UIColor darkGrayColor];
        totalBalance.textAlignment = NSTextAlignmentCenter;
        [self addSubview:totalBalance];
        
        self.totalAmount = [[UILabel alloc] initWithFrame:CGRectMake(12.0f, 20.0f, 100.0f, 30.0f)];
        self.totalAmount.font = [DTFonts proximaNovaSemiboldSize:22.0f];
        self.totalAmount.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.totalAmount];
        
        self.positiveBackground = [[UIView alloc] initWithFrame:CGRectMake(110.0f, 4.0, 125.0f, 18.0f)];
        self.positiveBackground.backgroundColor = [DTColors colorForGreen];
        self.positiveBackground.alpha = 0.3;
        [self addSubview:self.positiveBackground];
        
        self.negativeBackground = [[UIView alloc] initWithFrame:CGRectMake(110.0f, 28.0f, 125.0f, 18.0f)];
        self.negativeBackground.backgroundColor = [DTColors colorForRed];
        self.negativeBackground.alpha = 0.3;
        [self addSubview:self.negativeBackground];
        
        self.positiveForeground = [[UIView alloc] initWithFrame:CGRectMake(110.0f, 4.0, 125.0f, 18.0f)];
        self.positiveForeground.backgroundColor = [DTColors colorForGreen];
        [self addSubview:self.positiveForeground];
        
        self.negativeForeground = [[UIView alloc] initWithFrame:CGRectMake(110.0f, 28.0f, 125.0f, 18.0f)];
        self.negativeForeground.backgroundColor = [DTColors colorForRed];
        [self addSubview:self.negativeForeground];
        
        UILabel *positiveText = [[UILabel alloc] initWithFrame:CGRectMake(115.0f, 4.0, 125.0f, 18.0f)];
        positiveText.textColor = [UIColor whiteColor];
        positiveText.text = @"owed to you";
        positiveText.font = [UIFont italicSystemFontOfSize:12.0];
        [self addSubview:positiveText];
        
        UILabel *negativeText = [[UILabel alloc] initWithFrame:CGRectMake(115.0f, 28.0, 125.0f, 18.0f)];
        negativeText.textColor = [UIColor whiteColor];
        negativeText.text = @"you owe";
        negativeText.font = [UIFont italicSystemFontOfSize:12.0];
        [self addSubview:negativeText];
        
        self.owedToYouLabel = [[UILabel alloc] initWithFrame:CGRectMake(230.0f, 0.0f, 75.0f, 25.0f)];
        self.owedToYouLabel.font = [DTFonts proximaNovaSemiboldSize:16.0f];
        self.owedToYouLabel.textAlignment = NSTextAlignmentRight;
        self.owedToYouLabel.minimumScaleFactor = 0.8;
        self.owedToYouLabel.textColor = [DTColors colorForGreen];
        [self addSubview:self.owedToYouLabel];
        
        self.youOweLabel = [[UILabel alloc] initWithFrame:CGRectMake(230.0f, 25.0f, 75.0f, 25.0f)];
        self.youOweLabel.font = [DTFonts proximaNovaSemiboldSize:16.0f];
        self.youOweLabel.textAlignment = NSTextAlignmentRight;
        self.youOweLabel.minimumScaleFactor = 0.8;
        self.youOweLabel.textColor = [DTColors colorForRed];
        [self addSubview:self.youOweLabel];
    }
    
    return self;
}

- (void)setOwedToYou:(double)owed andYouOwe:(double)owe {
    self.youOweLabel.text = [NSString stringWithFormat:@"$%.2f", owe];
    self.owedToYouLabel.text = [NSString stringWithFormat:@"$%.2f", owed];
    self.amount = owed-owe;

    if (owed > owe) {
        float ratioRed = owe/(owe+owed);
        float ratioGreen = owed/(owe+owed);
        
        self.negativeForeground.frame = CGRectMake(self.negativeForeground.frame.origin.x, self.negativeForeground.frame.origin.y, self.negativeForeground.frame.size.width * ratioRed, self.negativeForeground.frame.size.height);
        self.positiveForeground.frame = CGRectMake(self.positiveForeground.frame.origin.x, self.positiveForeground.frame.origin.y, self.positiveForeground.frame.size.width * ratioGreen, self.positiveForeground.frame.size.height);
    }
}

- (void)setAmount:(double)amount {
    _amount = amount;
    self.totalAmount.text = [NSString stringWithFormat:@"$%.2f", fabs(amount)];
    self.totalAmount.textColor = (amount >= 0.0) ? [DTColors colorForGreen] : [DTColors colorForRed];
}

@end
