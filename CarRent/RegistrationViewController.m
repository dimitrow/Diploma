//
//  RegistrationViewController.m
//  CarRent
//
//  Created by Eugene Dimitrow on 3/19/14.
//  Copyright (c) 2014 RockyTurtle. All rights reserved.
//

#import "RegistrationViewController.h"

@interface RegistrationViewController ()
{
    UIDatePicker *_datePicker;
    BOOL _uNameOK;
    BOOL _nameOK;
    BOOL _passOK;
    BOOL _mailOK;
    BOOL _dateOK;
}

@end

@implementation RegistrationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _datePicker = [[UIDatePicker alloc]init];
    [_datePicker addTarget:self action:@selector(updateTextField:) forControlEvents:UIControlEventValueChanged];
    _datePicker.datePickerMode = UIDatePickerModeDate;
    _datePicker.backgroundColor = [UIColor whiteColor];
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd-yyyy"];
    NSDate *startDate = [dateFormatter dateFromString:@"05-02-1953"];
    NSDate *endDate = [dateFormatter dateFromString:@"12-31-1996"];
    [_datePicker setMinimumDate:startDate];
    [_datePicker setMaximumDate:endDate];
    [self.regBirthDate setInputView:_datePicker];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0;
}


- (IBAction)signButton:(UIBarButtonItem *)sender
{
    
    PFUser *user = [PFUser user];
    
    user.username = self.regUserName.text;
    user.password = self.regPassWord.text;
    [user setObject:self.regFirstName.text forKey:@"firstName"];
    [user setObject:self.regLastName.text forKey:@"lastName"];
    [user setObject:self.regMail.text forKey:@"email"];
    [user setObject:_datePicker.date forKey:@"birthDate"];
    
    NSArray *checkArray = @[@(_uNameOK), @(_passOK), @(_mailOK), @(_dateOK)];
    
    if (![checkArray containsObject:@0]) {
        NSLog(@"You're ice cool mate");
    }else{
        NSLog(@"FU Dude");

    }
    
    if (_passOK &&  _mailOK && _uNameOK) {
        
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                
                [self dismissViewControllerAnimated:YES completion:nil];
                
            } else {
                
                NSString *message = [[error userInfo] objectForKey:@"error"];
                ERROR_ALERT(ERROR, message, AW_BT_FAIL);
            }
        }];
        
    }else{
        
        NSString *message = @"Check entered information";
        ERROR_ALERT(ERROR, message, AW_BT_FAIL);
    }
}

-(void)updateTextField:(id)sender
{
    UIDatePicker *picker = (UIDatePicker*)self.regBirthDate.inputView;
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MMMM, dd, YYYY"];
    NSString *dateToShow = [df stringFromDate:picker.date];
    
    self.regBirthDate.text = dateToShow;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag == 102){
        if ((self.regPassWord.text == nil) || ([self.regPassWord.text  isEqual: @""])) {
        NSString *message = @"You have to enter your password first";
        ERROR_ALERT(ERROR, message, AW_BT_FAIL);
        }
    }
    return YES;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(9.0, 0, tableView.frame.size.width, 30.0)];
    header.backgroundColor = [UIColor whiteColor];
    
    
    NSArray *tiles = @[@"Required Data", @"Personal Info"];
    UILabel *headerTitle = [[UILabel alloc] initWithFrame:header.frame];
    headerTitle.font = FONT_ULTRA_LIGHT;
    headerTitle.text = [tiles objectAtIndex:section];;
    headerTitle.textColor = COLOR_MAIN_BLUE;
    
    [header addSubview:headerTitle];
    
    return header;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (textField.tag == 100) {
        if ([textField validateUserNameWithString:textField.text]){
            
            [textField fieldWithColor:COLOR_CORRECT_INPUT];
            _uNameOK = YES;
            
        }else{
            
            [textField fieldWithColor:COLOR_WRONG_INPUT];
            _uNameOK = NO;

        }
    }else if (textField.tag == 101){
        if ([textField validatePasswordWithString:textField.text]){
            
            [textField fieldWithColor:COLOR_CORRECT_INPUT];
            _passOK = YES;
            
        }else{
            
            [textField fieldWithColor:COLOR_WRONG_INPUT];
            NSString *message = @"Password should be more than 8 symbols long";
            ERROR_ALERT(ERROR, message, AW_BT_FAIL);
            _passOK = NO;
            
        }
    }else if (textField.tag == 102){
        if ([self.repeatPassWord.text isEqualToString:self.regPassWord.text] && (self.repeatPassWord.text != nil) && (![self.repeatPassWord.text isEqualToString:@""])){
            [textField fieldWithColor:COLOR_CORRECT_INPUT];
            _passOK = YES;
        }else{
            [textField fieldWithColor:COLOR_WRONG_INPUT];
            _passOK = NO;
            return YES;
        }
    }else if (textField.tag == 103){
        if ([textField validateEmailWithString:textField.text]){
            
            [textField fieldWithColor:COLOR_CORRECT_INPUT];
            _mailOK = YES;
            
        }else{
            
            [textField fieldWithColor:COLOR_WRONG_INPUT];
            _mailOK = NO;
            
        }
    }else if (textField.tag == 104){
        if ([self.repeatMail.text isEqualToString:self.regMail.text] && [textField validateEmailWithString:textField.text]){
            
            [textField fieldWithColor:COLOR_CORRECT_INPUT];
            _mailOK = YES;
            
        }else{
            
            [textField fieldWithColor:COLOR_WRONG_INPUT];
            _mailOK = NO;
            
        }
    }else if (textField.tag == 105 || textField.tag == 106){
        if ([textField validateNameWithString:textField.text]){
        
            [textField fieldWithColor:COLOR_CORRECT_INPUT];
            _nameOK = YES;
            
        }else{
            
            [textField fieldWithColor:COLOR_WRONG_INPUT];
            _nameOK = NO;
            
        }
    }else if (textField.tag == 107){
        if (textField.text ==nil || [textField.text isEqualToString:@""]){
            
            [textField fieldWithColor:COLOR_WRONG_INPUT];
            _dateOK = NO;
            
        }else{
            
            [textField fieldWithColor:COLOR_CORRECT_INPUT];
            _dateOK = YES;
        }
    }
    return YES;
}

@end
