//
//  OrderManagerState.h
//  FX Simulator
//
//  Created by yuu on 2015/06/12.
//
//

#import <Foundation/Foundation.h>

@class UIViewController;
@class UsersOrder;

@interface OrderManagerState : NSObject
-(void)updateState:(UsersOrder*)usersOrder;
/**
 Orderが実行可能かどうか。
*/
-(BOOL)isExecutable;
-(void)showAlert:(UIViewController*)controller;
@end
