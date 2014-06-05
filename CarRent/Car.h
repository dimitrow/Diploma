//
//  Car.h
//  CarRent
//
//  Created by U'Gene on 4/10/14.
//  Copyright (c) 2014 RockyTurtle. All rights reserved.
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
