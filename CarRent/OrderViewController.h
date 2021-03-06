//
//  OrderViewController.h
//  CarRent
//
//  Created by Eugene Dimitrow on 5/12/14.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Car.h"

@interface OrderViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UILabel *mainText;
@property (strong, nonatomic) IBOutlet UILabel *fromLabel;
@property (strong, nonatomic) IBOutlet UILabel *toLabel;
@property (strong, nonatomic) IBOutlet UILabel *costLabel;

@property (nonatomic, strong) Car *car;

@property (strong, nonatomic) IBOutlet UITextField *textFieldFrom;
@property (strong, nonatomic) IBOutlet UITextField *textFieldTo;

- (IBAction)cancel:(id)sender;
- (IBAction)getTheCar:(id)sender;
- (IBAction)checkCar:(id)sender;

@end
