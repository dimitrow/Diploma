//
//  ReviewViewController.m
//  CarRent
//
//  Created by Eugene Dimitrow on 5/8/14.
//

#import "ReviewViewController.h"
#import "Constants.h"

@interface ReviewViewController ()
{

}
@end

@implementation ReviewViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _reviewText.backgroundColor = [UIColor colorWithRed:0.329 green:0.518 blue:0.600 alpha:0.12];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

- (IBAction)leaveReview:(id)sender
{
    if (_reviewText.text.length != 0){
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        PFObject *review = [PFObject objectWithClassName:@"Review"];
        review[@"review"] = _reviewText.text;
        review[@"user"] = [PFUser currentUser];
        review[@"vehicle"] = [PFObject objectWithoutDataWithClassName:@"Vehicle" objectId:_car.carID];
        
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc postNotificationName:@"review" object:nil];
        
        [review saveInBackground];
    }];
    } else {
        NSString *message = @"Review can not be empty";
        ERROR_ALERT(ERROR, message, AW_BT_FAIL);
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"review" object:nil];
}

- (IBAction)cancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
