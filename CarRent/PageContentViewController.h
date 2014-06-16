//
//  PageContentViewController.h
//  CarRent
//
//  Created by Eugene Dimitrow on 4/16/14.
//

#import <UIKit/UIKit.h>
#import "Car.h"

@interface PageContentViewController : UIViewController

@property (weak, nonatomic) IBOutlet PFImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property NSUInteger pageIndex;
@property NSString *titleText;
@property NSString *imageFile;

@end
