//
//  DTDecimalLabel.m
//  det-ios
//
//  Created by Justin Huang on 11/20/13.
//  Copyright (c) 2013 Justin Huang. All rights reserved.
//

#import "DTDecimalLabel.h"

@implementation DTDecimalLabel

+ (id)labelAsNumber:(NSString *)number {
    DTDecimalLabel *label = [[DTDecimalLabel alloc] initWithFrame:CGRectMake(0, 0, kWIDTH_DECIMAL, 40.0f)];
    if (self) {
        // Initialization code
        label.font = [DTFonts proximaNovaSemiboldSize:40.0];
        label.textColor = [DTColors colorForGreen];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor clearColor];
        label.text = number;
        label.alpha = 0.0;
    }
    return label;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
