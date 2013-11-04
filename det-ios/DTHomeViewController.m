//
//  DTHomeViewController.m
//  det-ios
//
//  Created by Justin Huang on 10/24/13.
//  Copyright (c) 2013 Justin Huang. All rights reserved.
//

#import "DTHomeViewController.h"
#import "UserInfo.h"
#import "DTAPI.h"

@interface DTHomeViewController ()
@property (nonatomic, strong) UITableView *debtsTable;
@property (nonatomic, strong) UIButton *debtButton;
@property (nonatomic, strong) DTTransactionView *transactionView;
@end

@implementation DTHomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self pullData];
    [self setupTableView];
    [self setupTransactionView];
	// Do any additional setup after loading the view.
}

- (void)pullData {
    [DTAPI debtList:^(NSArray * debts) {
        [[UserInfo sharedInstance] parseDebtData:debts];
        [self.debtsTable reloadData];
    }];
}

- (void)setupTableView {
    self.debtsTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 50.0) style:UITableViewStylePlain];
    [self.view addSubview:self.debtsTable];
}

- (void)setupTransactionView {
    self.transactionView = [[DTTransactionView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 50.0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    self.transactionView.delegate = self;
    [self.view addSubview:self.transactionView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TransactionView delegates

- (void)revealTransactionInput {
    [UIView animateWithDuration:0.3 animations:^{
        self.transactionView.center = self.view.center;
    }];
}

- (void)cancelTransaction {
    [UIView animateWithDuration:0.3 animations:^{
        self.transactionView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 50.0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    } completion:^(BOOL completion) {
        [self.transactionView resetScreens];
    }];
}

#pragma mark - tableview datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[UserInfo sharedInstance].sortedKeys count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    static NSString *cellId = @"cellId";
    cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    return cell;
}

@end
