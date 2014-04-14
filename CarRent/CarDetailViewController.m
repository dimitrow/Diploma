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
    NSArray *_pics;
}

@end

@implementation CarDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.topItem.title = @"";
    _fullName.text = _car.carName;
    self.title = _car.carName;
    [self retrivePictures];
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
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
         NSLog(@"%@",_pics);
         [self.carsStrapView reloadData];

     }];

}

@end
