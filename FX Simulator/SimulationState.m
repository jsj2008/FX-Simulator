//
//  SimulationState.m
//  FX Simulator
//
//  Created by yuu on 2015/06/11.
//
//

#import "SimulationState.h"

#import "Account.h"
#import "ForexHistoryData.h"
#import "FXSAlert.h"
#import "Market.h"
#import "SimulationStateResult.h"

@implementation SimulationState {
    Account *_account;
    Market *_market;
}

-(instancetype)initWithAccount:(Account *)account Market:(Market *)market
{
    if (self = [super init]) {
        _account = account;
        _market = market;
    }
    
    return self;
}

- (SimulationStateResult *)isStop
{
    if ([_account isShortage]) {
        return [[SimulationStateResult alloc] initWithIsStop:YES title:NSLocalizedString(@"Shortage Of Equity", nil) message:nil];
    } else if ([_market didLoadLastData]) {
        return [[SimulationStateResult alloc] initWithIsStop:YES title:NSLocalizedString(@"End Of Data", nil) message:nil];
    }
    
    return [[SimulationStateResult alloc] initWithIsStop:NO title:nil message:nil];
}

@end
