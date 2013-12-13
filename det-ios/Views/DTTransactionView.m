//
//  DTTransactionView.m
//  det-ios
//
//  Created by Justin Huang on 10/25/13.
//  Copyright (c) 2013 Justin Huang. All rights reserved.
//
#define kLayoutDescriptionOrigin [UIScreen mainScreen].bounds.size.height - kIOSKeyboardHeight - kButtonHeight
#define kLayoutDebtorOrigin [UIScreen mainScreen].bounds.size.height - kIOSKeyboardHeight - kButtonHeight * 2
#define kTextFieldTagAmount 14
#define kTextFieldTagDecimal 15

#import <AFNetworking/UIImageView+AFNetworking.h>
#import "DTDecimalLabel.h"
#import "DTNumberLabel.h"
#import "DTTransactionView.h"
#import "DTTransaction.h"
#import "DTUser.h"
#import "DTFacebookFriendCell.h"
#import "DTGreenButton.h"

@interface DTTransactionView()

// AMOUNT
@property (nonatomic, strong) UILabel *howMuchLabel;
@property (nonatomic, strong) UIButton *paidButton;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIImageView *dollarSymbol;
@property (nonatomic, strong) UITextField *amount;
@property (nonatomic, strong) UIButton *nextButton;
@property (nonatomic) BOOL didPay;

@property (nonatomic) BOOL enteringDecimals;
@property (nonatomic, strong) NSMutableArray *numberArray;
@property (nonatomic, strong) NSMutableArray *decimalArray;
@property (nonatomic, strong) UIView *numberContainer;
@property (nonatomic, strong) UILabel *zeroLabel;
@property (nonatomic) double amountValue;

// WHO
@property (nonatomic, strong) UITextField *descriptionField;
@property (nonatomic, strong) UITableView *friendTable;
@property (nonatomic, strong) NSArray *facebookFriends;
@property (nonatomic, strong) NSMutableDictionary *alphabeticalFriends;
@property (nonatomic, strong) NSMutableArray *selectedUsers;

@property (nonatomic, strong) UIButton *submitButton;

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
        self.backgroundColor = [UIColor whiteColor];
        self.alphabeticalFriends = [NSMutableDictionary dictionary];
        
        [self setupAmountView];
        [self setupFacebookData];
        [self setupFriendView];
    }
    return self;
}

- (void)setupFacebookData {
    FBRequest *friendRequest = [FBRequest requestForMyFriends];

    [friendRequest startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // result is a dictionary with the user's Facebook data
            NSDictionary *userData = (NSDictionary *)result;
            self.facebookFriends = [userData objectForKey:@"data"];
            for (NSDictionary *friend in self.facebookFriends) {
                NSString *letter = [[[friend objectForKey:@"name"] substringToIndex:1] lowercaseString];
                NSMutableArray *letterArray = [self.alphabeticalFriends objectForKey:letter];
                if (letterArray) {
                    [letterArray addObject:friend];
                } else {
                    [self.alphabeticalFriends setObject:[NSMutableArray arrayWithObject:friend] forKey:letter];
                }
            }
            for (NSString *key in [self.alphabeticalFriends allKeys]) {
                NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"first_name" ascending:YES];
                NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
                self.alphabeticalFriends[key] = [self.alphabeticalFriends[key] sortedArrayUsingDescriptors:sortDescriptors];
            }
            [self.friendTable reloadData];

        } else {
            NSLog(@"error with fetching list of friends");
        }
    }];
}

#pragma mark - 
#pragma mark - View Setup

- (void)setupAmountView {
    //  *************
    //  Amount
    //  *************
    self.enteringDecimals = NO;
    self.numberArray = [NSMutableArray arrayWithCapacity:3];
    self.decimalArray = [NSMutableArray arrayWithCapacity:2];
    
    self.howMuchLabel = [[UILabel alloc] initWithFrame:CGRectMake(88.0f, 25.0f, 70.0f, 30.0f)];
    self.howMuchLabel.text = @"YOU";
    self.howMuchLabel.font = [DTFonts proximaNovaRegularSize:26.0];
    self.howMuchLabel.textColor = [DTColors colorForGreen];
    [self.howMuchLabel setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:self.howMuchLabel];

    self.paidButton = [[UIButton alloc] initWithFrame:CGRectMake(160.0f, 20.0, 70.0f, 40.0f)];
    self.paidButton.backgroundColor = [DTColors colorWithWhite:0.8 alpha:1.0];
    [self.paidButton addTarget:self action:@selector(payDirectionButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.paidButton.titleLabel.textColor = [DTColors whiteColor];
    self.paidButton.titleLabel.font = [DTFonts proximaNovaRegularSize:26.0f];
    [self.paidButton setTitle:@"PAID" forState:UIControlStateNormal];
    self.paidButton.enabled = YES;
    [self addSubview:self.paidButton];
    
    self.didPay = YES;
    
    self.amount = [[UITextField alloc] initWithFrame:CGRectMake(40, 180, 240, 40)];
    self.amount.keyboardType = UIKeyboardTypeDecimalPad;
    self.amount.textAlignment = NSTextAlignmentCenter;
    self.amount.font = [DTFonts proximaNovaRegularSize:26.0f];
    self.amount.textColor = [DTColors colorForGreen];
    self.amount.alpha = 0.0;
    self.amount.tag = kTextFieldTagAmount;
    self.amount.delegate = self;
    [self addSubview:self.amount];
    
    self.numberContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.numberContainer.backgroundColor = [UIColor clearColor];
    [self addSubview:self.numberContainer];
    
    self.dollarSymbol = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40.0f, 40.0f)];
    self.dollarSymbol.image = [UIImage imageNamed:@"dollar_symbol"];
    self.dollarSymbol.center = CGPointMake(self.center.x - 50, 150.0f);
    self.dollarSymbol.alpha = 0.0;
    [self addSubview:self.dollarSymbol];
    
    
    self.zeroLabel = [DTNumberLabel labelAsNumber:@"0"];
    self.zeroLabel.center = CGPointMake(self.center.x, 150.0f);
    self.zeroLabel.alpha = 1.0;
    [self addSubview:self.zeroLabel];
    
    
    self.nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.nextButton setFrame:CGRectMake(60.0f, self.frame.size.height - 216.0f - 50.0f - 10.0f, 200.0f, 50.0f)];
    [self.nextButton setImage:[UIImage imageNamed:@"next_button"] forState:UIControlStateNormal];
    [self.nextButton setEnabled:NO];
    [self.nextButton addTarget:self action:@selector(nextPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.nextButton setAlpha:0.0];
    [self addSubview:self.nextButton];
}

- (void)setupFriendView {

    self.friendTable = [[UITableView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, 320.0f, 360.0f) style:UITableViewStylePlain];
    [self.friendTable registerClass:[DTFacebookFriendCell class] forCellReuseIdentifier:@"cell"];
    self.friendTable.delegate = self;
    self.friendTable.dataSource = self;
    [self addSubview:self.friendTable];
    
    self.submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.submitButton setFrame:CGRectMake(0, self.frame.size.height - 55.0f, 320.0f, 55.0f)];
    self.submitButton.backgroundColor = [DTColors colorForGreen];
    [self.submitButton setTitle:@"Finished!" forState:UIControlStateNormal];
    self.submitButton.titleLabel.font = [DTFonts proximaNovaSemiboldSize:24.0];
    self.submitButton.alpha = 0.0;
    [self addSubview:self.submitButton];
}


- (void)adjustNextButtonState {
    BOOL shouldEnable = [self.numberArray count] > 0;
    self.nextButton.enabled = shouldEnable;
    if (shouldEnable) {
        [UIView animateWithDuration:0.3 animations:^{
            self.nextButton.alpha = 1.0;
        }];
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            self.nextButton.alpha = 0.0;
        }];
    }
}
#pragma mark -
#pragma mark - Selectors

- (void)payDirectionButtonPressed:(id)sender {
    _didPay = !_didPay;
    if (_didPay) {
        for (UILabel *number in self.numberArray) {
            [number setTextColor:[DTColors colorForGreen]];
        }
        for (UILabel *number in self.decimalArray) {
            [number setTextColor:[DTColors colorForGreen]];
        }
        [self.zeroLabel setTextColor:[DTColors colorForGreen]];
        [self.paidButton setTitle:@"PAID" forState:UIControlStateNormal];
        self.amount.textColor = [DTColors colorForGreen];

    } else {
        for (UILabel *number in self.numberArray) {
            [number setTextColor:[DTColors colorForRed]];
        }
        for (UILabel *number in self.decimalArray) {
            [number setTextColor:[DTColors colorForRed]];
        }
        
        [self.zeroLabel setTextColor:[DTColors colorForRed]];
        [self.paidButton setTitle:@"OWE" forState:UIControlStateNormal];
        self.amount.textColor = [DTColors colorForRed];

    }
    
}


- (void)nextPressed {
    [self endEditing:YES];
    [self showFriendSelectionStage];
}


#pragma mark -
#pragma mark - State Animations


- (void)showFriendSelectionStage {
    self.paidButton.enabled = NO;
    [self.paidButton setBackgroundColor:[UIColor whiteColor]];
    self.paidButton.titleLabel.textColor = [DTColors colorForGreen];
    [UIView animateWithDuration:0.5 animations:^{
        // Move
        self.friendTable.frame = CGRectMake(0, self.frame.size.height - 316.0f - 55.0f - 44.0f, self.friendTable.frame.size.width, self.friendTable.frame.size.height);

        self.howMuchLabel.center = CGPointMake(self.howMuchLabel.center.x - 36.0f, self.howMuchLabel.center.y);
        self.paidButton.center = CGPointMake(self.paidButton.center.x - 36.0f, self.paidButton.center.y);
        self.amount.center = CGPointMake(self.paidButton.frame.origin.x + self.paidButton.frame.size.width + 30.0f, self.paidButton.center.y);
        
        // Fade In
        self.amount.alpha = 1.0;
        self.submitButton.alpha = 1.0;

        // Fade Out
        self.numberContainer.alpha = 0.0;
    }];
}

- (void)backToAmountStage {
    
}

- (void)cancelTransaction {
    self.revealLevel = 0;
    [self enableCancelButton:NO];
    [self endEditing:YES];
    [self.delegate cancelTransaction];
    self.numberContainer.alpha = 1.0;
}

- (void)clearNumbers {
    for (UILabel *label in self.numberArray) {
        [label removeFromSuperview];
    }
    for (UILabel *label in self.decimalArray) {
        [label removeFromSuperview];
    }
    [self.numberArray removeAllObjects];
    [self.decimalArray removeAllObjects];
    self.zeroLabel.alpha = 1.0;
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

#pragma mark - 
#pragma mark - Public functions

- (void)startNewDebt {
    [self.amount becomeFirstResponder];
}

- (void)resetScreens {
    // Amount
    self.amount.text = @"";
    [self clearNumbers];
    self.dollarSymbol.center = CGPointMake(self.center.x - 50, 150.0f);
    _enteringDecimals = NO;
    self.paidButton.enabled = YES;
    self.numberContainer.alpha = 1.0;
    self.amount.alpha = 0.0;
    self.amount.center = self.zeroLabel.center;
    
}

- (void)submitTransaction {
//    [PFCloud callFunctionInBackground:@"createTransaction"
//                       withParameters:@{@"571815533": @{
//                                                @"name":    @"Allen Wu",
//                                                @"email":   @"wua05@ucla.edu",
//                                                @"amount":  @50
//                                                },
//                                        @"fbIdentifiers":   @[@"571815533"],
//                                        @"creditor":    @"x5SLz4374r",
//                                        @"description": @"Allen owes me for strippers"
//                                        }
//                                block:^(NSNumber *ratings, NSError *error) {
//                                    if (!error) {
//                                        [self pullData];
//                                    }
//                                }];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableArray *fbIDArray = [NSMutableArray array];
    if (_didPay) {
        [params setObject:@"user" forKey:[DTUser getCurrentUser].facebookID];
    }
    for (NSDictionary *facebookFriend in self.selectedUsers) {
        NSString *fbID = [facebookFriend objectForKey:@"id"];
        [fbIDArray addObject:fbID];
        NSDictionary *infoDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                                        [facebookFriend objectForKey:@"name"], @"name",
                                        @(self.amountValue), @"amount", nil];
        [params setObject:infoDictionary forKey:fbID];
    }
    [params setObject:fbIDArray forKey:@"fbIdentifiers"];
    [params setObject:self.descriptionField.text forKey:@"description"];
    [self.delegate createTransaction:params];
}

#pragma mark -
#pragma mark - Number Animation Functions

- (void)shiftNumberLeft:(UILabel*)number {
    [UIView animateWithDuration:0.2 animations:^{
        number.center = CGPointMake(number.center.x - number.frame.size.width/2, number.center.y);
    }];
}

- (void)shiftNumberRight:(UILabel*)number {
    [UIView animateWithDuration:0.2 animations:^{
        number.center = CGPointMake(number.center.x + number.frame.size.width/2, number.center.y);
    }];
}

- (void)shiftDollarLeft {
    [UIView animateWithDuration:0.2 animations:^{
        self.dollarSymbol.center = CGPointMake(self.dollarSymbol.center.x - kWIDTH_NUMBER/2, self.dollarSymbol.center.y);
    }];
}

- (void)shiftDollarRight {
    [UIView animateWithDuration:0.2 animations:^{
        self.dollarSymbol.center = CGPointMake(self.dollarSymbol.center.x + kWIDTH_NUMBER/2, self.dollarSymbol.center.y);
    }];
}

- (void)fadeNumberIn:(UILabel*)number {
    number.textColor = _didPay ? [DTColors colorForGreen] : [DTColors colorForRed];
    [self.numberContainer addSubview:number];
    [UIView animateWithDuration:0.2 animations:^{
        number.center = CGPointMake(number.center.x, number.center.y + 50.0f);
        number.alpha = 1.0;
    }];
}

- (void)fadeNumberOut:(UILabel*)number {
    number.textColor = _didPay ? [DTColors colorForGreen] : [DTColors colorForRed];
    [UIView animateWithDuration:0.2 animations:^{
        number.center = CGPointMake(number.center.x, number.center.y - 50.0f);
        number.alpha = 0.0;
    } completion:^(BOOL completion) {
        [number removeFromSuperview];
    }];
}

- (void)fadeDecimalIn:(UILabel*)decimal {
    decimal.textColor = _didPay ? [DTColors colorForGreen] : [DTColors colorForRed];
    [self.numberContainer addSubview:decimal];
    decimal.center = CGPointMake(decimal.center.x, decimal.center.y + 50.0f);
    [UIView animateWithDuration:0.2 animations:^{
        decimal.alpha = 1.0;
    }];
}


- (void)fadeDecimalOut:(UILabel*)decimal {
    decimal.textColor = _didPay ? [DTColors colorForGreen] : [DTColors colorForRed];
    [UIView animateWithDuration:0.2 animations:^{
        decimal.alpha = 0.0;
    } completion:^(BOOL completion) {
        [decimal removeFromSuperview];
    }];
}

- (void)shiftDecimalAmount:(UILabel*)number {
    [UIView animateWithDuration:0.2 animations:^{
        number.center = CGPointMake(number.center.x + number.frame.size.width/2, number.center.y);
    }];
}

- (void)vibrateNumbers {
    [self vibrate:self.zeroLabel];
    for (UILabel *label in self.numberArray) {
        [self vibrate:label];
    }
    for (UILabel *label in self.decimalArray) {
        [self vibrate:label];
    }
}

- (void)vibrate:(UIView*)itemView {
    CGFloat t = 2.0;
    CGAffineTransform leftQuake  = CGAffineTransformTranslate(CGAffineTransformIdentity, -t, 0);
    CGAffineTransform rightQuake = CGAffineTransformTranslate(CGAffineTransformIdentity, t, 0);
    
    itemView.transform = leftQuake;  // starting point
    
    [UIView beginAnimations:@"earthquake" context:(__bridge void *)(itemView)];
    [UIView setAnimationRepeatAutoreverses:YES]; // important
    [UIView setAnimationRepeatCount:3];
    [UIView setAnimationDuration:0.05];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(earthquakeEnded:finished:context:)];
    
    itemView.transform = rightQuake; // end here & auto-reverse
    
    [UIView commitAnimations];
}

- (void)earthquakeEnded:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    if ([finished boolValue]) {
        UIView* item = (__bridge UIView *)context;
        item.transform = CGAffineTransformIdentity;
    }
}

#pragma mark - 
#pragma mark - UITextField Delegate

- (BOOL)textField: (UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField.tag == kTextFieldTagAmount) {
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
//        if (_enteringDecimals) {
//            NSArray *amountParts = [self.amount.text componentsSeparatedByString:@"."];
//            if ([amountParts count] > 1) {
//                
//            } else {
//                if (newLength > [self.numberArray count]) {
//                _enteringDecimals = NO;
//
//            }
//        }
        
        if ([string isEqualToString:@"."]) {
            if (_enteringDecimals) {
                [self vibrateNumbers];
                return NO;
            }
            UILabel *lastObject = nil;
            if ([self.numberArray count] > 0) {
                lastObject = [self.numberArray lastObject];
            } else {
                lastObject = self.zeroLabel;
            }
            int startingX = lastObject.frame.origin.x + lastObject.frame.size.width/2;
            int dotOffset = 28.0f;
            if (lastObject == self.zeroLabel) {
                dotOffset += kWIDTH_NUMBER/2;
            }
            CGPoint dotCenter = CGPointMake(startingX + dotOffset, lastObject.frame.origin.y + 12.0f);
            
            UILabel *dotLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50.0f, 50.0f)];
            dotLabel.text = @".";
            dotLabel.font = [DTFonts proximaNovaRegularSize:50.0f];
            dotLabel.textColor = [DTColors colorForGreen];
            dotLabel.center = dotCenter;
            [self fadeDecimalIn:dotLabel];
            if ([self.numberArray count] > 0) {
                for (DTNumberLabel *label in self.numberArray) {
                    [self shiftNumberLeft:label];
                }
                [self shiftDollarLeft];
            }
            
            [self.numberArray addObject:dotLabel];
            _enteringDecimals = YES;
            return YES;
        }
        // A number was pressed
        if (newLength > [self.numberArray count] + [self.decimalArray count]) {
            NSUInteger numDecimals = [self.decimalArray count];
            NSUInteger numNumbers = [self.numberArray count];
            // Ignore Zeros if no numbers pressed yet
            if (numNumbers == 0) {
                if ([string isEqualToString:@"0"]) {
                    [self vibrateNumbers];
                    return NO;
                }
            }
            if (_enteringDecimals) {
                if (numDecimals == 2) {
                    [self vibrateNumbers];
                    return NO;
                } else {
                    DTDecimalLabel *decimal = [DTDecimalLabel labelAsNumber:string];
                    int offset = 0.0f;
                    if ([self.numberArray count] == 1) {
                        offset += kWIDTH_NUMBER;
                    }
                    CGPoint nextCenter = CGPointMake(self.center.x + ((numNumbers - 1) * kWIDTH_NUMBER / 2) + (numDecimals * kWIDTH_DECIMAL) + offset, 80.0f);
                    decimal.center = nextCenter;
                    [self fadeNumberIn:decimal];
                    [self.decimalArray addObject:decimal];
                    return YES;
                }
            }
            
            // Max number length of 4
            if (newLength > 4) {
                [self vibrateNumbers];
                return NO;
            }
            NSUInteger prevDigits = [self.numberArray count];
            DTNumberLabel *number = [DTNumberLabel labelAsNumber:string];
            CGPoint nextCenter = CGPointMake(self.center.x + (prevDigits * kWIDTH_NUMBER / 2), 100.0f);
            number.center = nextCenter;
            for (DTNumberLabel *label in self.numberArray) {
                [self shiftNumberLeft:label];
            }
            if (numNumbers > 0) {
                [self shiftDollarLeft];
            }
            if ([self.numberArray count] == 0) {
                [UIView setAnimationsEnabled:NO];
                [self fadeNumberIn:number];
                [UIView setAnimationsEnabled:YES];
            } else {
                [self fadeNumberIn:number];
            }
            [self.zeroLabel setAlpha:0.0];
            
            [self.numberArray addObject:number];
            [self adjustNextButtonState];
        } else { // BACKSPACE WAS PRESSED
            if (_enteringDecimals) {
                // If no more decimals
                if ([self.decimalArray count] > 0) {
                    DTDecimalLabel *lastObject = [self.decimalArray lastObject];
                    [self.decimalArray removeObject:lastObject];
                    [self fadeNumberOut:lastObject];
                    return YES;
                } else {
                    _enteringDecimals = NO;
                    
                    // Remove Decimal
                    DTNumberLabel *lastObject = [self.numberArray lastObject];
                    [self.numberArray removeObject:lastObject];
                    [self fadeDecimalOut:lastObject];
                    
                    for (DTNumberLabel *label in self.numberArray) {
                        [self shiftNumberRight:label];
                    }
                    if ([self.numberArray count] > 0) {
                        [self shiftDollarRight];
                    }
                    return YES;
                }
            }
            DTNumberLabel *lastObject = [self.numberArray lastObject];
            [self.numberArray removeObject:lastObject];
            [self fadeNumberOut:lastObject];
            for (DTNumberLabel *label in self.numberArray) {
                [self shiftNumberRight:label];
            }
            if ([self.numberArray count] > 0) {
                [self shiftDollarRight];
            } else {
                [self.zeroLabel setAlpha:1.0];
                lastObject.alpha = 0.0;
                [lastObject removeFromSuperview];
            }
            [self adjustNextButtonState];
            return YES;

        }

    }
    return YES;
}



#pragma mark -
#pragma mark - Table Datasource/Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 27;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    char letter = 'a' + section;
    NSString *nsstringletter = [[NSString alloc] initWithBytes:&letter length:1 encoding:NSASCIIStringEncoding];

    return [[self.alphabeticalFriends objectForKey:nsstringletter] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DTFacebookFriendCell *cell = (DTFacebookFriendCell*)[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NSDictionary *friend;
    
    if (indexPath.section == 0) {
        
    } else {
        char letter = 'a' + indexPath.section;
        NSString *nsstringletter = [[NSString alloc] initWithBytes:&letter length:1 encoding:NSASCIIStringEncoding];
        friend = [[self.alphabeticalFriends objectForKey:nsstringletter] objectAtIndex:indexPath.row];
    }
    

    [cell.profilePicture setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture", [friend objectForKey:@"id"]]] placeholderImage:[UIImage imageNamed:@"default_user"]];
    cell.nameLabel.text = [friend objectForKey:@"name"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Recents";
    }
    return [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section - 1];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles] ;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    if (index == 0) {
        return 0;
    }
    return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index] + 1;
}
@end
