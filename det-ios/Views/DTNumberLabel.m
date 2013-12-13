//
//  DTNumberLabel.m
//  det-ios
//
//  Created by Justin Huang on 11/20/13.
//  Copyright (c) 2013 Justin Huang. All rights reserved.
//

#import "DTNumberLabel.h"

@implementation DTNumberLabel

+ (id)labelAsNumber:(NSString *)number {
    DTNumberLabel *label = [[DTNumberLabel alloc] initWithFrame:CGRectMake(0, 0, kWIDTH_NUMBER, 100.0f)];
    if (self) {
        // Initialization code
        label.font = [DTFonts proximaNovaSemiboldSize:100.0];
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
