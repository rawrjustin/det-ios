//
//  DTHomeViewController.m
//  det-ios
//
//  Created by Justin Huang on 10/24/13.
//  Copyright (c) 2013 Justin Huang. All rights reserved.
//

#import "DTHomeViewController.h"
#import "DTHomeSummaryView.h"
#import "UserInfo.h"
#import "DTAPI.h"
#import "DTUser.h"
#import "DTSummaryBlock.h"
#import "DTSummaryLayout.h"

#import <AFNetworking/UIImageView+AFNetworking.h>

@interface DTHomeViewController ()
@property (nonatomic, strong) UICollectionView *debtsList;

@property (nonatomic, strong) UIButton *debtButton;
@property (nonatomic, strong) DTTransactionView *transactionView;

@property (nonatomic, strong) UIView *header;

@property (nonatomic, strong) DTHomeSummaryView *summaryView;

@property (nonatomic, strong) UIButton *addDebtButton;

@property (nonatomic) BOOL isAddingDebt;
@end

static NSString * const kSummaryBlockIdentifier = @"SummaryBlock";

@implementation DTHomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.backgroundColor = [UIColor whiteColor];
        self.isAddingDebt = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupTableView];
    [self setupTransactionView];
    
    //[self createDummyData];
    
    [self setupHeaderBar];
    [self setupSummary];
    [self.debtsList registerClass:[DTSummaryBlock class] forCellWithReuseIdentifier:kSummaryBlockIdentifier];
}

- (void)createDummyData {
    [PFCloud callFunctionInBackground:@"createTransaction"
                       withParameters:@{@"571815533": @{
                                                @"name":    @"Allen Wu",
                                                @"email":   @"wua05@ucla.edu",
                                                @"amount":  @50
                                                },
                                        @"fbIdentifiers":   @[@"571815533"],
                                        @"user":    @"x5SLz4374r",
                                        @"description": @"Allen owes me for strippers"
                                        }
                                block:^(NSNumber *ratings, NSError *error) {
                                    if (!error) {
                                        [self pullData];
                                    }
                                }];
}

- (void)viewWillAppear:(BOOL)animated {
    [self pullData];
}

#pragma mark - 
#pragma mark - API Calls

- (void)pullData {
    if ([DTUser getCurrentUser]) {
        [DTAPI debtList:^(NSArray * debts) {
            [[UserInfo sharedInstance] parseDebtData:debts];
            [self.debtsList reloadData];
            [self.summaryView setOwedToYou:[UserInfo sharedInstance].owed andYouOwe:[UserInfo sharedInstance].owe];
        }];
    }
}

- (void)createTransaction:(NSDictionary*)params {
    if (params) {
        [PFCloud callFunctionInBackground:@"createTransaction"
                           withParameters:params
                                    block:^(NSNumber *ratings, NSError *error) {
                                        if (!error) {
                                            [self pullData];
                                        }
                                        }];
    }
}

#pragma mark - 
#pragma mark - View Setup

- (void)setupSummary {
    self.summaryView = [[DTHomeSummaryView alloc] initWithFrame:CGRectMake(0, 64.0f + 10.0f, [UIScreen mainScreen].bounds.size.width, 50.0f)];
    [self.view addSubview:self.summaryView];
}

- (void)setupHeaderBar {
    self.header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64.0f)];
    self.header.backgroundColor = [DTColors colorForGreen];
    [self.view addSubview:self.header];
    
    UILabel *headertitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 24.0f, [UIScreen mainScreen].bounds.size.width, 40.0f)];
    headertitle.font = [DTFonts proximaNovaRegularSize:24.0];
    headertitle.textColor = [UIColor whiteColor];
    headertitle.textAlignment = NSTextAlignmentCenter;
    headertitle.text = @"debttrack";
    [self.header addSubview:headertitle];
    
    self.addDebtButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.addDebtButton setImage:[UIImage imageNamed:@"add_button"] forState:UIControlStateNormal];
    [self.addDebtButton addTarget:self action:@selector(startNewDebt) forControlEvents:UIControlEventTouchUpInside];
    [self.addDebtButton setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 40.0f - 10.0f, 22.0f, 40.0f, 40.0f)];
    [self.header addSubview:self.addDebtButton];
}

- (void)setupTableView {
    //Flow Layout
    DTSummaryLayout *summaryLayout = [[DTSummaryLayout alloc] init];
    
    // Collection View
    self.debtsList = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64.0f + 50.0f + 10.0f, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) collectionViewLayout:summaryLayout];
    self.debtsList.delegate = self;
    self.debtsList.dataSource = self;
    self.debtsList.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.debtsList];
}

- (void)setupTransactionView {
    self.transactionView = [[DTTransactionView alloc] initWithFrame:CGRectMake(0, 64.0f, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64.0f)];
    self.transactionView.delegate = self;
    self.transactionView.alpha = 0.0;
    [self.view addSubview:self.transactionView];
    [self.view sendSubviewToBack:self.transactionView];
}

#pragma mark -
#pragma mark - TransactionView delegates

- (void)cancelTransaction {
    [UIView animateWithDuration:0.3                                                                                                                                                                                      animations:^{
        self.transactionView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 50.0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    } completion:^(BOOL completion) {
        [self.transactionView resetScreens];
    }];
}

#pragma mark - 
#pragma mark - Actions

- (void)startNewDebt {
    self.addDebtButton.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.5 delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        if (_isAddingDebt) {
            self.summaryView.alpha = 1.0;
            self.debtsList.frame = CGRectMake(0, 64.0f + 50.0f + 10.0f, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
            self.debtsList.alpha = 1.0;
            self.addDebtButton.transform = CGAffineTransformRotate(self.addDebtButton.transform, -M_PI_4);
            //MAKE SURE TO RESET TRANSACTION VIEW
            [self.transactionView resetScreens];
            self.transactionView.alpha = 0.0;
            _isAddingDebt = NO;
        } else {
            [self.view endEditing:YES];
            self.summaryView.alpha = 0.0;
            self.debtsList.center = CGPointMake(self.debtsList.center.x, self.debtsList.center.y + [UIScreen mainScreen].bounds.size.height);
            self.addDebtButton.transform = CGAffineTransformRotate(self.addDebtButton.transform, M_PI_4);
            self.transactionView.alpha = 1.0;
            _isAddingDebt = YES;
        }
        
    } completion:^(BOOL completion) {
        if (_isAddingDebt) {
            [self.transactionView startNewDebt];
        }
        self.addDebtButton.userInteractionEnabled = YES;
    }];
}


#pragma mark -
#pragma mark - UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 25;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [[UserInfo sharedInstance].debts count];
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *fbId = [[UserInfo sharedInstance].sortedKeys objectAtIndex:indexPath.section];
    NSDictionary *debtDictionary = [[UserInfo sharedInstance].debts objectForKey:fbId];
    DTSummaryBlock *cell = (DTSummaryBlock*)[collectionView dequeueReusableCellWithReuseIdentifier:kSummaryBlockIdentifier forIndexPath:indexPath];
    
    NSURL *profileURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", fbId]];
    [cell.profileImage setImageWithURL:profileURL];
    cell.backgroundColor = [UIColor whiteColor];
    cell.amount = [[debtDictionary objectForKey:@"amount"] doubleValue];
    cell.nameLabel.text = [debtDictionary objectForKey:@"name"];
    return cell;
}

#pragma mark -
#pragma mark - UICollectionView Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath  {
    
}

@end
