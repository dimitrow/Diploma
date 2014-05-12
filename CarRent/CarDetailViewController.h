//
//  CarDetailViewController.h
//  CarRent
//
//  Created by U'Gene on 4/8/14.
//  Copyright (c) 2014 RockyTurtle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Car.h"
#import "Constants.h"
#import "GalleryRootViewController.h"
#import "ReviewViewController.h"

@interface CarDetailViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDataSource, UITableViewDelegate>
{
    NSArray *_pics;
    NSArray *_reviews;
    NSDictionary *_clients;
}

- (void)retriveReviews;

- (IBAction)addComment:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *fullName;
@property (strong, nonatomic) IBOutlet UILabel *releaseYear;
@property (strong, nonatomic) IBOutlet UILabel *mpg;
@property (strong, nonatomic) IBOutlet UIView *avaliability;

@property (weak, nonatomic) IBOutlet PFImageView *collectionCellImage;
@property (strong, nonatomic) IBOutlet UICollectionView *carsStrapView;
@property (strong, nonatomic) IBOutlet UIView *reviewBack;
@property (strong, nonatomic) IBOutlet UITableViewCell *messagesCell;

@property (nonatomic, strong) Car *car;
@property (strong, nonatomic) IBOutlet UITableView *reviewsTable;

@end
