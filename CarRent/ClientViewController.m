//
//  ClientViewController.m
//  CarRent
//
//  Created by Eugene Dimitrow on 3/18/14.
//  Copyright (c) 2014 RockyTurtle. All rights reserved.
//

#import "ClientViewController.h"
#import "Constants.h"


@interface ClientViewController ()
{
    NSArray *_orders;
}


@end

@implementation ClientViewController

- (void)viewDidAppear:(BOOL)animated
{

    [self retriveProfilePicture];
    [self getOrders];
    
    if ([PFUser currentUser]) {
        _clientNameLabel.textColor =[UIColor whiteColor];
        _clientNameLabel.text = [NSString stringWithFormat:@"%@ %@",
                                 [[PFUser currentUser] valueForKey:@"firstName"],
                                 [[PFUser currentUser] valueForKey:@"lastName"]];
        if (_clientPic.file == nil) {
            _clientPic.image = [UIImage imageNamed:@"userTempPic.jpg"];
        }

    } else {
        _clientNameLabel.text = [NSString stringWithFormat:@"%@ %@",
                                 [[PFUser currentUser] valueForKey:@"---"],
                                 [[PFUser currentUser] valueForKey:@"---"]];
        [self performSegueWithIdentifier:@"loginSegue" sender:self];

    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [PFUser currentUser];
    
    _titleMain.font = FONT_TITLE;
    _titleMain.text = @"Personal";
    
    _clientPic.layer.cornerRadius = _clientPic.frame.size.height / 2;
    _clientPic.layer.masksToBounds = YES;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSArray *rows = [_orders valueForKey:@"objectId"];
    return  ([rows count] >= 1) ? [rows count] : 1;
}

- (void)retriveProfilePicture
{
    _clientPic.file = [[PFUser currentUser] objectForKey:@"profilePicture"];
    [_clientPic loadInBackground];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MMMM, dd, YYYY"];
    NSTimeZone *tz = [NSTimeZone localTimeZone];
    [df setTimeZone:tz];
    

    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderCell" forIndexPath:indexPath];
    UILabel *orderNumber = (UILabel *)[cell viewWithTag:1985];
    UILabel *dateLabel = (UILabel *)[cell viewWithTag:1984];
    
    if ([[_orders valueForKey:@"objectId"] count] >= 1) {
        
        NSString *startDate = [df stringFromDate:[[_orders valueForKey:@"startDate"] objectAtIndex:indexPath.row]];
        NSString *endDate = [df stringFromDate:[[_orders valueForKey:@"endDate"] objectAtIndex:indexPath.row]];
        NSString *orderNum = [[_orders valueForKey:@"objectId"] objectAtIndex:indexPath.row];

        
        dateLabel.text = [NSString stringWithFormat:@"Car reserved\nfrom %@ til %@", startDate, endDate];
        orderNumber.text =  [NSString stringWithFormat:@"Order #: %@", orderNum];
    } else {
        dateLabel.text = [NSString stringWithFormat:@"You have no one order yet"];
        orderNumber.text = @"";
    }
    

    
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)getOrders
{
    PFQuery *ordersQuery = [PFQuery queryWithClassName:@"Orders"];
    [ordersQuery whereKey:@"user" equalTo:[PFUser currentUser]];
    [ordersQuery includeKey:@"vehicle"];
    [ordersQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        _orders = objects;
        [_ordersTable reloadData];
    }];
}

- (IBAction)logOut:(id)sender
{
    [PFUser logOut];
    [self performSegueWithIdentifier:@"loginSegue" sender:self];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self getOrders];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (IBAction)resetVehicleStaus:(id)sender
{
    
    PFQuery *orderQuery = [PFQuery queryWithClassName:@"Vehicle"];
    [orderQuery whereKey:@"isAvaliable" equalTo:@NO];
    [orderQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        for (PFObject *vehicle in objects) {
            vehicle[@"isAvaliable"] = @YES;
            [vehicle saveInBackground];
        }
        
    }];

}

- (IBAction)getPicture:(id)sender
{
    //Open a UIImagePickerController to select the picture
    UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
    imgPicker.delegate = self;
    imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imgPicker.allowsEditing = YES;
    [self presentViewController:imgPicker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    _clientPic.file = info[UIImagePickerControllerEditedImage];
    [[PFUser currentUser] setObject:_clientPic.file forKey:@"profilePicture"];
    //_clientPic.image = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
