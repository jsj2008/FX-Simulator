//
//  SimulationManager.m
//  FX Simulator
//
//  Created by yuu on 2015/06/03.
//
//

#import "SimulationManager.h"

#import "Account.h"
#import "CurrencyPair.h"
#import "Market.h"
#import "SaveData.h"
#import "SaveLoader.h"
#import "SimulationState.h"
#import "TimeFrame.h"
#import "TradeDatabase.h"
#import "TradeViewController.h"

static SimulationManager *sharedSimulationManager = nil;

@implementation SimulationManager {
    Account *_account;
    SaveData *_saveData;
    SimulationState *_simulationState;
}

+ (SimulationManager *)sharedSimulationManager
{
    @synchronized(self) {
        if (sharedSimulationManager == nil) {
            sharedSimulationManager = [SimulationManager new];
        }
    }
    
    return sharedSimulationManager;
}

- (instancetype)init
{
    if (self = [super init]) {
        _market = [Market new];
        _market.delegate = self;
        
        [self loadSaveData:[SaveLoader load]];
    }
    
    return self;
}

- (void)loadSaveData:(SaveData *)saveData
{
    _saveData = saveData;
    
    [TradeDatabase loadSaveData:_saveData];
    
    [_market loadSaveData:_saveData];
    
    _account = _saveData.account;
    _simulationState = [[SimulationState alloc] initWithAccount:_account Market:_market];
}

- (void)willNotifyObservers
{
    //[_account updatedMarket];
}

- (void)didNotifyObservers
{
    [_simulationState updatedMarket];
    
    if ([_simulationState isStop]) {
        [self pause];
        [_simulationState showAlert:self.alertTargetController];;
    }
}

- (void)autoUpdateSettingSwitchChanged:(BOOL)isSwitchOn
{
    _saveData.isAutoUpdate = isSwitchOn;
    
    if (![_simulationState isStop]) {
        self.market.isAutoUpdate = _saveData.isAutoUpdate;
    }
}

- (void)updatedSaveData
{
    [self loadSaveData:[SaveLoader load]];
}

- (void)addObserver:(UIViewController *)observer
{
    [self.market addObserver:observer];
}

- (void)start
{
    [self.market start];
}

- (void)pause
{
    [self.market pause];
}

- (void)resume
{
    [self.market resume];
}

- (void)add
{    
    if (![_simulationState isStop]) {
        [self.market add];
    } else {
        [_simulationState showAlert:self.alertTargetController];
    }
}

- (BOOL)isExecutableOrder
{
    return ![self isStop];
}

- (BOOL)isStop
{
    return [_simulationState isStop];
}

- (void)showAlert:(UIViewController *)controller
{
    [_simulationState showAlert:controller];
}

- (void)setIsAutoUpdate:(BOOL)isAutoUpdate
{
    self.market.isAutoUpdate = isAutoUpdate;
}

- (BOOL)isAutoUpdate
{
    return self.market.isAutoUpdate;
}

- (BOOL)isStart
{
    return self.market.isStart;
}

@end
