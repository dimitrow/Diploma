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
{
    NSArray *_orders;
}


@end

@implementation ClientViewController

- (void)viewDidAppear:(BOOL)animated
{
    [PFUser currentUser];
    if ([PFUser currentUser]) {
        _clientNameLabel.textColor =[UIColor whiteColor];
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
    
    _clientPic.layer.cornerRadius = _clientPic.frame.size.height / 2;
    _clientPic.layer.masksToBounds = YES;
//    _clientPic.layer.shadowColor = [UIColor blackColor].CGColor;
//    _clientPic.layer.shadowOffset = CGSizeMake(0.0, 0.0);
//    _clientPic.layer.shadowOpacity = 0.9;
    
    [self getOrders];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_orders valueForKey:@"objectId" ] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderCell" forIndexPath:indexPath];
    UILabel *orderNumber = (UILabel *)[cell viewWithTag:1984];
    
    orderNumber.text = [[_orders valueForKey:@"objectId"] objectAtIndex:indexPath.row];
    
    
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)getOrders
{
    PFQuery *ordersQuery = [PFQuery queryWithClassName:@"Orders"];
    [ordersQuery whereKey:@"user" equalTo:[PFUser currentUser]];
    [ordersQuery includeKey:@"vehicle"];
    [ordersQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        _orders = objects;
        
        NSLog(@"%@", _orders);
        [_ordersTable reloadData];
    }];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self getOrders];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (IBAction)resetVehicleStaus:(id)sender
{
    
    PFQuery *orderQuery = [PFQuery queryWithClassName:@"Vehicle"];
    [orderQuery whereKey:@"isAvaliable" equalTo:@NO];
    [orderQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        for (PFObject *vehicle in objects) {
            vehicle[@"isAvaliable"] = @YES;
            [vehicle saveInBackground];
        }
        
    }];

}

@end
