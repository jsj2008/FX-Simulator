//
//  CloseExecutionOrder.m
//  FX Simulator
//
//  Created  on 2014/11/22.
//  
//

#import "CloseExecutionOrder.h"
#import "ExecutionOrderMaterial.h"
#import "OpenPositionRecord.h"

@implementation CloseExecutionOrder {
    OpenPositionRecord *openPositionRecord;
}

@synthesize usersOrderNumber = _usersOrderNumber;

-(id)init
{
    return nil;
}

-(id)initWithCurrencyPair:(CurrencyPair *)currencyPair orderType:(OrderType *)orderType orderRate:(Rate *)orderRate positionSize:(PositionSize *)positionSize orderSpread:(Spread *)spread
{
    return nil;
}

/*-(id)initWithForexHistoryData:(ForexHistoryData *)forexHistoryData orderType:(OrderType *)orderType positionSize:(unsigned long long)positionSize
{
    return nil;
}*/

/*-(id)initWithForexHistoryData:(ForexHistoryData *)forexData orderType:(OrderType *)type positionSize:(unsigned long long)size orderSpread:(Spread*)orderSpread closeOpenPositionNumber:(int)openNumber closeUsersOrderNumber:(int)usersNumber closeOrderRate:(double)rate closeOrderSpread:(Spread *)closeOrderSpread isCloseAll:(BOOL)isCloseAll
{
    if (self = [super initWithForexHistoryData:forexData orderType:type positionSize:size orderSpread:orderSpread]) {
        _closeOpenPositionNumber = openNumber;
        _closeUsersOrderNumber = usersNumber;
        _closeOrderRate = rate;
        _closeOrderSpread = closeOrderSpread;
        _isCloseAllPositionOfRecord = isCloseAll;
    }
    
    return self;
}*/

-(id)initWithExecutionOrderMaterial:(ExecutionOrderMaterial*)material OpenPositionRecord:(OpenPositionRecord*)record
{
    
    if (self = [super initWithCurrencyPair:material.currencyPair orderType:material.orderType orderRate:material.orderRate positionSize:record.positionSize orderSpread:material.orderSpread]) {
        openPositionRecord = record;
        _usersOrderNumber = material.usersOrderNumber;
    }
    
    return self;
    
    //return [self initWithForexHistoryData:material.forexHistoryData orderType:material.orderType positionSize:record.positionSize orderSpread:material.orderSpread closeOpenPositionNumber:record.openPositionNumber closeUsersOrderNumber:record.orderNumber closeOrderRate:record.orderRate closeOrderSpread:record.orderSpread isCloseAll:record.isAllPositionSize];
}

-(int)closeOpenPositionNumber
{
    return openPositionRecord.openPositionNumber;
}

-(int)closeUsersOrderNumber
{
    return openPositionRecord.usersOrderNumber.intValue;
}

-(Rate*)closeOrderRate
{
    return openPositionRecord.orderRate;
}

-(Spread*)closeOrderSpread
{
    return openPositionRecord.orderSpread;
}

-(BOOL)isCloseAllPositionOfRecord
{
    return openPositionRecord.isAllPositionSize;
}

@end
