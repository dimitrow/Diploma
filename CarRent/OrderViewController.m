//
//  OrderViewController.m
//  CarRent
//
//  Created by U'Gene on 5/12/14.
//  Copyright (c) 2014 RockyTurtle. All rights reserved.
//

#import "OrderViewController.h"

@interface OrderViewController ()

@end

@implementation OrderViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)getTheCar:(id)sender
{
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        PFObject *order = [PFObject objectWithClassName:@"Orders"];
        PFObject *vehicle = [PFObject objectWithoutDataWithClassName:@"Vehicle" objectId:_car.carID];
        
        order[@"startDate"] = [NSDate date];
        order[@"user"] = [PFUser currentUser];
        order[@"vehicle"] = vehicle;
        
        
        vehicle[@"isAvaliable"] = @NO;
        
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc postNotificationName:@"review" object:nil];
        
        [order saveInBackground];
    }];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"review" object:nil];
}

@end
