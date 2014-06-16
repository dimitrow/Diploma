//
//  CarsListTableViewController.m
//  CarRent
//
//  Created by Eugene Dimitrow on 3/18/14.
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
    [self performSelector:@selector(retriveData)];
    [_carsTableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = [NSString stringWithFormat:@"Our Cars."];

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
    //[retriveVehicles orderByAscending:@"brandName"];
    [retriveVehicles setCachePolicy:kPFCachePolicyCacheThenNetwork];

    [retriveVehicles findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
    {
        _brands = [objects valueForKey:@"brandName"];
        [_carsTableView reloadData];
        
#warning fix "for" loop, it takes 23 requests to server to update tableview
        
        for (PFObject *brand in objects) {
             PFQuery *carsQuery = [PFQuery queryWithClassName:@"Vehicle"];
            //[carsQuery orderByAscending:@"modelName"];
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
    //UIView *avaliabilitySign = (UIView *)[cell viewWithTag:15];
    
    NSString *modelName = [[_vehicles allKeys] objectAtIndex:indexPath.section];
    NSArray *vehicles = [[_vehicles objectForKey:modelName] valueForKey:@"modelName"];
    
    //BOOL isAvaliable = [[[[_vehicles objectForKey:modelName] valueForKey:@"isAvaliable"] objectAtIndex:indexPath.row] boolValue];    
    //(isAvaliable == YES) ? (avaliabilitySign.backgroundColor = COLOR_AVAL) : (avaliabilitySign.backgroundColor = COLOR_BUSY);
    
    cell.textLabel.font = FONT_ULTRA_LIGHT;
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
    return 25;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(9.0, 0, tableView.frame.size.width, 25.0)];
    header.backgroundColor = [UIColor clearColor];
    
    UILabel *headerTitle = [[UILabel alloc] initWithFrame:header.frame];
    headerTitle.font = FONT_LIGHT;

    headerTitle.text = [[_vehicles allKeys] objectAtIndex:section];
    headerTitle.textColor = [UIColor darkGrayColor];
    
    [header addSubview:headerTitle];
    
    return header;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showCarDetail"]) {

        CarDetailViewController *destViewController = segue.destinationViewController;;
        Car *car = [[Car alloc] init];
        
        NSString *modelName = [[[_vehicles objectForKey:[[_vehicles allKeys] objectAtIndex:_indexPath.section]] valueForKey:@"modelName"] objectAtIndex:_indexPath.row];
        NSString *objectID = [[[_vehicles objectForKey:[[_vehicles allKeys] objectAtIndex:_indexPath.section]] valueForKey:@"objectId"] objectAtIndex:_indexPath.row];
        NSString *brandName = [[_vehicles allKeys] objectAtIndex:_indexPath.section];
        NSString *year = [[[_vehicles objectForKey:[[_vehicles allKeys] objectAtIndex:_indexPath.section]] valueForKey:@"releaseYear"] objectAtIndex:_indexPath.row];
        NSString *mpg = [[[_vehicles objectForKey:[[_vehicles allKeys] objectAtIndex:_indexPath.section]] valueForKey:@"mpg"] objectAtIndex:_indexPath.row];
        NSString *mileage = [[[_vehicles objectForKey:[[_vehicles allKeys] objectAtIndex:_indexPath.section]] valueForKey:@"mileage"] objectAtIndex:_indexPath.row];
        BOOL isAvaliable = [[[[_vehicles objectForKey:[[_vehicles allKeys] objectAtIndex:_indexPath.section]] valueForKey:@"isAvaliable"] objectAtIndex:_indexPath.row] boolValue];

        car.carName = [NSString stringWithFormat:@"%@ \"%@\"", brandName, modelName ];
        car.mpg = mpg;
        car.mileage = mileage;
        car.carID = objectID;
        car.releaseYear = year;
        car.isAvaliable = isAvaliable;
        
        destViewController.car = car;
        destViewController.hidesBottomBarWhenPushed = YES;
        
    }
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

@end





