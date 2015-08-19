//
//  ExecutionOrdersManager.h
//  FX Simulator
//
//  Created  on 2014/11/24.
//  
//

#import <Foundation/Foundation.h>

@class OpenPosition;
@class ExecutionHistory;

/**
 実行オーダーを実際に実行するクラス。
*/

@interface ExecutionOrdersManager : NSObject
- (instancetype)initWithOpenPosition:(OpenPosition *)openPosition executionHistory:(ExecutionHistory *)executionHistory;
- (BOOL)executeOrders:(NSArray*)orders;
@end
