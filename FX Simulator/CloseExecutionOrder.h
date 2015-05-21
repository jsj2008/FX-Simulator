//
//  CloseExecutionOrder.h
//  FX Simulator
//
//  Created  on 2014/11/22.
//  
//

#import "ExecutionOrder.h"

@class ExecutionOrderMaterial;
@class OpenPositionRecord;
@class FMResultSet;
@class Rate;
@class Spread;

@interface CloseExecutionOrder : ExecutionOrder
// Close対象のOpenPositionRecordを元にOrderを生成
-(id)initWithExecutionOrderMaterial:(ExecutionOrderMaterial*)material OpenPositionRecord:(OpenPositionRecord*)record;
//-(id)initWithForexHistoryData:(ForexHistoryData *)forexData orderType:(OrderType *)type positionSize:(unsigned long long)size orderSpread:(Spread*)orderSpread closeOpenPositionNumber:(int)openNumber closeUsersOrderNumber:(int)usersNumber closeOrderRate:(double)rate closeOrderSpread:(Spread*)closeOrderSpread isCloseAll:(BOOL)isCloseAll;
//-(id)initWithFMResultSet:(FMResultSet*)rs;
// クローズするオープンポジションのDB上のidカラム
@property (nonatomic, readonly) int closeOpenPositionNumber;
// そのオープンポジションを注文した注文番号(OrderHistory上のidカラム)
@property (nonatomic, readonly) int closeUsersOrderNumber;
// クローズ対象のレート
@property (nonatomic, readonly) Rate *closeOrderRate;
// クローズ対象のスプレッド
@property (nonatomic, readonly) Spread *closeOrderSpread;
// クローズ対象がそのレコード(OpenPositionRecord=NewExecutionOrder)の全てのpositionSizeかどうか
@property (nonatomic, readonly) BOOL isCloseAllPositionOfRecord;
@end
