//
//  DTTransactionView.h
//  det-ios
//
//  Created by Justin Huang on 10/25/13.
//  Copyright (c) 2013 Justin Huang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DTTransactionDelegate
- (void)revealTransactionInput;
@end

@interface DTTransactionView : UIView

@property (nonatomic, unsafe_unretained) id<DTTransactionDelegate> delegate;
@property (nonatomic, strong) UILabel *amount;
@property (nonatomic, strong) UITextField *description;

@end
