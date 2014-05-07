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
        _clientNameLabel.textColor = COLOR_MAIN_BLUE;
        _clientNameLabel.text = [NSString stringWithFormat:@"%@ %@",
                                 [[PFUser currentUser] valueForKey:@"firstName"],
                                 [[PFUser currentUser] valueForKey:@"lastName"]];
        
    } else {
        _clientNameLabel.text = [NSString stringWithFormat:@"%@ %@",
                                 [[PFUser currentUser] valueForKey:@"---"],
                                 [[PFUser currentUser] valueForKey:@"---"]];
        [self performSegueWithIdentifier:@"loginSegue" sender:self];

    }
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    _titleMain.font = FONT_TITLE;
    _titleMain.text = @"Personal";


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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
