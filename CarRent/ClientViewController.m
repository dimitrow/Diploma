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

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    _clientNameLabel.textColor = COLOR_MAIN_BLUE;
    _clientNameLabel.text = [NSString stringWithFormat:@"%@ %@",
                    [[PFUser currentUser] valueForKey:@"firstName"],
                    [[PFUser currentUser] valueForKey:@"lastName"]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)logOut:(id)sender
{
    [PFUser logOut];
    [self dismissViewControllerAnimated:YES completion:nil];


}

@end
