//
//  ExecutionHistory.h
//  FX Simulator
//
//  Created  on 2014/10/23.
//  
//

#import <Foundation/Foundation.h>

@class TradeDbDataSource;
@class ExecutionHistoryRecord;

@interface ExecutionHistory : NSObject
-(id)initWithDataSource:(TradeDbDataSource*)dataSource;
// クローズ(Close)なオーダーの約定履歴はSelectしない???
-(ExecutionHistoryRecord*)selectRecordFromOrderID:(NSNumber*)orderID;
-(NSArray*)selectLatestDataLimit:(NSNumber *)num;
//-(NSArray*)selectLimit:(NSNumber*)num;
//-(BOOL)saveExecutionOrders:(NSArray*)orders;
-(NSArray*)all;
@end
