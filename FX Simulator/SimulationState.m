//
//  SimulationState.m
//  FX Simulator
//
//  Created by yuu on 2015/06/11.
//
//

#import "SimulationState.h"

#import "FXSAlert.h"

static NSString* const shortageAlertTitle = @"資産が足りません。";
static NSString* const chartEndAlertTitle = @"チャートが端まで読み込まれました。";

@implementation SimulationState {
    BOOL _isShortage;
    BOOL _isForexDataEnd;
}

-(instancetype)init
{
    if (self = [super init]) {
        _isShortage = NO;
        _isForexDataEnd = NO;
    }
    
    return self;
}

-(void)shortage
{
    _isShortage = YES;
}

-(void)didLoadForexDataEnd
{
    _isForexDataEnd = YES;
}

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

-(void)reset
{
    _isShortage = NO;
    _isForexDataEnd = NO;
}

-(BOOL)isStop
{
    if (_isShortage || _isForexDataEnd) {
        return YES;
    }
    
    return NO;
}

@end
