//
//  RegistrationViewController.h
//  CarRent
//
//  Created by Eugene Dimitrow on 3/19/14.
//  Copyright (c) 2014 RockyTurtle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "UITextField+Customised.h"
#import "Constants.h"

@interface RegistrationViewController : UITableViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *regUserName;
@property (strong, nonatomic) IBOutlet UITextField *regPassWord;
@property (strong, nonatomic) IBOutlet UITextField *repeatPassWord;
@property (strong, nonatomic) IBOutlet UITextField *regMail;
@property (strong, nonatomic) IBOutlet UITextField *repeatMail;

@property (strong, nonatomic) IBOutlet UITextField *regFirstName;
@property (strong, nonatomic) IBOutlet UITextField *regLastName;

@property (strong, nonatomic) IBOutlet UITextField *regBirthDate;

- (IBAction)signButton:(UIBarButtonItem *)sender;

@end
