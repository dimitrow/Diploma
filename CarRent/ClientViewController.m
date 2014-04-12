//
//  ClientViewController.m
//  CarRent
//
//  Created by Eugene Dimitrow on 3/18/14.
//  Copyright (c) 2014 RockyTurtle. All rights reserved.
//

#import "ClientViewController.h"
#import "Constants.h"

@interface ClientViewController ()


@end

@implementation ClientViewController

- (void)viewDidAppear:(BOOL)animated
{
    [PFUser currentUser];
    if ([PFUser currentUser]) {
        NSLog(@"welcome dude");
        _clientNameLabel.textColor = COLOR_MAIN_BLUE;
        _clientNameLabel.text = [NSString stringWithFormat:@"%@ %@",
                                 [[PFUser currentUser] valueForKey:@"firstName"],
                                 [[PFUser currentUser] valueForKey:@"lastName"]];
        
    } else {
        NSLog(@"get the fuck over there");
        _clientNameLabel.text = [NSString stringWithFormat:@"%@ %@",
                                 [[PFUser currentUser] valueForKey:@"---"],
                                 [[PFUser currentUser] valueForKey:@"---"]];
        [self performSegueWithIdentifier:@"loginSegue" sender:self];

    }
}

- (void)viewDidLoad
{

    [super viewDidLoad];

    
}

- (void)getLoginWindow
{
    LoginViewController *loginView = [[LoginViewController alloc] init];
    [self presentViewController:loginView animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)logOut:(id)sender
{
    [PFUser logOut];
    [self performSegueWithIdentifier:@"loginSegue" sender:self];

}

@end
