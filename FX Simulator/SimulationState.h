//
//  SimulationState.h
//  FX Simulator
//
//  Created by yuu on 2015/06/11.
//
//

#import <Foundation/Foundation.h>

@class Account;
@class Market;
@class SimulationStateResult;

/**
 シミュレーションを停止すべきかどうか、などのシュミレーションの状態を管理する。
 AccountやMarketによって、シュミレーションを停止するかどうかを判定する。
 また、シュミレーションの停止の種類によって、異なるアラートを表示する。
*/

@interface SimulationState : NSObject
- (instancetype)initWithAccount:(Account*)account Market:(Market*)market;
- (SimulationStateResult *)isStop;
/**
 資産が0以下なのか、チャートが端まで読み込まれたのかなど、その状態に応じて、異なるアラートを出す。
 シュミレーションがストップしていないときは、アラートは表示されない。
*/
//- (void)showAlert:(UIViewController*)controller;
//- (void)updatedMarket;
//- (void)reset;
@end
