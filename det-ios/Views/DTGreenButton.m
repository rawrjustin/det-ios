//
//  DTGreenButton.m
//  det-ios
//
//  Created by Justin Huang on 12/13/13.
//  Copyright (c) 2013 Justin Huang. All rights reserved.
//

#import "DTGreenButton.h"

@implementation DTGreenButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [DTColors colorForGreen];
    }
    return self;
}

- (void)layoutSubviews {
    self.backgroundColor = [DTColors colorForGreen];
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    
    if (highlighted) {
        self.backgroundColor = [UIColor colorWithRed:80.0/255.0f green:164/255.0f blue:153/255.0f alpha:1.0];
    } else {
        self.backgroundColor = [DTColors colorForGreen];
    }
}

@end
