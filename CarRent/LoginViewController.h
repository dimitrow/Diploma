//
//  LoginViewController.h
//  CarRent
//
//  Created by Eugene Dimitrow on 3/18/14.
//  Copyright (c) 2014 RockyTurtle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "UITextField+Customised.h"
#import "Constants.h"
#import <dispatch/dispatch.h>

//---

@protocol DataRetrivalDelegate <NSObject>

- (void)retriveDatas;

@end

//---

@interface LoginViewController : UIViewController <UIAlertViewDelegate, UITextFieldDelegate>

@property (nonatomic, weak) id <DataRetrivalDelegate> delegate;

@property (strong, nonatomic) IBOutlet UITextField *userTextField;
@property (strong, nonatomic) IBOutlet UITextField *passWordTextField;

- (IBAction)logIn:(id)sender;
- (IBAction)forgottenPassword:(id)sender;

@end
