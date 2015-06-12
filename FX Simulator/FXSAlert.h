//
//  FXSAlert.h
//  FX Simulator
//
//  Created by yuu on 2015/06/12.
//
//

#import <Foundation/Foundation.h>

@class UIViewController;

@interface FXSAlert : NSObject
+(void)showAlert:(UIViewController*)controller title:(NSString*)title message:(NSString*)message;
@end
