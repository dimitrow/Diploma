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
    NSArray *ordersData;
    
    NSDate *rentStart;
    NSDate *rentEnd;
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
    NSDate *endDate = [_dateFormatter dateFromString:@"12, 31, 2020"];
    [_datePicker setMinimumDate:startDate];
    [_datePicker setMaximumDate:endDate];
    [_textFieldFrom setInputView:_datePicker];
    [_textFieldTo setInputView:_datePicker];
}

- (void)retriveCars
{
    PFQuery *dataCheck = [PFQuery queryWithClassName:@"Orders"];
    //[dataCheck includeKey:@"vehicle"];
    [dataCheck whereKey:@"vehicle" equalTo:[PFObject objectWithoutDataWithClassName:@"Vehicle" objectId:_car.carID]];
    [dataCheck findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        ordersData = objects;
    }];
    NSLog(@"%@", ordersData);
}

-(void)updateTextField:(id)sender
{
    UIDatePicker *picker = (UIDatePicker*)sender;
    
    NSString *datePicked = [_dateFormatter stringFromDate:picker.date];
    
    UITextField *activeTextField = (UITextField*)[self.view viewWithTag:textFieldTag];
    activeTextField.text = datePicked;
    
    if (textFieldTag == 911){
        rentStart = picker.date;
    } else if (textFieldTag == 912) {
        rentEnd = picker.date;
    }
    
    //[self retriveCars];

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
}

- (IBAction)cancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)getTheCar:(id)sender
{
    if ((_textFieldFrom.text.length && _textFieldTo.text.length) != 0){
    
        PFObject *order = [PFObject objectWithClassName:@"Orders"];
        PFObject *vehicle = [PFObject objectWithoutDataWithClassName:@"Vehicle" objectId:_car.carID];
        
        order[@"startDate"] = rentStart;
        order[@"endDate"] = rentEnd;
        order[@"user"] = [PFUser currentUser];
        order[@"vehicle"] = vehicle;
                
        vehicle[@"isAvaliable"] = @NO;
        
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc postNotificationName:@"review" object:nil];
        [nc postNotificationName:@"busy" object:nil];
        [order saveInBackground];
        
        
        
    [self dismissViewControllerAnimated:YES completion:^{
        

    }];
        
    } else {
        NSString *message = @"You have to choose date when you want to get this car for ride";
        ERROR_ALERT(ERROR, message, AW_BT_FAIL);
    }
    [self retriveCars];

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
