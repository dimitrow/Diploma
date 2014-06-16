//
//  GalleryRootViewController.h
//  CarRent
//
//  Created by Eugene Dimitrow on 4/15/14.
//

#import <UIKit/UIKit.h>
#import "PageContentViewController.h"
#import "Car.h"
#import "CarDetailViewController.h"


@interface GalleryRootViewController : UIViewController <UIPageViewControllerDataSource>
- (IBAction)releaseGallery:(id)sender;

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *pageTitles;
@property (strong, nonatomic) NSArray *pageImages;

@property (nonatomic, strong) Car *car;

@end



