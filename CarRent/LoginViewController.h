//
//  LoginViewController.h
//  CarRent
//
//  Created by Eugene Dimitrow on 3/18/14.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "UITextField+Customised.h"
#import "Constants.h"
#import <dispatch/dispatch.h>


@interface LoginViewController : UIViewController <UIAlertViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *userTextField;
@property (strong, nonatomic) IBOutlet UITextField *passWordTextField;

- (IBAction)logIn:(id)sender;
- (IBAction)forgottenPassword:(id)sender;

@end
