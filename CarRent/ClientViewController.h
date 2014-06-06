//
//  ClientViewController.h
//  CarRent
//
//  Created by Eugene Dimitrow on 3/18/14.
//  Copyright (c) 2014 RockyTurtle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "LoginViewController.h"
#import "Order.h"


@interface ClientViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UILabel *clientNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *titleMain;
@property (strong, nonatomic) IBOutlet PFImageView *clientPic;

@property (strong, nonatomic) IBOutlet UITableView *ordersTable;
- (IBAction)resetVehicleStaus:(id)sender;

- (IBAction)getPicture:(id)sender;

@end
