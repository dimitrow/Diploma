//
//  PageContentViewController.m
//  CarRent
//
//  Created by Eugene Dimitrow on 4/16/14.
//

#import "PageContentViewController.h"

@interface PageContentViewController ()

@end

@implementation PageContentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _backgroundImageView.file = (PFFile *)_imageFile;
    //self.titleLabel.text = self.titleText;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
