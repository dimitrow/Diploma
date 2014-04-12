//
//  UITextField+Customised.h
//  CarRent
//
//  Created by Eugene Dimitrow on 3/24/14.
//  Copyright (c) 2014 RockyTurtle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface UITextField (Customised)

- (id)fieldWithColor:(UIColor *)color;

- (BOOL)validateEmailWithString:(NSString*)email;
- (BOOL)validatePasswordWithString:(NSString*)password;
- (BOOL)validateUserNameWithString:(NSString*)userName;
- (BOOL)validateNameWithString:(NSString*)name;



@end
