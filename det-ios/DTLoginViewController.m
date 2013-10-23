//
//  DTLoginViewController.m
//  det-ios
//
//  Created by Justin Huang on 10/22/13.
//  Copyright (c) 2013 Justin Huang. All rights reserved.
//

#import "DTLoginViewController.h"
#import "DTAPI.h"
@interface DTLoginViewController ()

@end

@implementation DTLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [loginButton setFrame:CGRectMake(100, 100, 120, 50)];
    [loginButton setTitle:@"Login" forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
    
}

- (IBAction)login:(id)sender {
    [PFFacebookUtils logInWithPermissions:[NSArray arrayWithObjects:@"email", nil] block:^(PFUser *user, NSError *error) {
        if (!user) {
            NSLog(@"Uh oh. The user cancelled the Facebook login.");
        } else if (user.isNew) {
            NSLog(@"User signed up and logged in through Facebook!");
            [DTAPI linkUser:user];
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            NSLog(@"User logged in through Facebook!");
            [DTAPI linkUser:user];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
