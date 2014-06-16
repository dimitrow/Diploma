//
//  LoginViewController.m
//  CarRent
//
//  Created by Eugene Dimitrow on 3/18/14.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    _userTextField.text = @"U'Gene";
    _passWordTextField.text = @"receiver";
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}


- (IBAction)logIn:(id)sender
{
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [PFUser logInWithUsernameInBackground:self.userTextField.text
                                     password:self.passWordTextField.text
                                        block:^(PFUser *user, NSError *error) {
            if (user) {
                
                [self dismissViewControllerAnimated:YES completion:nil];
                
            } else {
                
                NSString *message = [[error userInfo] objectForKey:@"error"];
                ERROR_ALERT(ERROR, message, AW_BT_FAIL);
            }
        }];
    });

}

- (IBAction)forgottenPassword:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Password recovery"
                                                    message:@"Type in your email"
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles: nil];
    
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
    

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UITextField *emailString = [alertView textFieldAtIndex:0];
    if (emailString.text == nil || [emailString.text isEqualToString:@""]) {

    }else{
        if ([PFUser requestPasswordResetForEmail:emailString.text] == YES) {
            
            NSString *message = @"Email with further instructions how to restore your password, was sent";
            ERROR_ALERT(nil, message, AW_BT_SUC);

        }else{
            
            NSString *message = @"This is not a valid email";            
            ERROR_ALERT(ERROR, message, AW_BT_FAIL);
        }
    }
}

@end
