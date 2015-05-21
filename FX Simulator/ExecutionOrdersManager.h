//
//  ExecutionOrdersManager.h
//  FX Simulator
//
//  Created  on 2014/11/24.
//  
//

#import <Foundation/Foundation.h>

@class OpenPositionManager;
@class ExecutionHistoryManager;

/**
 実行オーダーを実際に実行するクラス。
*/

@interface ExecutionOrdersManager : NSObject
-(id)initWithOpenPositionManager:(OpenPositionManager*)openPositionManager executionHistoryManager:(ExecutionHistoryManager*)executionHistoryManager;
-(BOOL)executeOrders:(NSArray*)orders;
@end
