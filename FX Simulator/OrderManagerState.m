//
//  OrderManagerState.m
//  FX Simulator
//
//  Created by yuu on 2015/06/12.
//
//

#import "OrderManagerState.h"

#import "FXSAlert.h"
#import "OpenPosition.h"
#import "SimulationManager.h"
#import "UsersOrder.h"

@implementation OrderManagerState {
    OpenPosition *_openPosition;
    SimulationManager *_simulationManager;
    BOOL _simulationManagerStop;
    BOOL _openPositionMax;
    BOOL _isExecutable;
}

-(instancetype)init
{
    if (self = [super init]) {
        _openPosition = [OpenPosition loadOpenPosition];
        _simulationManager = [SimulationManager sharedSimulationManager];
        _simulationManagerStop = NO;
        _openPositionMax = NO;
        _isExecutable = NO;
    }
    
    return self;
}

- (void)updateState:(Order *)order
{
    _simulationManagerStop = [_simulationManager isStop];
    _openPositionMax = [_openPosition isMax];
    
    if (_simulationManagerStop) {
        _isExecutable = NO;
    } else if (_openPositionMax) {
        if ([order includeCloseOrder]) {
            _isExecutable = YES;
        } else {
            _isExecutable = NO;
        }
    } else {
        _isExecutable = YES;
    }
}

-(BOOL)isExecutable
{
    return _isExecutable;
}

-(void)showAlert:(UIViewController*)controller
{
    if (![self isExecutable]) {
        if (_simulationManagerStop) {
            [_simulationManager showAlert:controller];
        } else if (_openPositionMax) {
            [FXSAlert showAlert:controller title:@"オープンポジションが最大になりました。" message:nil];
        }
    }
}

@end
