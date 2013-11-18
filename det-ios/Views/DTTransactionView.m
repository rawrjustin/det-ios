//
//  DTTransactionView.m
//  det-ios
//
//  Created by Justin Huang on 10/25/13.
//  Copyright (c) 2013 Justin Huang. All rights reserved.
//
#define kLayoutDescriptionOrigin [UIScreen mainScreen].bounds.size.height - kIOSKeyboardHeight - kButtonHeight
#define kLayoutDebtorOrigin [UIScreen mainScreen].bounds.size.height - kIOSKeyboardHeight - kButtonHeight * 2

#import "DTTransactionView.h"
#import "DTTransaction.h"
#import "DTUser.h"

@interface DTTransactionView()
@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic, strong) UIView *descriptionView;
@property (nonatomic, strong) UIView *debtorView;
@property (nonatomic, strong) NSMutableArray *selectedUsers;

// level 0 = nothing
// level 1 = how much
// level 2 = for what
// level 3 = for whom
@property (nonatomic) int revealLevel;

@end

@implementation DTTransactionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.revealLevel = 0;
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}

- (void)layoutSubviews {
    
    //  *************
    //  Amount
    //  *************
    
    //  StartButton
    UIButton *startTransaction = [UIButton buttonWithType:UIButtonTypeCustom];
    startTransaction.frame = CGRectMake(0, 0, 320, kButtonHeight);
    [startTransaction setTitle:@"How much did you pay?" forState:UIControlStateNormal];
    [startTransaction.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [startTransaction addTarget:self action:@selector(toggleTransaction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:startTransaction];
    
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cancelButton.frame = CGRectMake(270, 0, 50, 50);
    [self.cancelButton setTitle:@"x" forState:UIControlStateNormal];
    [self.cancelButton addTarget:self action:@selector(cancelTransaction) forControlEvents:UIControlEventTouchUpInside];
    self.cancelButton.alpha = 0.0;
    [self addSubview:self.cancelButton];
    
    self.amount = [[UITextField alloc] initWithFrame:CGRectMake(50, 100, 220, 70)];
    self.amount.textColor = [UIColor whiteColor];
    self.amount.keyboardType = UIKeyboardTypeNumberPad;
    self.amount.textAlignment = NSTextAlignmentCenter;
    self.amount.font = [UIFont systemFontOfSize:30.0];
    [self addSubview:self.amount];
    
    // Description
    
    self.descriptionView = [[UIView alloc] initWithFrame:CGRectMake(0, kLayoutDescriptionOrigin, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - kButtonHeight)];
    self.descriptionView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:1.0];
    [self addSubview:self.descriptionView];
    
    UIButton *startDescription = [UIButton buttonWithType:UIButtonTypeCustom];
    startDescription.frame = CGRectMake(0, 0, 320, kButtonHeight);
    [startDescription setTitle:@"What did you pay for?" forState:UIControlStateNormal];
    startTransaction.titleLabel.textColor = [UIColor whiteColor];
    [startDescription.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [startDescription addTarget:self action:@selector(toggleDescription) forControlEvents:UIControlEventTouchUpInside];
    [self.descriptionView addSubview:startDescription];
    
    self.description = [[UITextField alloc] initWithFrame:CGRectMake(50, 100 - kButtonHeight, 220, 70)];
    self.description.textColor = [UIColor whiteColor];
    self.description.keyboardType = UIKeyboardTypeAlphabet;
    self.description.textAlignment = NSTextAlignmentCenter;
    self.description.font = [UIFont systemFontOfSize:30.0];
    [self.descriptionView addSubview:self.description];
    
    self.debtorView = [[UIView alloc] initWithFrame:CGRectMake(0, kLayoutDebtorOrigin, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - kButtonHeight)];
    self.debtorView.backgroundColor = [UIColor colorWithWhite:0.4 alpha:1.0];
    [self.descriptionView addSubview:self.debtorView];
    
    UIButton *startDebtors = [UIButton buttonWithType:UIButtonTypeCustom];
    startDebtors.frame = CGRectMake(0, 0, 320, kButtonHeight);
    [startDebtors setTitle:@"Who did you pay for?" forState:UIControlStateNormal];
    startDebtors.titleLabel.textColor = [UIColor whiteColor];
    [startDebtors.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [startDebtors addTarget:self action:@selector(toggleDebtors) forControlEvents:UIControlEventTouchUpInside];
    [self.debtorView addSubview:startDebtors];

}

- (void)toggleTransaction {
    switch (self.revealLevel) {
        case 0:
            //this is from home page
            [self enableCancelButton:YES];
            [self.delegate revealTransactionInput];
            [self.amount becomeFirstResponder];
            self.revealLevel = 1;
            break;
        case 1:
            //this is case 1
            self.revealLevel = 1;
            break;
        case 2:
            [self showLevel:1];
            self.revealLevel = 1;
            break;
        case 3:
            [self showLevel:1];
            self.revealLevel = 1;
        default:
            break;
    }
}

- (void)toggleDescription {
    NSAssert(self.revealLevel > 0, @"You should not be able to toggle description from this screen");
    switch (self.revealLevel) {
        case 1: {
            //reveal description pane
            [self showLevel:2];
            self.revealLevel = 2;
            break;
        }
        case 2:
            //this is case 2
            self.revealLevel = 2;
            break;
        case 3:
            //hide debtors pane
            [self showLevel:2];
            self.revealLevel = 2;
        default:
            break;
    }
    
}

- (void)toggleDebtors {
    NSAssert(self.revealLevel > 1, @"You should not be able to toggle debtors from this screen");
    switch (self.revealLevel) {
        case 2:
            //reveal debtors
            [self showLevel:3];
            self.revealLevel = 3;
            break;
        case 3:
            //this is level 3
            self.revealLevel = 3;
        default:
            break;
    }
    
}

- (void)showLevel:(int)level {
    switch (level) {
        case 0:
            //hide all
            break;
        case 1: {
            [UIView animateWithDuration:0.3 animations:^{
                self.descriptionView.frame = CGRectMake(0, kLayoutDescriptionOrigin, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - kButtonHeight);
                self.debtorView.frame = CGRectMake(0, kLayoutDebtorOrigin, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - kButtonHeight);
                
            }];
            [self.amount becomeFirstResponder];
            break;
        }
        case 2: {
            [UIView animateWithDuration:0.3 animations:^{
                self.descriptionView.frame = CGRectMake(0, kButtonHeight, self.descriptionView.frame.size.width, self.descriptionView.frame.size.height);
                self.debtorView.frame = CGRectMake(0, kLayoutDebtorOrigin, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - kButtonHeight);
            }];
            [self.description becomeFirstResponder];
            break;
        }
        case 3:
            [self endEditing:YES];
            [UIView animateWithDuration:0.3 animations:^{
                self.debtorView.frame = CGRectMake(0, kButtonHeight, self.debtorView.frame.size.width, self.debtorView.frame.size.height);
            }];
            break;
    }
}

- (void)cancelTransaction {
    self.revealLevel = 0;
    [self enableCancelButton:NO];
    [self endEditing:YES];
    [self.delegate cancelTransaction];
}

- (void)enableCancelButton:(BOOL)enabled {
    self.cancelButton.enabled = enabled;
    [UIView animateWithDuration:0.3 animations:^{
        if (enabled) {
            self.cancelButton.alpha = 1.0;
        } else {
            self.cancelButton.alpha = 0.0;
        }
    }];
}

- (void)resetScreens {
    self.descriptionView.frame = CGRectMake(0, kLayoutDescriptionOrigin, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - kButtonHeight);
    self.debtorView.frame = CGRectMake(0, kLayoutDebtorOrigin, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - kButtonHeight);
}

- (void)submitTransaction {

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
