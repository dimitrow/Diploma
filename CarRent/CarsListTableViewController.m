//
//  CarsListTableViewController.m
//  CarRent
//
//  Created by Eugene Dimitrow on 3/18/14.
//  Copyright (c) 2014 RockyTurtle. All rights reserved.
//

#import "CarsListTableViewController.h"
#import "CarDetailViewController.h"
#import "Car.h"


@interface CarsListTableViewController ()
{
    NSString *_headerTitle;
    NSIndexPath *_indexPath;
}

@end

@implementation CarsListTableViewController

- (void)viewWillAppear:(BOOL)animated
{
    //[self performSelector:@selector(retriveData)];
        
    [_carsTableView reloadData];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, [UIFont fontWithName:@"HelveticaNeue-CondensedBold"  size:25.0], NSFontAttributeName, nil]];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    loginVC.delegate = self;
    
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    [refresh addTarget:self action:@selector(retriveData)  forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;

}

- (void)stopRefresh
{
    [self.refreshControl endRefreshing];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)retriveData
{
    _vehicles = [NSMutableDictionary dictionary];
    PFQuery *retriveVehicles = [PFQuery queryWithClassName:@"Brands"];
    [retriveVehicles orderByAscending:@"brandName"];
    [retriveVehicles setCachePolicy:kPFCachePolicyCacheThenNetwork];

    [retriveVehicles findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
    {
        _brands = [objects valueForKey:@"brandName"];
        [_carsTableView reloadData];
        
        for (PFObject *brand in objects) {
             PFQuery *carsQuery = [PFQuery queryWithClassName:@"Vehicle"];
            [carsQuery orderByAscending:@"modelName"];
            [carsQuery whereKey:@"brandName" equalTo:brand];
            [carsQuery setCachePolicy:kPFCachePolicyCacheThenNetwork];

            [carsQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
            {
                [_vehicles setValue:objects forKey:[brand valueForKey:@"brandName"]];
                [_carsTableView reloadData];
             }];
        }
    }];
    [self performSelector:@selector(stopRefresh) withObject:nil afterDelay:0.5];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger sections = [[_vehicles allKeys] count];
    return sections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *rows = [[_vehicles allValues] objectAtIndex:section];

    return [rows count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    NSString * modelName = [[_vehicles allKeys] objectAtIndex:indexPath.section];
    NSArray * vehicles = [[_vehicles objectForKey:modelName] valueForKey:@"modelName"];

    cell.textLabel.font = FONT_LIGHT;
    cell.textLabel.textColor = COLOR_MAIN_BLUE;
    cell.textLabel.text = [vehicles objectAtIndex:indexPath.row];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _indexPath = indexPath;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"showCarDetail" sender:self];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(9.0, 0, tableView.frame.size.width, 50.0)];
    header.backgroundColor = [UIColor clearColor];
    
    UILabel *headerTitle = [[UILabel alloc] initWithFrame:header.frame];
    headerTitle.font = FONT_ULTRA_LIGHT;
    
    headerTitle.text = [[_vehicles allKeys]objectAtIndex:section];
    headerTitle.textColor = [UIColor blackColor];
    
    [header addSubview:headerTitle];
    
    return header;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showCarDetail"]) {

        CarDetailViewController *destViewController = segue.destinationViewController;;
        
        NSString *modelName = [[[_vehicles objectForKey:[[_vehicles allKeys] objectAtIndex:_indexPath.section]] valueForKey:@"modelName"] objectAtIndex:_indexPath.row];
        NSString *brandName = [[_vehicles allKeys] objectAtIndex:_indexPath.section];
        PFFile *modelImage = [[[_vehicles objectForKey:[[_vehicles allKeys] objectAtIndex:_indexPath.section]] valueForKey:@"imageMain"] objectAtIndex:_indexPath.row];

        Car *car = [[Car alloc] init];
        
        car.carName = [NSString stringWithFormat:@"%@ \"%@\"", brandName, modelName ];
        car.mainPicture = modelImage;


                
        destViewController.car = car;
        
    }
}

- (void)retriveDatas
{
    NSLog(@"!!! I'm HERE");
}

@end





