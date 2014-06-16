//
//  Constants.h
//  CarRent
//
//  Created by Eugene Dimitrow on 3/24/14.
//

#import <Foundation/Foundation.h>

#define COLOR_WRONG_INPUT [UIColor colorWithRed:0.932 green:0.123 blue:0.123 alpha:0.12]
#define COLOR_CORRECT_INPUT [UIColor colorWithRed:0.432 green:0.677 blue:0.123 alpha:0.12]
#define COLOR_BUSY [UIColor colorWithRed:0.932 green:0.123 blue:0.123 alpha:1.0]
#define COLOR_AVAL [UIColor colorWithRed:0.432 green:0.677 blue:0.123 alpha:1.0]

#define COLOR_MAIN_BLUE [UIColor colorWithRed:0.329 green:0.518 blue:0.600 alpha:1.0]
#define COLOR_REVIEW_BACK [UIColor colorWithRed:0.771 green:0.948 blue:0.448 alpha:1.0]
#define COLOR_MAIN_WHITE [UIColor colorWithRed:0.978 green:0.972 blue:0.946 alpha:1.0]

#define FONT_ULTRA_LIGHT [UIFont fontWithName:@"HamburgerHeaven"  size:19.0];
#define FONT_LIGHT [UIFont fontWithName:@"HelveticaNeue-UltraLight"  size:18.0];

#define FONT_TITLE [UIFont fontWithName:@"Deftone Stylus"  size:25.0];

#define ERROR @"Error"
#define CHECK_RES @"Check Result"
#define AW_BT_FAIL @"Retry"
#define AW_BT_SUC @"OK"

#define ERROR_ALERT(title, message, buttonTitle) [[[UIAlertView alloc] initWithTitle:(title) message:(message) delegate:nil cancelButtonTitle:(buttonTitle) otherButtonTitles: nil] show]

@protocol Constants <NSObject>

@end
