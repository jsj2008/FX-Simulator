//
//  ExecutionHistoryRecord.h
//  FX Simulator
//
//  Created  on 2014/12/11.
//  
//

#import <Foundation/Foundation.h>

@class FMResultSet;
@class CurrencyPair;
@class Rate;
@class Spread;
@class PositionType;
@class PositionSize;
@class Money;

@interface ExecutionHistoryRecord : NSObject
-(id)initWithFMResultSet:(FMResultSet*)rs;
// SQLite Rowid
@property (nonatomic, readonly) NSNumber *orderID;
@property (nonatomic, readonly) CurrencyPair *currencyPair;
@property (nonatomic, readonly) NSNumber *usersOrderNumber;
//@property (nonatomic, readonly) NSNumber *ratesId;
@property (nonatomic, readonly) Rate *orderRate;
@property (nonatomic, readonly) Spread *orderSpread;
@property (nonatomic, readonly) PositionType *orderType;
@property (nonatomic) PositionSize *positionSize;
@property (nonatomic) BOOL isClose;
/** 
 close”される”ポジションのUsersOrderNumber
*/
@property (nonatomic, readonly) NSNumber *closeUsersOrderNumber;
@property (nonatomic, readonly) Rate *closeOrderRate;
@property (nonatomic, readonly) Spread *closeOrderSpread;
@property (nonatomic, readonly) Money *profitAndLoss;
//users_order_number INTEGER NOT NULL, currency_data_id INTEGER NOT NULL, order_rate REAL NOT NULL, order_spread REAL NOT NULL, trade_type TXT NOT NULL, position_size INTEGER NOT NULL, is_close BOOL NOT NULL, close_order_number INTEGER, close_order_rate REAL, close_order_spread REAL
@end
