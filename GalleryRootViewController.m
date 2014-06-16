//
//  GalleryRootViewController.m
//  CarRent
//
//  Created by Eugene Dimitrow on 4/15/14.
//

#import "GalleryRootViewController.h"

@interface GalleryRootViewController ()

@end

@implementation GalleryRootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _pageImages = _car.pictures;
    
    
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;
    
    PageContentViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    self.pageViewController.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + 44, self.view.frame.size.width,  self.view.frame.size.height - 40);
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
}

- (IBAction)releaseGallery:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

- (PageContentViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([_pageImages count] == 0) || (index >= [_pageImages count])) {
        return nil;
    }
    
    PageContentViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageContentViewController"];

    pageContentViewController.pageIndex = index;
    
    PFImageView *preview = [[PFImageView alloc] init];
    preview.file = [_pageImages objectAtIndex:index];
    [preview loadInBackground];
    
    NSLog(@"main pic:%@", preview.file);
    
    pageContentViewController.imageFile = [_pageImages objectAtIndex:index];
    
    
    
    return pageContentViewController;
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((PageContentViewController*) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((PageContentViewController*) viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [_pageImages count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [_pageImages count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

-(BOOL)shouldAutorotate
{
    return YES;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

@end