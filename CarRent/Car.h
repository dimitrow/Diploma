//
//  Car.h
//  CarRent
//
//  Created by Eugene Dimitrow on 4/10/14.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>


@interface Car : NSObject

@property (nonatomic, strong) NSString *carName;
@property (nonatomic, strong) NSString *releaseYear;
@property (nonatomic, strong) NSString *mpg;
@property (nonatomic, strong) NSString *mileage;
@property (nonatomic, strong) NSString *carID;
@property (nonatomic, assign) BOOL isAvaliable;
@property (nonatomic, strong) NSArray *pictures;
@property (nonatomic, assign) NSInteger *photoIndex;

@end
