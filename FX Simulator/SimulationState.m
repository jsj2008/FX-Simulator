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

static NSString* const shortageAlertTitle = @"資産が足りません。";
static NSString* const chartEndAlertTitle = @"チャートが端まで読み込まれました。";

@implementation SimulationState {
    BOOL _isShortage;
    BOOL _isForexDataEnd;
    Account *_account;
    Market *_market;
}

-(instancetype)initWithAccount:(Account *)account Market:(Market *)market
{
    if (self = [super init]) {
        _isShortage = NO;
        _isForexDataEnd = NO;
        _account = account;
        _market = market;
    }
    
    return self;
}

-(void)shortage
{
    _isShortage = YES;
}

/*-(void)didLoadForexDataEnd
{
    _isForexDataEnd = YES;
}*/

- (void)showAlert:(UIViewController *)controller
{
    NSString *title;
    
    if (_isShortage) {
        title = shortageAlertTitle;
    } else if (_isForexDataEnd) {
        title = chartEndAlertTitle;
    }
    
    [FXSAlert showAlert:controller title:title message:nil];
}

-(void)updatedMarket
{    
    if ([_account isShortage]) {
        _isShortage = YES;
    }
    
    if ([_market didLoadLastData]) {
        _isForexDataEnd = YES;
    }
}

-(void)reset
{
    _isShortage = NO;
    _isForexDataEnd = NO;
}

-(BOOL)isStop
{
    if (_isShortage || _isForexDataEnd) {
        return YES;
    } else {
        return NO;
    }
}

@end
