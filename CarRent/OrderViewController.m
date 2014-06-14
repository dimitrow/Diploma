//
//  OrderViewController.m
//  CarRent
//
//  Created by Eugene Dimitrow on 5/12/14.
//  Copyright (c) 2014 RockyTurtle. All rights reserved.
//

#import "OrderViewController.h"
#import "Constants.h"
#import <EventKit/EventKit.h>

@interface OrderViewController ()
{
    UIDatePicker *_datePicker;
    NSDateFormatter *_dateFormatter;
    NSInteger textFieldTag;
    NSArray *ordersData;
    NSDictionary *vehicleData;
    
    NSDate *rentStart;
    NSDate *rentEnd;
    
    EKEventStore *_eventStore;
    float _total;
    
}
@property (strong, nonatomic) IBOutlet UIButton *getItTitle;
@property (strong, nonatomic) IBOutlet UIButton *cancelTitle;

@end

@implementation OrderViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self retriveOrdersData];
    [self getCarData];
    
    
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
    NSDate *endDate = [NSDate dateWithTimeIntervalSinceNow:(60*60*24*90)];
    [_datePicker setMinimumDate:startDate];
    [_datePicker setMaximumDate:endDate];
    [_textFieldFrom setInputView:_datePicker];
    [_textFieldTo setInputView:_datePicker];
    
    self.getItTitle.userInteractionEnabled = NO;
    self.getItTitle.tintColor = [UIColor lightTextColor];
    _costLabel.text = @"$-.--";
}

- (void)viewWillAppear:(BOOL)animated
{
    UIAlertView *welcomeAlert = [[UIAlertView alloc] initWithTitle:nil message:@"Please enter a date, when you will need to get this car, after it, make an availiability check" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [welcomeAlert show];
}

- (void)getCarData
{
    PFQuery *carData = [PFQuery queryWithClassName:@"Vehicle"];
    [carData includeKey:@"brandName"];
    //[carData whereKey:@"objectId" equalTo:_car.carID];
    [carData getObjectInBackgroundWithId:_car.carID block:^(PFObject *object, NSError *error) {
        vehicleData = (NSDictionary *)object;
    }];
}

- (void)retriveOrdersData
{
    PFQuery *dataCheck = [PFQuery queryWithClassName:@"Orders"];
    [dataCheck includeKey:@"vehicle"];
    [dataCheck orderByAscending:@"startDate"];
    [dataCheck whereKey:@"vehicle" equalTo:[PFObject objectWithoutDataWithClassName:@"Vehicle" objectId:_car.carID]];
    [dataCheck findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        ordersData = objects;

        
    }];
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
        
        NSTimeInterval secBetweenTwoDays = [rentEnd timeIntervalSinceDate:rentStart];
        int rentDays = secBetweenTwoDays/(3600 *24);
        float price = [[vehicleData valueForKey:@"cost"] floatValue];
        
        if (secBetweenTwoDays == 0) {
            _costLabel.text = [NSString stringWithFormat:@"%.2f", price];
        } else {
            _total = price * rentDays;
            _costLabel.text = [NSString stringWithFormat:@"%.2f", _total];
        }
        


        
    }
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
        order[@"totalAmount"] = _costLabel.text;
                
    //FIXME:        //vehicle[@"isAvaliable"] = @NO;  maybe add later if needed
        
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc postNotificationName:@"review" object:nil];
        
        //[nc postNotificationName:@"busy" object:nil];
        
        [order saveInBackground];
        
        [self createAnEvent];
        [self dismissViewControllerAnimated:YES completion:nil];
        
        
    } else {
        NSString *message = @"You have to choose date when you want to get this car for ride";
        ERROR_ALERT(ERROR, message, AW_BT_FAIL);
    }

}

- (IBAction)checkCar:(id)sender
{
    [self retriveOrdersData];
    
    
    if (ordersData.count == 0){
        
        NSString *message = [NSString stringWithFormat:@"Successful, you can use this car from %@ til %@", rentStart, rentEnd];

        ERROR_ALERT(CHECK_RES, message, AW_BT_SUC);
        
        self.getItTitle.userInteractionEnabled = YES;
        self.getItTitle.tintColor = [UIColor blueColor];
        
    }else{
        int i;
        for (i = 0; i < [ordersData count]; i++) {
            
            NSComparisonResult startWithStart = [rentStart compare:[[ordersData valueForKey:@"startDate"] objectAtIndex:i]];
            NSComparisonResult endWithStart = [rentEnd compare:[[ordersData valueForKey:@"startDate"] objectAtIndex:i]];
            NSComparisonResult endWithEnd = [rentEnd compare:[[ordersData valueForKey:@"endDate"] objectAtIndex:i]];
            
            if ([ordersData count] == 1) {
                NSComparisonResult startWithEnd = [rentStart compare:[[ordersData valueForKey:@"endDate"] objectAtIndex:i]];
                if (((startWithStart == NSOrderedAscending) && (endWithStart == NSOrderedAscending)) || ((startWithEnd == NSOrderedDescending) && (endWithEnd == NSOrderedDescending))) {

                    NSString *message = [NSString stringWithFormat:@"Successful, you can use this car from %@ til %@", rentStart, rentEnd];

                    ERROR_ALERT(CHECK_RES, message, AW_BT_SUC);
                    
                    self.getItTitle.userInteractionEnabled = YES;
                    self.getItTitle.tintColor = [UIColor blueColor];
                    
                    break;
                } else if ((endWithStart == NSOrderedDescending) || (endWithEnd == NSOrderedAscending)){
                    
                    NSString *message = [NSString stringWithFormat:@"Sorry, seems that car gonna be busy this time(from %@ to %@)", [[ordersData valueForKey:@"startDate"] objectAtIndex:i],[[ordersData valueForKey:@"endDate"] objectAtIndex:i]];

                    ERROR_ALERT(CHECK_RES, message, AW_BT_FAIL);
                    
                    break;
                } else {
                    continue;
                }
            } else {
                
                i = (int)([ordersData count] - 1);
                
                NSComparisonResult startWithEnd = [rentStart compare:[[ordersData valueForKey:@"endDate"] objectAtIndex:i - 1]];
                NSComparisonResult startWithEndLast = [rentStart compare:[[ordersData valueForKey:@"endDate"] objectAtIndex:i]];
                NSComparisonResult startWithStart = [rentStart compare:[[ordersData valueForKey:@"startDate"] objectAtIndex:i]];
                NSComparisonResult endWithStart = [rentEnd compare:[[ordersData valueForKey:@"startDate"] objectAtIndex:i]];
                
                if ((endWithStart == NSOrderedAscending && (startWithStart == NSOrderedAscending) && (startWithEnd == NSOrderedDescending)) || startWithEndLast == NSOrderedDescending){

                    NSString *message = [NSString stringWithFormat:@"Successful, you can use this car from %@ til %@", rentStart, rentEnd];

                    ERROR_ALERT(CHECK_RES, message, AW_BT_SUC);
                    
                    self.getItTitle.userInteractionEnabled = YES;
                    self.getItTitle.tintColor = [UIColor blueColor];
                    
                    break;
                } else { //if ((endWithStart == NSOrderedDescending) || (endWithEnd == NSOrderedAscending)){
                    
                    NSString *message = [NSString stringWithFormat:@"Sorry, seems that car gonna be busy this time(from %@ to %@)", [[ordersData valueForKey:@"startDate"] objectAtIndex:i],[[ordersData valueForKey:@"endDate"] objectAtIndex:i]];
                    
                    ERROR_ALERT(CHECK_RES, message, AW_BT_FAIL);
                    
                    break;
                } //else {
                    //continue;
                //}
            }
        }
    }
}

- (void)createAnEvent
{

    EKEventStore *eventStore = [[EKEventStore alloc] init];
    EKEvent *event = [EKEvent eventWithEventStore:eventStore];
    
    [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        // handle access here
    }];
    
    NSString *year = [[vehicleData valueForKey:@"releaseYear"] substringFromIndex:2];
    NSString *brand = [[vehicleData valueForKey:@"brandName"] valueForKey:@"brandName"];
    NSString *model = [vehicleData valueForKey:@"modelName"];
    NSString *notes = [NSString stringWithFormat:@"You've rent '%@ %@ %@ on this day from Dimitrow &Co", year, brand, model];
    
    NSLog(@"%@", notes);
    
    event.title = @"Car Rent Event";
    event.notes = notes;
    event.startDate = [rentStart dateByAddingTimeInterval:-1800];
    event.endDate = rentEnd;
    event.availability = EKEventAvailabilityFree;
    
    NSTimeInterval alarmOffset = -1*60*60;//1 hour
    EKAlarm *alarm = [EKAlarm alarmWithRelativeOffset:alarmOffset];
    
    [event addAlarm:alarm];
    
    [event setCalendar:[eventStore defaultCalendarForNewEvents]];
    
    NSError *err;
    [eventStore saveEvent:event span:EKSpanThisEvent error:&err];
    if (err == noErr) {
        NSString *carName = [NSString stringWithFormat:@"'%@ %@ %@", year, brand, model];
        NSString *message = [NSString stringWithFormat:@"An event has been added to your calendar in order to remind you about %@ you've just rented", carName];
        NSString *title = @"";
        ERROR_ALERT(title, message, AW_BT_SUC);
    }
    //NSLog(@"Error From iCal : %@", [err description]);
    
}

- (void) viewWillDisappear:(BOOL)animated
{
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
