//
//  Message.h
//  FXSimulator
//
//  Created by yuu on 2016/02/04.
//
//

#import <Foundation/Foundation.h>

@import UIKit;

@interface Message : NSObject
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message;
- (void)showAlertToController:(UIViewController *)controller;
@end
