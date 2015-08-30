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
@class ExecutionOrder;
@class OrderHistory;

@interface ExecutionHistory : NSObject <ExecutionOrdersTransactionTarget>

+ (instancetype)createFromSlotNumber:(NSUInteger)slotNumber;
+ (instancetype)loadExecutionHistory;
- (instancetype)initWithSaveSlotNumber:(NSUInteger)slotNumber orderHistory:(OrderHistory *)orderHistory db:(FMDatabase *)db;
// クローズ(Close)なオーダーの約定履歴はSelectしない???
//- (ExecutionOrder *)selectRecordFromOrderID:(NSUInteger)orderID;
- (ExecutionOrder *)orderAtExecutionHistoryId:(NSUInteger)recordId;
- (NSArray *)selectLatestDataLimit:(NSNumber *)num;
- (NSArray *)all;
- (void)delete;

/**
 ユーザーからのオーダーから生成した実行用のオーダーの配列をExecutionHistoryテーブルに保存するメソッド。トランザクションが有効でなければ実行されない。
 orderID(ExecutionHistoryTableのRowid)がセットされたExecutionOrdersを返す
 @param db transaction用。
*/
-(NSArray*)saveOrders:(NSArray*)orders db:(FMDatabase *)db;
@property (nonatomic, readwrite) BOOL inExecutionOrdersTransaction;
@end
