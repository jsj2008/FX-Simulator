//
//  SQLiteOpenPositionModel.h
//  FX Simulator
//
//  Created  on 2014/09/09.
//  
//

#import <Foundation/Foundation.h>


@class FMDatabase;
@class Currency;
@class CurrencyPair;
@class OrderType;
@class PositionSize;
@class Lot;
@class Rate;
@class Money;

@interface OpenPosition : NSObject
+ (instancetype)createFromSlotNumber:(NSUInteger)slotNumber AccountCurrency:(Currency*)accountCurrency;
- (instancetype)initWithSaveSlotNumber:(NSUInteger)slotNumber accountCurrency:(Currency*)accountCurrency db:(FMDatabase *)db;
-(NSArray*)selectLatestDataLimit:(NSNumber *)num;
-(NSArray*)selectLimitPositionSize:(PositionSize*)positionSize;
-(NSArray*)selectAll;
-(void)update;
-(Money*)profitAndLossForRate:(Rate*)rate;
-(Money*)marketValueForRate:(Rate*)rate;
/**
 レコード数が最大かどうか。
*/
-(BOOL)isMax;
- (void)delete;
@property (nonatomic, readonly) Currency *currency;
@property (nonatomic, readonly) OrderType *orderType;
@property (nonatomic, readonly) PositionSize *totalPositionSize;
@property (nonatomic, readonly) Lot *totalLot;
@property (nonatomic, readonly) Rate *averageRate;
//@property (nonatomic, readonly) Money *totalPositionMarketValue;
@end
