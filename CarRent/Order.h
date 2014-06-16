//
//  Order.h
//  CarRent
//
//  Created by Eugene Dimitrow on 6/4/14.
//

#import <Foundation/Foundation.h>

@interface Order : NSObject

@property (nonatomic, strong) NSString *carFullName;
@property (nonatomic, strong) NSString *orderID;
@property (nonatomic, strong) NSString *orderDate;
@property (nonatomic, strong) NSString *carID;

@end
