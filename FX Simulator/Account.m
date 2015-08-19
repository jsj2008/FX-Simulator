//
//  Account.m
//  FX Simulator
//
//  Created by yuu on 2015/06/15.
//
//

#import "Account.h"

#import "Equity.h"
#import "EquityFactory.h"
#import "ForexHistoryData.h"
#import "Market.h"
#import "Money.h"
#import "OpenPosition.h"

@interface Account ()
@property (nonatomic, readwrite) OpenPosition *openPosition;
@property (nonatomic, readwrite) Money *profitAndLoss;
@end

@implementation Account {
    Equity *_equityObj;
    Market *_market;
}

-(instancetype)initWithMarket:(Market *)market
{
    if (self = [super init]) {
        _market = market;
        [self setInitData];
    }
    
    return self;
}

-(void)setInitData
{
    _equityObj = [EquityFactory createEquity];
    _openPosition = [OpenPosition loadOpenPosition];
    [self updatedMarket];
}

-(void)updatedMarket
{
    [_equityObj setCurrentProfitAndLoss:self.profitAndLoss];
}

-(void)updatedSaveData
{
    _equityObj = [EquityFactory createEquity];
    _openPosition = [OpenPosition loadOpenPosition];
    [self updatedMarket];
}

-(void)didOrder
{
    [self.openPosition update];
    [_equityObj update];
}

-(BOOL)isShortage
{
    return [_equityObj isShortage];
}

-(Money*)equity
{
    return _equityObj.equity;
}

-(Money*)profitAndLoss
{
    return [self.openPosition profitAndLossForRate:_market.currentForexHistoryData.close];
}

@end
