//
//  HistoryViewController.h
//  CarRent
//
//  Created by ghost on 6/4/14.
//  Copyright (c) 2014 RockyTurtle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Order.h"

@interface HistoryViewController : UIViewController

@property (strong, nonatomic) IBOutlet PFImageView *carMainPicture;
@property (nonatomic, strong) Order *order;


@end
