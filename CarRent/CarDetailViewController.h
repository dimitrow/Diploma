//
//  CarDetailViewController.h
//  CarRent
//
//  Created by U'Gene on 4/8/14.
//  Copyright (c) 2014 RockyTurtle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Car.h"
#import "Constants.h"

@interface CarDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet PFImageView *mainPicture;
@property (strong, nonatomic) IBOutlet UIView *mainPictureBack;

@property (strong, nonatomic) IBOutlet UILabel *fullName;


@property (nonatomic, strong) Car *car;

@end
