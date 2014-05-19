//
//  OrderViewController.m
//  CarRent
//
//  Created by U'Gene on 5/12/14.
//  Copyright (c) 2014 RockyTurtle. All rights reserved.
//

#import "OrderViewController.h"
#import "Constants.h"

@interface OrderViewController ()
{
    UIDatePicker *_datePicker;
    NSDateFormatter *_dateFormatter;
    NSInteger textFieldTag;
}
@property (strong, nonatomic) IBOutlet UIButton *getItTitle;
@property (strong, nonatomic) IBOutlet UIButton *cancelTitle;

@end

@implementation OrderViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _datePicker = [[UIDatePicker alloc]init];
    [_datePicker addTarget:self action:@selector(updateTextField:) forControlEvents:UIControlEventValueChanged];
    _datePicker.datePickerMode = UIDatePickerModeDate;
    _datePicker.backgroundColor = [UIColor whiteColor];
    
    _textFieldTo.delegate = self;
    _textFieldFrom.delegate = self;
    
    _dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setDateFormat:@"MMMM, dd, YYYY"];
    
    NSTimeZone *tz = [NSTimeZone localTimeZone];
    [_dateFormatter setTimeZone:tz];
    
    NSDate *startDate = [NSDate date];
    NSDate *endDate = [_dateFormatter dateFromString:@"12-31-2020"];
    [_datePicker setMinimumDate:startDate];
    [_datePicker setMaximumDate:endDate];
    [_textFieldFrom setInputView:_datePicker];
    [_textFieldTo setInputView:_datePicker];
}

-(void)updateTextField:(id)sender
{
    UIDatePicker *picker = (UIDatePicker*)sender;
    
    NSString *datePicked = [_dateFormatter stringFromDate:picker.date];
    
    UITextField *activeTextField = (UITextField*)[self.view viewWithTag:textFieldTag];
    activeTextField.text = datePicked;
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    textFieldTag = textField.tag;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)getTheCar:(id)sender
{
    if ((_textFieldFrom.text.length && _textFieldTo.text.length) != 0){
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        PFObject *order = [PFObject objectWithClassName:@"Orders"];
        PFObject *vehicle = [PFObject objectWithoutDataWithClassName:@"Vehicle" objectId:_car.carID];
        
        order[@"startDate"] = [_dateFormatter dateFromString:_textFieldFrom.text];
        order[@"endDate"] = [_dateFormatter dateFromString:_textFieldTo.text];
        order[@"user"] = [PFUser currentUser];
        order[@"vehicle"] = vehicle;
        
        
        vehicle[@"isAvaliable"] = @NO;
        
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc postNotificationName:@"review" object:nil];
        [nc postNotificationName:@"busy" object:nil];
        [order saveInBackground];
    }];
    } else {
        NSString *message = @"You have to choose date when you want to get this car for ride";
        ERROR_ALERT(ERROR, message, AW_BT_FAIL);
    }
}

- (void) viewWillDisappear:(BOOL)animated
{
    //[[NSNotificationCenter defaultCenter] removeObserver:self name:@"review" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(BOOL)shouldAutorotate
{
    return NO;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return (UIInterfaceOrientationMaskPortrait);
}

@end
