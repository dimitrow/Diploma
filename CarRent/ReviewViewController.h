//
//  ReviewViewController.h
//  CarRent
//
//  Created by Eugene Dimitrow on 5/8/14.
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
