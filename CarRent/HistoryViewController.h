//
//  HistoryViewController.h
//  CarRent
//
//  Created by Eugene Dimitrow on 6/4/14.
//

#import <UIKit/UIKit.h>
#import "Order.h"
#import <Parse/Parse.h>

@interface HistoryViewController : UIViewController

@property (nonatomic, strong) Order *order;
@property (weak, nonatomic) IBOutlet UILabel *carName;
@property (weak, nonatomic) IBOutlet UILabel *orderDate;
@property (weak, nonatomic) IBOutlet UILabel *orderNumber;
@property (strong, nonatomic) IBOutlet PFImageView *carPicture;

@end
