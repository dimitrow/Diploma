//
//  CarDetailViewController.m
//  CarRent
//
//  Created by U'Gene on 4/8/14.
//  Copyright (c) 2014 RockyTurtle. All rights reserved.
//

#import "CarDetailViewController.h"

@interface CarDetailViewController ()
{
    NSIndexPath *_indexPath;
    UIRefreshControl *_refresh;
}

@end

@implementation CarDetailViewController

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    _fullName.text = _car.carName;
    _releaseYear.text = _car.releaseYear;
    _mpg.text = _car.mpg;
        
    self.title = @"Car Details.";
    [self retrivePictures];
    [self.tabBarController.tabBar isHidden];
    [self performSelector:@selector(retriveReviews)];
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(retriveReviews) name:@"review" object:nil];
    [nc addObserver:self selector:@selector(changeAvaliability) name:@"busy" object:nil];
    
    _refresh = [[UIRefreshControl alloc] init];
    [_refresh addTarget:self
                 action:@selector(retriveReviews)
       forControlEvents:UIControlEventValueChanged];
    
    [_reviewsTable addSubview:_refresh];
    
}

- (void)changeAvaliability
{
    
    _car.isAvaliable = NO;
    (_avaliability.backgroundColor = COLOR_BUSY);
    (_orderButton.hidden = YES);
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    _car.photoIndex = (NSInteger *)indexPath.row;
    [self performSegueWithIdentifier:@"showPictures" sender:self];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_pics count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *myCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MyCell"
                                                                             forIndexPath:indexPath];
    _indexPath = indexPath;
    PFImageView *thumbImage = (PFImageView *)[myCell viewWithTag:131];
    thumbImage.file =  [_pics objectAtIndex:indexPath.row];
    [thumbImage loadInBackground];
    
    return myCell;
}

- (void)retrivePictures
{
    
    PFQuery *carsQuery = [PFQuery queryWithClassName:@"Pictures"];
    [carsQuery whereKey:@"vehicle" equalTo:[PFObject objectWithoutDataWithClassName:@"Vehicle" objectId:_car.carID]];
    [carsQuery setCachePolicy:kPFCachePolicyCacheThenNetwork];
    [carsQuery includeKey:@"vehicle"];
    [carsQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {         
         _pics = [objects valueForKey:@"photo"];
         
         BOOL avaliability = [[[[objects valueForKey:@"vehicle"] valueForKey:@"isAvaliable"] firstObject] boolValue];
         
         if (avaliability == NO) {
             (_avaliability.backgroundColor = COLOR_BUSY);
             (_orderButton.hidden = YES);
         } else {
             (_avaliability.backgroundColor = COLOR_AVAL);
             (_orderButton.hidden = NO);
         }
                  
         [self.carsStrapView reloadData];

     }];

}

- (void)retriveReviews
{
    PFQuery *carsQuery = [PFQuery queryWithClassName:@"Review"];
    [carsQuery orderByDescending:@"createdAt"];
    [carsQuery whereKey:@"vehicle" equalTo:[PFObject objectWithoutDataWithClassName:@"Vehicle" objectId:_car.carID]];
    [carsQuery includeKey:@"user"];
    [carsQuery includeKey:@"vehicle"];
    [carsQuery setCachePolicy:kPFCachePolicyCacheThenNetwork];
    
    [carsQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         _reviews = objects;
         
         
         [_reviewsTable reloadData];
     }];
    [self performSelector:@selector(stopRefresh) withObject:nil afterDelay:0.5];

}

- (IBAction)writeReview:(id)sender
{
    [self performSegueWithIdentifier:@"writeReview" sender:self];
}

- (IBAction)makeOrder:(id)sender
{
    [self performSegueWithIdentifier:@"makeOrder" sender:self];
}

- (void)stopRefresh
{
    [_refresh endRefreshing];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *reviewCells = [_reviews valueForKey:@"review"];
    return ([reviewCells count] >= 1) ? [reviewCells count] : 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReviewCell" forIndexPath:indexPath];
    
    UILabel *reviewItSelf = (UILabel *)[cell viewWithTag:556];
    UILabel *timeStamp = (UILabel *)[cell viewWithTag:557];
    UILabel *userStamp = (UILabel *)[cell viewWithTag:558];
    PFImageView *userThumb = (PFImageView *)[cell viewWithTag:222];
    
    userThumb.layer.cornerRadius = userThumb.frame.size.height / 2;
    userThumb.layer.masksToBounds = YES;
    
    reviewItSelf.textAlignment = NSTextAlignmentLeft;
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MMMM, dd, YYYY, hh:mm a"];
    NSTimeZone *tz = [NSTimeZone localTimeZone];
    [df setTimeZone:tz];
    
    if ([[_reviews valueForKey:@"review"] count] >= 1) {
        timeStamp.text = [df stringFromDate:[[_reviews valueForKey:@"createdAt"] objectAtIndex:indexPath.row]];
        reviewItSelf.text = [[_reviews valueForKey:@"review"] objectAtIndex:indexPath.row];
        
        NSString *firstName = [[[_reviews valueForKey:@"user"] valueForKey:@"firstName"] objectAtIndex:indexPath.row];
        NSString *lastName = [[[_reviews valueForKey:@"user"] valueForKey:@"lastName"] objectAtIndex:indexPath.row];
        //userThumb.file = [[[_reviews valueForKey:@"user"] valueForKey:@"profilePicture"] objectAtIndex:indexPath.row];
        userStamp.text = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
        
        
        if ([[[_reviews valueForKey:@"user"] valueForKey:@"profilePicture"] objectAtIndex:indexPath.row]) {
            NSLog(@"Empty");
        } else {
            NSLog(@"I'm here");
        }
        
//        if (userThumb.file == nil) {
//            userThumb.image = [UIImage imageNamed:@"userTempPic.jpg"];
//        } else {
//            userThumb.file = [[[_reviews valueForKey:@"user"] valueForKey:@"profilePicture"] objectAtIndex:indexPath.row];
//        }
        
    } else {
        timeStamp.text = @"";
        reviewItSelf.text = @"Sorry, there's no comments at the moment";
        reviewItSelf.textAlignment = NSTextAlignmentCenter;
        userStamp.text = @"";

    }
    
    _reviewBack = (UIView *)[cell viewWithTag:500];
    _reviewBack.backgroundColor = [UIColor colorWithRed:0.329 green:0.518 blue:0.600 alpha:0.12];
    
    cell.textLabel.font = FONT_LIGHT;
    cell.textLabel.textColor = COLOR_MAIN_BLUE;
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showPictures"]) {
        
        GalleryRootViewController *destViewController = segue.destinationViewController;
        _car.pictures = _pics;
        destViewController.car = _car;
        
    } else if([segue.identifier isEqualToString:@"writeReview"]) {
        ReviewViewController *destViewController = segue.destinationViewController;
        destViewController.car = _car;

    }  else if([segue.identifier isEqualToString:@"makeOrder"]) {
        ReviewViewController *destViewController = segue.destinationViewController;
        destViewController.car = _car;
    }
}


@end
