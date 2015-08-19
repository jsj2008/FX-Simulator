//
//  ExecutionHistory.h
//  FX Simulator
//
//  Created  on 2014/10/23.
//  
//

#import <Foundation/Foundation.h>
#import "ExecutionOrdersTransactionManager.h"

@class FMDatabase;
@class ExecutionHistoryRecord;

@interface ExecutionHistory : NSObject <ExecutionOrdersTransactionTarget>
+ (instancetype)createFromSlotNumber:(NSUInteger)slotNumber;
- (instancetype)initWithSaveSlotNumber:(NSUInteger)slotNumber db:(FMDatabase *)db;
// クローズ(Close)なオーダーの約定履歴はSelectしない???
-(ExecutionHistoryRecord*)selectRecordFromOrderID:(NSNumber*)orderID;
-(NSArray*)selectLatestDataLimit:(NSNumber *)num;
-(NSArray*)all;
- (void)delete;
/**
 ユーザーからのオーダーから生成した実行用のオーダーの配列をExecutionHistoryテーブルに保存するメソッド。トランザクションが有効でなければ実行されない。
 orderID(ExecutionHistoryTableのRowid)がセットされたExecutionOrdersを返す
 @param db transaction用。
*/
-(NSArray*)saveOrders:(NSArray*)orders db:(FMDatabase *)db;
@property (nonatomic, readwrite) BOOL inExecutionOrdersTransaction;
@end
