//
//  DTTransactionView.m
//  det-ios
//
//  Created by Justin Huang on 10/25/13.
//  Copyright (c) 2013 Justin Huang. All rights reserved.
//

#import "DTTransactionView.h"

@implementation DTTransactionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIButton *startTransaction = [UIButton buttonWithType:UIButtonTypeCustom];
        startTransaction.frame = CGRectMake(0, 0, 320, 50);
        [startTransaction setTitle:@"How much did you pay?" forState:UIControlStateNormal];
        [startTransaction.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [startTransaction addTarget:self action:@selector(reveal) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:startTransaction];
    }
    return self;
}


- (void)reveal {
    [self.delegate revealTransactionInput];
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
