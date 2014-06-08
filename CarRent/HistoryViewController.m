//
//  HistoryViewController.m
//  CarRent
//
//  Created by Eugene Dimitrow on 6/4/14.
//  Copyright (c) 2014 RockyTurtle. All rights reserved.
//

#import "HistoryViewController.h"

@interface HistoryViewController ()
{
    NSArray *_picture;
}


@end

@implementation HistoryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self getMainPicture];
    
    _carName.text = _order.carFullName;
    _orderDate.text = _order.orderDate;
    _orderNumber.text = [NSString stringWithFormat:@"Order #:%@", _order.orderID];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
- (IBAction)cancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)getMainPicture
{
    PFQuery *query = [PFQuery queryWithClassName:@"Pictures"];
    [query whereKey:@"vehicle" equalTo:[PFObject objectWithoutDataWithClassName:@"Vehicle" objectId:_order.carID]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
       
        _picture = [objects valueForKey:@"photo"];
        _carPicture.file = [_picture firstObject];
        [_carPicture loadInBackground];
    }];
    
}


@end
