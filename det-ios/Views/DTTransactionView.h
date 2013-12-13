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
- (void)cancelTransaction;
- (void)createTransaction:(NSDictionary*)params;

@end

@interface DTTransactionView : UIView <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, unsafe_unretained) id<DTTransactionDelegate> delegate;
@property (nonatomic, strong) UITextField *description;

// Reset Screens to Original State
- (void)resetScreens;

// Start a new Debt
- (void)startNewDebt;
@end
