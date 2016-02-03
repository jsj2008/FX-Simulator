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
- (void)completion:(void (^)())completion error:(void (^)())error;
- (void)showAlertToController:(UIViewController *)controller;
@end
