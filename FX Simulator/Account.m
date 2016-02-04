//
//  Account.m
//  FX Simulator
//
//  Created by yuu on 2015/06/15.
//
//

#import "Account.h"

#import "CurrencyPair.h"
#import "ExecutionOrder.h"
#import "ExecutionOrderRelationChunk.h"
#import "ForexHistoryData.h"
#import "FXSComparisonResult.h"
#import "Leverage.h"
#import "Lot.h"
#import "Market.h"
#import "Money.h"
#import "Money+ConvertToAccountCurrency.h"
#import "OpenPosition.h"
#import "OpenPositionRelationChunk.h"
#import "Order.h"
#import "Result.h"
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
@property (nonatomic, readonly) Money *convertedRealizedProfitAndLoss;
@end

@implementation Account {
    Currency *_accountCurrency;
    CurrencyPair *_currencyPair;
    Leverage *_leverage;
    Market *_market;
    Money *_startBalance;
    Money *_realizedProfitAndLoss;
    ExecutionOrder *_currentExecutedCloseOrder;
    OpenPositionRelationChunk *_openPositions;
    ExecutionOrderRelationChunk *_executionOrders;
}

-(instancetype)initWithAccountCurrency:(Currency *)currency currencyPair:(CurrencyPair *)currencyPair startBalance:(Money *)balance leverage:(Leverage *)leverage openPositions:(OpenPositionRelationChunk *)openPositions executionOrders:(ExecutionOrderRelationChunk *)executionOrders market:(Market *)market
{
    if (self = [super init]) {
        _accountCurrency = currency;
        _currencyPair = currencyPair;
        _leverage = leverage;
        _market = market;
        _startBalance = balance;
        _openPositions = openPositions;
        _executionOrders = executionOrders;
    }
    
    return self;
}

- (void)update
{
    self.averageRate = nil;
    self.balance = nil;
    self.totalPositionSize = nil;
    self.positionType = nil;
    [self averageRate];
    [self balance];
    [self totalPositionSize];
    [self positionType];
}

- (BOOL)isShortage
{
    Money *equity = [self equity];
    
    if (equity.amount <= 0) {
        return YES;
    } else {
        return NO;
    }
}

- (void)displayDataUsingBlock:(void (^)(NSString *equityStringValue, NSString *profitAndLossStringValue, NSString *orderTypeStringValue, NSString *averageRateStringValue, NSString *totalLotStringValue, UIColor *equityStringColor, UIColor *profitAndLossStringColor))block  positionSizeOfLot:(PositionSize *)positionSize
{
    if (!block) {
        return;
    }
    
    Money *equity = [self equity];
    Money *profitAndLoss = [self profitAndLoss];
    
    block(equity.toDisplayString, profitAndLoss.toDisplayString, [self positionType].toDisplayString, [self averageRate].toDisplayString, [[self totalPositionSize] toLotFromPositionSizeOfLot:positionSize].toDisplayString, equity.toDisplayColor, profitAndLoss.toDisplayColor);
}

- (void)setRealizedProfitAndLoss
{
    if (!_realizedProfitAndLoss || !_currentExecutedCloseOrder) {
        _realizedProfitAndLoss = [_executionOrders profitAndLossOfCurrencyPair:_currencyPair];
        _currentExecutedCloseOrder = [_executionOrders newestCloseOrderOfCurrencyPair:_currencyPair];
    } else {
        ExecutionOrder *newestCloseOrder = [_executionOrders newestCloseOrderOfCurrencyPair:_currencyPair];
        
        if (!newestCloseOrder) {
            return;
        }
        
        FXSComparisonResult *result = [_currentExecutedCloseOrder compareExecutedOrder:newestCloseOrder];
        
        if (!result) {
            return;
        }
        
        if (result.result == NSOrderedAscending) {
            Money *newProfitAndLoss = [_executionOrders profitAndLossOfCurrencyPair:_currencyPair newerThan:_currentExecutedCloseOrder];
            _realizedProfitAndLoss = [_realizedProfitAndLoss addMoney:newProfitAndLoss];
            _currentExecutedCloseOrder = [_executionOrders newestCloseOrderOfCurrencyPair:_currencyPair];
        }
    }
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
        [self setRealizedProfitAndLoss];
        _balance = [_startBalance addMoney:self.convertedRealizedProfitAndLoss];
    }
    
    return _balance;
}

- (Money *)equity
{
    Money *profitAndLoss = [self profitAndLoss];
    
    return [self.balance addMoney:profitAndLoss];
}

- (PositionType *)positionType
{
    if (!_positionType) {
        _positionType = [_openPositions positionTypeOfCurrencyPair:_currencyPair];
    }
    
    return _positionType;
}

- (Money *)profitAndLoss
{
    PositionType *positionType = [self positionType];
    
    Rates *valuationRates = [_market currentRatesOfCurrencyPair:_currencyPair];
    
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

- (Money *)availableMargin
{
    if (![[self totalPositionSize] existsPosition]) {
        return [self equity];
    }
    
    amount_t totalAllPositionValue = [self totalPositionSize].sizeValue * [self averageRate].rateValue;
    Money *margin = [[Money alloc] initWithAmount:totalAllPositionValue / _leverage.leverage currency:[self averageRate].currencyPair.quoteCurrency];
    margin = [margin convertToCurrency:_accountCurrency];
    
    Money *availableMargin = [[Money alloc] initWithAmount:[self equity].amount - margin.amount currency:_accountCurrency];
    
    return availableMargin;
}

- (Money *)convertedRealizedProfitAndLoss
{
    return [_realizedProfitAndLoss convertToCurrency:_accountCurrency];
}

- (void)didOrder:(Result *)result
{
    [result success:^{
        [self update];
    } failure:nil];
}

- (Result *)isOrderable:(Order *)order
{
    Money *availableMargin = [self availableMargin];
    
    amount_t orderablePositionValue = availableMargin.amount * _leverage.leverage;
    
    Money *convertedNewPositionValue = [[order newPositionValue] convertToCurrency:_accountCurrency];
    
    if (orderablePositionValue < convertedNewPositionValue.amount) {
        return [[Result alloc] initWithIsSuccess:NO title:NSLocalizedString(@"Order Failed", nil) message:NSLocalizedString(@"Short Of Margin", nil)];
    }
    
    return [[Result alloc] initWithIsSuccess:YES title:nil message:nil];
}

@end
