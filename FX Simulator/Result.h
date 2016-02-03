//
//  OrderResult.h
//  FXSimulator
//
//  Created by yuu on 2015/09/05.
//
//

#import <Foundation/Foundation.h>

@import UIKit;

@interface Result : NSObject
- (instancetype)initWithIsSuccess:(BOOL)isSuccess title:(NSString *)title message:(NSString *)message;
- (void)success:(void (^)())success failure:(void (^)())failure;
- (void)showAlertToController:(UIViewController *)controller;
@end
