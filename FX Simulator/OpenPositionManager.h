//
//  OpenPositionManager.h
//  FX Simulator
//
//  Created  on 2014/11/25.
//  
//

#import "ExecutionOrdersTransactionManager.h"

@class TradeDbDataSource;
@class CloseExecutionOrder;
@class NewExecutionOrder;
@class FMDatabase;

@interface OpenPositionManager : NSObject <ExecutionOrdersTransactionTarget>
/**
 テーブルが存在しない場合は、作成される。 
*/
-(id)initWithDataSource:(TradeDbDataSource*)dataSource;
-(BOOL)execute:(NSArray*)orders;
@property (nonatomic, readwrite) BOOL inExecutionOrdersTransaction;
@property (nonatomic, readwrite) FMDatabase *tradeDB;
@end
