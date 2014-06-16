//
//  UITextField+Customised.h
//  CarRent
//
//  Created by Eugene Dimitrow on 3/24/14.
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
