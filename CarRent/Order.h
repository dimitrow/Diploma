//
//  Order.h
//  CarRent
//
//  Created by ghost on 6/4/14.
//  Copyright (c) 2014 RockyTurtle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Order : NSObject

@property (nonatomic, strong) NSString *carFullName;
@property (nonatomic, strong) NSString *orderID;
@property (nonatomic, strong) NSString *orderDate;
@property (nonatomic, strong) NSString *carID;

@end
