//
//  CarsListTableViewController.h
//  CarRent
//
//  Created by Eugene Dimitrow on 3/18/14.
//  Copyright (c) 2014 RockyTurtle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "ClientViewController.h"
#import "Constants.h"
#import <dispatch/dispatch.h>
#import "LoginViewController.h"

@interface CarsListTableViewController : UITableViewController <DataRetrivalDelegate>
{
    NSMutableDictionary *_vehicles;
    NSArray *_brands;
    
}

@property (strong, nonatomic) IBOutlet UITableView *carsTableView;
@property (weak, nonatomic) IBOutlet PFImageView *smallImage;


@end
