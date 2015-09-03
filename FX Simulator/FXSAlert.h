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
@property (nonatomic, weak) UIViewController *controller;
+ (void)showAlertTitle:(NSString *)title message:(NSString *)message controller:(UIViewController *)controller;
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message;
- (void)show;
@end
