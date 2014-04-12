//
//  CarDetailViewController.m
//  CarRent
//
//  Created by U'Gene on 4/8/14.
//  Copyright (c) 2014 RockyTurtle. All rights reserved.
//

#import "CarDetailViewController.h"

@interface CarDetailViewController ()

@end

@implementation CarDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.topItem.title = @"";
    _fullName.text = _car.carName;
    if (_car.mainPicture == nil) {
        _mainPicture = nil;
    }else{
        _mainPicture.file  = _car.mainPicture;
        [_mainPicture loadInBackground];
    }

    self.title = _car.carName;
    
    _mainPicture.layer.cornerRadius = 10.0;
    _mainPicture.layer.masksToBounds = YES;
    _mainPicture.layer.borderWidth = 2.0;
    _mainPicture.layer.borderColor = COLOR_MAIN_BLUE.CGColor;
    
    _mainPictureBack.backgroundColor = COLOR_CORRECT_INPUT;
    _mainPictureBack.layer.cornerRadius = 15.0;
    _mainPictureBack.layer.masksToBounds = YES;
    _mainPictureBack.layer.borderWidth = 2.0;
    _mainPictureBack.layer.borderColor = COLOR_MAIN_BLUE.CGColor;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

@end
