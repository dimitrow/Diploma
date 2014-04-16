//
//  PageContentViewController.h
//  CarRent
//
//  Created by Eugene Dimitrow on 4/16/14.
//  Copyright (c) 2014 RockyTurtle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Car.h"

@interface PageContentViewController : UIViewController
@property (weak, nonatomic) IBOutlet PFImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property NSUInteger pageIndex;
@property NSString *titleText;
@property PFImageView *imageFile;

@end
