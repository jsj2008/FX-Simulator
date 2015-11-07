//
//  Account.m
//  FX Simulator
//
//  Created by yuu on 2015/06/15.
//
//

#import "Account.h"

#import "ExecutionOrder.h"
#import "ExecutionOrderRelationChunk.h"
#import "ForexHistoryData.h"
#import "Lot.h"
#import "Market.h"
#import "Money.h"
#import "Money+ConvertToAccountCurrency.h"
#import "OpenPosition.h"
#import "OpenPositionRelationChunk.h"
#import "OrderResult.h"
#import "PositionSize.h"
#import "PositionType.h"
#import "ProfitAndLossCalculator.h"
#import "Rate.h"
#import "Rates.h"
#import "SaveData.h"
#import "SaveLoader.h"
#import "SimulationManager.h"

@interface Account ()
@property (nonatomic) Rate *averageRate;
@property (nonatomic) Money *balance;
@property (nonatomic) PositionSize *totalPositionSize;
@property (nonatomic) PositionType *positionType;
@end

@implementation Account {
    Currency *_accountCurrency;
    CurrencyPair *_currencyPair;
    Money *_startBalance;
    OpenPositionRelationChunk *_openPositions;
    ExecutionOrderRelationChunk *_executionOrders;
}

-(instancetype)initWithAccountCurrency:(Currency *)currency currencyPair:(CurrencyPair *)currencyPair startBalance:(Money *)balance openPositions:(OpenPositionRelationChunk *)openPositions executionOrders:(ExecutionOrderRelationChunk *)executionOrders
{
    if (self = [super init]) {
        _accountCurrency = currency;
        _currencyPair = currencyPair;
        _startBalance = balance;
        _openPositions = openPositions;
        _executionOrders = executionOrders;
    }
    
    return self;
}

- (void)didOrder:(OrderResult *)result
{
    [result completion:^{
        [self update];
    } error:nil];
}

- (void)update
{
    self.averageRate = nil;
    self.balance = nil;
    self.totalPositionSize = nil;
    self.positionType = nil;
}

- (BOOL)isShortageForMarket:(Market *)market
{
    Money *equity = [self equityForMarket:market];
    
    if (equity.amount <= 0) {
        return YES;
    } else {
        return NO;
    }
}

- (void)displayDataUsingBlock:(void (^)(NSString *equityStringValue, NSString *profitAndLossStringValue, NSString *orderTypeStringValue, NSString *averageRateStringValue, NSString *totalLotStringValue, UIColor *equityStringColor, UIColor *profitAndLossStringColor))block market:(Market *)market positionSizeOfLot:(PositionSize *)positionSize
{
    if (!block || !market) {
        return;
    }
    
    Money *equity = [self equityForMarket:market];
    Money *profitAndLoss = [self profitAndLossForMarket:market];
    
    block(equity.toDisplayString, profitAndLoss.toDisplayString, [self positionType].toDisplayString, [self averageRate].toDisplayString, [[self totalPositionSize] toLotFromPositionSizeOfLot:positionSize].toDisplayString, equity.toDisplayColor, profitAndLoss.toDisplayColor);
}

- (Rate *)averageRate
{
    if (!_averageRate) {
        _averageRate = [_openPositions averageRateOfCurrencyPair:_currencyPair];
    }
    
    return _averageRate;
}

- (Money *)balance
{
    if (!_balance) {
        Money *profitAndLoss = [[_executionOrders profitAndLossOfCurrencyPair:_currencyPair] convertToCurrency:_accountCurrency];
        _balance = [_startBalance addMoney:profitAndLoss];
    }
    
    return _balance;
}

- (Money *)equityForMarket:(Market *)market
{
    Money *profitAndLoss = [self profitAndLossForMarket:market];
    
    return [self.balance addMoney:profitAndLoss];
}

- (PositionType *)positionType
{
    if (!_positionType) {
        _positionType = [_openPositions positionTypeOfCurrencyPair:_currencyPair];
    }
    
    return _positionType;
}

- (Money *)profitAndLossForMarket:(Market *)market
{
    PositionType *positionType = [self positionType];
    
    Rates *valuationRates = [market getCurrentRatesOfCurrencyPair:_currencyPair];
    
    Rate *valuationRate;
    
    if ([positionType isShort]) {
        valuationRate = valuationRates.askRate;
    } else if ([positionType isLong]) {
        valuationRate = valuationRates.bidRate;
    } else {
        return [[Money alloc] initWithAmount:0 currency:_accountCurrency];
    }
    
    PositionSize *totalPositionSize = [self totalPositionSize];
    Rate *averageRate = [self averageRate];
    
    Money *profitAndLoss = [ProfitAndLossCalculator calculateByTargetRate:averageRate valuationRate:valuationRate positionSize:totalPositionSize orderType:positionType];
    
    return [profitAndLoss convertToCurrency:_accountCurrency];
}

- (PositionSize *)totalPositionSize
{
    if (!_totalPositionSize) {
        _totalPositionSize = [_openPositions totalPositionSizeOfCurrencyPair:_currencyPair];
    }
    
    return _totalPositionSize;
}

@end
