//
//  SQLiteOpenPositionModel.h
//  FX Simulator
//
//  Created  on 2014/09/09.
//  
//

#import <Foundation/Foundation.h>
#import "ExecutionOrdersTransactionManager.h"

@class FMDatabase;
@class Currency;
@class CurrencyPair;
@class OrderHistory;
@class OrderType;
@class PositionSize;
@class Lot;
@class Rate;
@class Rates;
@class Market;
@class Money;

@interface OpenPosition : NSObject <ExecutionOrdersTransactionTarget>

+ (instancetype)createFromSlotNumber:(NSUInteger)slotNumber;
+ (instancetype)loadOpenPosition;
- (instancetype)initWithSaveSlotNumber:(NSUInteger)slotNumber orderHistory:(OrderHistory *)orderHistory db:(FMDatabase *)db;

-(NSArray*)selectLatestDataLimit:(NSNumber *)num;
-(NSArray*)selectLimitPositionSize:(PositionSize*)positionSize;
-(void)update;

- (OrderType *)orderTypeOfCurrencyPair:(CurrencyPair *)currencyPAir;
- (Money *)profitAndLossForMarket:(Market *)market currencyPair:(CurrencyPair *)currencyPair InCurrency:(Currency *)currency;
- (PositionSize *)totalPositionSizeOfCurrencyPair:(CurrencyPair *)currencyPair;
- (Lot *)totalLotOfCurrencyPair:(CurrencyPair *)currencyPair;
- (Rate *)averageRateOfCurrencyPair:(CurrencyPair *)currencyPair;

/**
 レコード数が最大かどうか。
*/
-(BOOL)isMax;

/**
 @param db transaction用。
*/
-(BOOL)execute:(NSArray*)orders db:(FMDatabase *)db;
- (void)delete;
@property (nonatomic, readwrite) BOOL inExecutionOrdersTransaction;

@end
