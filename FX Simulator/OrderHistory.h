//
//  OrderHistoryDatabase.h
//  ForexGame
//
//  Created  on 2014/06/23.
//  
//

#import <Foundation/Foundation.h>

@class FMDatabase;
@class Order;
@class TradeDbDataSource;

@interface OrderHistory : NSObject
+ (instancetype)createFromSlotNumber:(NSUInteger)slotNumber;
+ (instancetype)loadOrderHistory;
- (instancetype)initWithSaveSlotNumber:(NSUInteger)slotNumber db:(FMDatabase *)db;
- (Order *)getOrderFromOrderHistoryId:(NSUInteger)orderHistoryId;
- (int)saveOrder:(Order *)order;
- (void)delete;
@end
