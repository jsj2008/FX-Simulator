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
@end
