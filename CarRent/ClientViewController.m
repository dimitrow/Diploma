//
//  ClientViewController.m
//  CarRent
//
//  Created by Eugene Dimitrow on 3/18/14.
//

#import "ClientViewController.h"
#import "Constants.h"
#import "HistoryViewController.h"

@interface ClientViewController ()
{
    NSArray *_orders;
    NSIndexPath *_indexPath;
}

@end

@implementation ClientViewController

- (void)viewDidAppear:(BOOL)animated
{
    [self retriveProfilePicture];
    
    if ([PFUser currentUser]) {
        _clientNameLabel.textColor =[UIColor whiteColor];
        _clientNameLabel.text = [NSString stringWithFormat:@"%@ %@",
                                 [[PFUser currentUser] valueForKey:@"firstName"],
                                 [[PFUser currentUser] valueForKey:@"lastName"]];
        [self getOrders];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _indexPath = indexPath;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"OrderDetails" sender:self];
    
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
    UIView *costBack = (UIView *)[cell viewWithTag:14];
    costBack.backgroundColor = [UIColor colorWithRed:0.329 green:0.518 blue:0.600 alpha:0.12];
    costBack.layer.borderColor = [UIColor grayColor].CGColor;
    costBack.layer.borderWidth = .5;
    costBack.layer.cornerRadius = costBack.frame.size.height/2;
    
    UILabel *totalAmount = (UILabel *)[cell viewWithTag:15];
    
    if ([[_orders valueForKey:@"objectId"] count] >= 1) {
        
        NSString *startDate = [df stringFromDate:[[_orders valueForKey:@"startDate"] objectAtIndex:indexPath.row]];
        NSString *endDate = [df stringFromDate:[[_orders valueForKey:@"endDate"] objectAtIndex:indexPath.row]];
        NSString *modelName = [[[_orders valueForKey:@"vehicle"] valueForKey:@"modelName"] objectAtIndex:indexPath.row];
        NSString *brandName = [[[[_orders valueForKey:@"vehicle"] valueForKey:@"brandName"] valueForKey:@"brandName" ] objectAtIndex:indexPath.row];
        NSString *amount = [[_orders valueForKey:@"totalAmount"] objectAtIndex:indexPath.row];
        
        totalAmount.text = [NSString stringWithFormat:@"%@", amount];
        dateLabel.text = [NSString stringWithFormat:@"Car reserved\nfrom %@ til %@", startDate, endDate];
        orderNumber.text =  [NSString stringWithFormat:@"%@ %@", brandName, modelName];
    } else {
        dateLabel.text = [NSString stringWithFormat:@"You have no one order yet"];
        orderNumber.text = @"";
        totalAmount.text = @"";
        [costBack isHidden];
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
    [ordersQuery includeKey:@"vehicle.brandName"];
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
    UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
    imgPicker.delegate = self;
    imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imgPicker.allowsEditing = YES;
    [self presentViewController:imgPicker animated:YES completion:nil];

}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [viewController.navigationItem setTitle:@"Choose Photo."];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *fileName = [self genRandStringLength:10];
    
    UIImage *tempImage = (UIImage *)info[UIImagePickerControllerEditedImage];
    _clientPic.image = tempImage;
    
    NSData *imageData = UIImageJPEGRepresentation(_clientPic.image, 0.6f);
    
    NSString *fullName = [NSString stringWithFormat:@"%@.png", fileName];
    PFFile *imageFile = [PFFile fileWithName:fullName data:imageData];
    [[PFUser currentUser] setObject:imageFile forKey:@"profilePicture"];

    
    [[PFUser currentUser] saveInBackground];

    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (NSString *)genRandStringLength:(int)len
{
    static NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random() % [letters length]]];
    }
    return randomString;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"OrderDetails"]) {
        
        HistoryViewController *destViewController = segue.destinationViewController;;
        Order *order = [[Order alloc] init];
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"MMMM, dd, YYYY"];
        NSTimeZone *tz = [NSTimeZone localTimeZone];
        [df setTimeZone:tz];
        
        NSString *startDate = [df stringFromDate:[[_orders valueForKey:@"startDate"] objectAtIndex:_indexPath.row]];
        NSString *endDate = [df stringFromDate:[[_orders valueForKey:@"endDate"] objectAtIndex:_indexPath.row]];
        NSString *modelName = [[[_orders valueForKey:@"vehicle"] valueForKey:@"modelName"] objectAtIndex:_indexPath.row];
        NSString *brandName = [[[[_orders valueForKey:@"vehicle"] valueForKey:@"brandName"] valueForKey:@"brandName" ] objectAtIndex:_indexPath.row];
        NSString *orderDate = [NSString stringWithFormat:@"Current car was reserved\nfrom %@ til %@", startDate, endDate];
        NSString *carName =  [NSString stringWithFormat:@"%@ %@", brandName, modelName];
        NSString *orderID = [[_orders valueForKey:@"objectId"] objectAtIndex:_indexPath.row];
        NSString *carID = [[[_orders valueForKey:@"vehicle"] valueForKey:@"objectId"] objectAtIndex:_indexPath.row];
        
        order.carID = carID;
        order.orderID = orderID;
        order.carFullName = carName;
        order.orderDate = orderDate;
        
        destViewController.order = order;
        destViewController.hidesBottomBarWhenPushed = YES;
        
    }
}

@end
