//
//  OrderHistoryDatabase.h
//  ForexGame
//
//  Created  on 2014/06/23.
//  
//

#import <Foundation/Foundation.h>

@class FMDatabase;
@class TradeDbDataSource;
@class UsersOrder;

@interface OrderHistory : NSObject
+ (instancetype)createFromSlotNumber:(NSUInteger)slotNumber;
+ (instancetype)loadOrderHistory;
- (instancetype)initWithSaveSlotNumber:(NSUInteger)slotNumber db:(FMDatabase *)db;
- (int)saveUsersOrder:(UsersOrder*)order;
- (void)delete;
@end
