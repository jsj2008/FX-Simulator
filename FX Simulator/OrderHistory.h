//
//  OrderHistoryDatabase.h
//  ForexGame
//
//  Created  on 2014/06/23.
//  
//

#import <Foundation/Foundation.h>

@class TradeDbDataSource;
@class UsersOrder;

@interface OrderHistory : NSObject
-(id)initWithDataSource:(TradeDbDataSource*)dataSource;
-(int)saveUsersOrder:(UsersOrder*)order;
@end
