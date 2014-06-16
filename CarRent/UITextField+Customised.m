//
//  UITextField+Customised.m
//  CarRent
//
//  Created by Eugene Dimitrow on 3/24/14.
//

#import "UITextField+Customised.h"

@implementation UITextField (Customised)

- (id)fieldWithColor:(UIColor *)color
{
    self.layer.borderWidth = 0.5f;
    self.layer.cornerRadius = 4.0f;
    self.layer.borderColor = color.CGColor;
    self.backgroundColor = color;
    return self;
}

- (BOOL)validateEmailWithString:(NSString*)email
{
    NSString *emailSymbols = @"[A-Z0-9a-z.]+@[A-Za-z0-9.]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailSymbols];
    return [emailTest evaluateWithObject:email];
}

- (BOOL)validatePasswordWithString:(NSString*)password
{
    NSString *passwordSymbols = @"[A-Z0-9a-z!@#$%^&*~?]{8,12}";
    NSPredicate *passTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passwordSymbols];
    return [passTest evaluateWithObject:password];
}

- (BOOL)validateUserNameWithString:(NSString*)userName
{
    NSString *userNameSymbols = @"[A-Z0-9a-z']{4,16}";
    NSPredicate *userNameTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", userNameSymbols];
    return [userNameTest evaluateWithObject:userName];
}

- (BOOL)validateNameWithString:(NSString*)name
{
    NSString *nameSymbols = @"[A-Za-z']{2,25}";
    NSPredicate *nameTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", nameSymbols];
    return [nameTest evaluateWithObject:name];
}

@end
