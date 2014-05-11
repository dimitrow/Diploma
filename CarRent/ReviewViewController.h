//
//  ReviewViewController.h
//  CarRent
//
//  Created by Eugene Dimitrow on 5/8/14.
//  Copyright (c) 2014 RockyTurtle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Car.h"

@interface ReviewViewController : UIViewController
{
    
}

@property (nonatomic, strong) Car *car;
@property (weak, nonatomic) IBOutlet UITextField *reviewText;

- (IBAction)leaveReview:(id)sender;
- (IBAction)cancel:(id)sender;

@end
