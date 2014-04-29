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
}

@end

@implementation CarDetailViewController

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    //self.navigationController.navigationBar.topItem.title = @"Description";
    _fullName.text = _car.carName;
    self.title = @"Description  _";
    [self tempQuery];
    [self retrivePictures];
    [self retriveReviews];
    
    
//    _mainPicture.layer.cornerRadius = 10.0;
//    _mainPicture.layer.masksToBounds = YES;
//    _mainPicture.layer.borderWidth = 2.0;
//    _mainPicture.layer.borderColor = COLOR_MAIN_BLUE.CGColor;
    
//    _mainPictureBack.backgroundColor = [UIColor colorWithRed:.4 green:.4 blue:.4 alpha:.4];
//    _mainPictureBack.layer.cornerRadius = 15.0;
//    _mainPictureBack.layer.masksToBounds = YES;
//    _mainPictureBack.layer.borderWidth = 2.0;
//    _mainPictureBack.layer.borderColor = COLOR_MAIN_BLUE.CGColor;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    _car.photoIndex = (NSInteger *)indexPath.row;
    NSLog(@"selected %ld", (long)indexPath.row);
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
    
    [carsQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {         
         _pics = [objects valueForKey:@"photo"];
         [self.carsStrapView reloadData];

     }];

}

- (void)tempQuery
{
//    PFQuery *carsQuery = [PFQuery queryWithClassName:@"Review"];
//    [carsQuery whereKey:@"vehicle" equalTo:[PFObject objectWithoutDataWithClassName:@"Vehicle" objectId:_car.carID]];
//    
//    PFQuery *userQuery = [PFUser query];
//    
//    //[carsQuery whereKey:@"user" matchesKey:@"username" inQuery:userQuery];
//    [carsQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//    
//        _reviews = objects;
//        
//    }];
}

- (void)retriveReviews
{
    PFQuery *carsQuery = [PFQuery queryWithClassName:@"Review"];
    [carsQuery whereKey:@"vehicle" equalTo:[PFObject objectWithoutDataWithClassName:@"Vehicle" objectId:_car.carID]];
    [carsQuery setCachePolicy:kPFCachePolicyCacheThenNetwork];
    
    [carsQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         _reviews = objects;
         
<<<<<<< HEAD
         for (PFUser *client in _reviews) {
             PFQuery *clientsQuery = [PFUser query];
             
             [clientsQuery whereKey:[PFUser user] equalTo: [_reviews valueForKey:@"user"]];
             [clientsQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                 _clients = objects;

                 //[_reviews setValue:[_clients valueForKey:@"username"] forKey:@"user"];
                 //NSLog(@"%@", _reviews);
=======
         for (PFObject *review in objects) {
             PFUser *user = [review valueForKey:@"user"]; //[@"user"];
             PFQuery *clientsQuery = [PFUser query];
             [clientsQuery getObjectInBackgroundWithId:user.objectId block:^(PFObject *object, NSError *error) {
                 [_reviews setValue:object[@"username"] forKey:@"user"];
                 [_reviewsTable reloadData];
>>>>>>> 4da68b35b6504799cc710e6ce80b7e6716021a5c
             }];
             
             
//             [clientsQuery whereKey:@"objectId" equalTo:user.objectId];
//             
//             
//             PFQuery *new = [PFQuery queryWithClassName:@"User"];
//             
//             [clientsQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//                 NSLog(@"%@",objects[0][@"username"]);
////                 _clients = objects;
////
////                 [_reviews setValue:[_clients valueForKey:@"username"] forKey:@"user"];
////                 //NSLog(@"%@", _reviews);
//             }];
             
         }
         

     }];
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *reviewCells = [_reviews valueForKey:@"review"];
    return ([reviewCells count] >= 1) ? [reviewCells count] : 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReviewCell" forIndexPath:indexPath];
    
    UILabel *comment = (UILabel *)[cell viewWithTag:556];
    UILabel *timeStamp = (UILabel *)[cell viewWithTag:557];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MMMM, dd, YYYY, hh:mm a"];
    NSTimeZone *tz = [NSTimeZone localTimeZone];
    [df setTimeZone:tz];
    
    if ([[_reviews valueForKey:@"review"] count] >= 1) {
        timeStamp.text = [df stringFromDate:[[_reviews valueForKey:@"createdAt"] objectAtIndex:indexPath.row]];
        comment.text = [[_reviews valueForKey:@"review"] objectAtIndex:indexPath.row];
        
        NSLog(@"%@",[_reviews valueForKey:@"user"]);

        
    } else {
        timeStamp.text = @"";
        comment.text = @"Sorry, there's no comments at the moment";
    }
    
    _reviewBack = (UIView *)[cell viewWithTag:500];
    _reviewBack.layer.cornerRadius = 10.0f;
    _reviewBack.backgroundColor = [UIColor colorWithRed:0.329 green:0.518 blue:0.600 alpha:0.15];
    
    
    cell.textLabel.font = FONT_LIGHT;
    cell.textLabel.textColor = COLOR_MAIN_BLUE;
    
    //NSString *userName = [[_reviews valueForKey:@"user"] objectAtIndex:indexPath.row];
    
    return cell;

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showPictures"]) {
        
        GalleryRootViewController *destViewController = segue.destinationViewController;
        _car.pictures = _pics;
        destViewController.car = _car;
        NSLog(@"%@", _car.pictures);
        
    }
}


@end
