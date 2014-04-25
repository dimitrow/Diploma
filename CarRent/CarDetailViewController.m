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
    [self retrivePictures];
    [self retriveReviews];
    
    
    UIFont *mainTitleFont = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:35];
    UIFont *authorTitleFont = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:10];

    
    
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

- (void)retriveReviews
{
    PFQuery *carsQuery = [PFQuery queryWithClassName:@"Review"];
    [carsQuery whereKey:@"vehicle" equalTo:[PFObject objectWithoutDataWithClassName:@"Vehicle" objectId:_car.carID]];
    [carsQuery setCachePolicy:kPFCachePolicyCacheThenNetwork];
    
    [carsQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         _reviews = objects; //[objects valueForKey:@"review"];
         
         for (PFObject *user in objects) {
             PFQuery *userQuery = [PFQuery queryWithClassName:@"User"];
             [userQuery whereKey:@"user" equalTo:user];
             [userQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                 NSLog(@"!!!!!%@", objects);
             }];
             
         }
         
         [_reviews objectForKey:[PFObject objectWithoutDataWithClassName:@"User" objectId:[_reviews valueForKey:@"user"]]];
         [_reviews ]
         
         // po [[_reviews valueForKey:@"user"] objectAtIndex:1]
         // po [[[objects objectAtIndex:0] allKeys]
        [_reviewsTable reloadData];
     }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ([_reviews count] == 0) ? 1 : [_reviews count];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReviewCell" forIndexPath:indexPath];
    
    _reviewBack = (UIView *)[cell viewWithTag:500];
    _reviewBack.layer.cornerRadius = 10.0f;
    _reviewBack.backgroundColor = [UIColor colorWithRed:0.329 green:0.518 blue:0.600 alpha:0.15];
    
//    NSString *userName = [[[_reviews objectForKey:[[_vehicles allKeys] objectAtIndex:_indexPath.section]] valueForKey:@"modelName"] objectAtIndex:_indexPath.row];
    
    UILabel *comment = (UILabel *)[cell viewWithTag:556];
    
    //PFObject *nickName = [[_reviews valueForKey:@"user"]objectAtIndex:indexPath.row];
    //NSString *nickName = [[_reviews valueForKey:@"user"]objectAtIndex:indexPath.row];
    
    comment.text = ([_reviews count] == 0) ?  @"Sorry, there's no comments at the moment" : @"Tssssssss"; //[_reviews objectAtIndex:indexPath.row];
    
    //NSLog(@"!!!!! %@",[_reviews objectAtIndex:indexPath.row]);
    
    cell.textLabel.font = FONT_LIGHT;
    cell.textLabel.textColor = COLOR_MAIN_BLUE;
    
    //thumbImage.file =  [_pics objectAtIndex:indexPath.row];
    
    //cell.textLabel.text = [[_reviews valueForKey:@"review" ] objectAtIndex:indexPath.row];
//    NSString * modelName = [[_vehicles allKeys] objectAtIndex:indexPath.section];
//    NSArray * vehicles = [[_vehicles objectForKey:modelName] valueForKey:@"modelName"];
//    
//    cell.textLabel.font = FONT_LIGHT;
//    cell.textLabel.textColor = COLOR_MAIN_BLUE;
//    cell.textLabel.text = [vehicles objectAtIndex:indexPath.row];
    
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
