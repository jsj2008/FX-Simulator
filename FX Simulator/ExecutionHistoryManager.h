//
//  ExecutionHistoryManager.h
//  FX Simulator
//
//  Created  on 2014/11/25.
//  
//

#import "ExecutionOrdersTransactionManager.h"

@class FMDatabase;
@class TradeDbDataSource;

/**
 ユーザーからのオーダーから生成した実行用のオーダーの配列をExecutionHistoryテーブルに保存するクラス。
*/

@interface ExecutionHistoryManager : NSObject <ExecutionOrdersTransactionTarget>
-(id)initWithDataSource:(TradeDbDataSource*)dataSource;
/**
 ユーザーからのオーダーから生成した実行用のオーダーの配列をExecutionHistoryテーブルに保存するメソッド。トランザクションが有効でなければ実行されない。
*/
-(NSArray*)saveOrders:(NSArray*)orders;
@property (nonatomic, readwrite) BOOL inExecutionOrdersTransaction;
@property (nonatomic, readwrite) FMDatabase *tradeDB;
@end
