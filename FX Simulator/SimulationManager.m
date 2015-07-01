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
#import "Equity.h"
#import "Market.h"
#import "SaveData.h"
#import "SaveLoader.h"
#import "SimulationState.h"
#import "MarketTimeScale.h"
#import "TradeViewController.h"

@interface SimulationManager ()
@property (nonatomic, readwrite) Market *market;
@end

@implementation SimulationManager {
    SaveData *_saveData;
    SimulationState *_simulationState;
}

static SimulationManager *sharedSimulationManager;

+(SimulationManager*)sharedSimulationManager
{
    @synchronized(self) {
        if (sharedSimulationManager == nil) {
            sharedSimulationManager = [SimulationManager new];
        }
    }
    
    return sharedSimulationManager;
}

-(instancetype)init
{
    if (self = [super init]) {
        _saveData = [SaveLoader load];
        _market = [Market new];
        _market.delegate = self;
        _account = [[Account alloc] initWithMarket:_market];
        _simulationState = [[SimulationState alloc] initWithAccount:_account Market:_market];
    }
    
    return self;
}

-(void)willNotifyObservers
{
    [_account updatedMarket];
}

-(void)didNotifyObservers
{
    [_simulationState updatedMarket];
    
    if ([_simulationState isStop]) {
        [self pause];
        [_simulationState showAlert:self.alertTargetController];;
    }
}

-(void)didOrder
{
    [self.account didOrder];
}

-(void)autoUpdateSettingSwitchChanged:(BOOL)isSwitchOn
{
    _saveData.isAutoUpdate = isSwitchOn;
    
    if (![_simulationState isStop]) {
        self.market.isAutoUpdate = _saveData.isAutoUpdate;
    }
}

+(void)restartSimulation
{
    @synchronized(self) {
        if (sharedSimulationManager != nil) {
            sharedSimulationManager = nil;
        }
    }
}

-(void)addObserver:(UIViewController *)observer
{
    [self.market addObserver:observer];
}

-(void)start
{
    [self.market start];
}

-(void)pause
{
    [self.market pause];
}

-(void)resume
{
    [self.market resume];
}

-(void)add
{    
    if (![_simulationState isStop]) {
        [self.market add];
    } else {
        [_simulationState showAlert:self.alertTargetController];
    }
}

-(BOOL)isStop
{
    return [_simulationState isStop];
}

-(void)showAlert:(UIViewController *)controller
{
    [_simulationState showAlert:controller];
}

-(void)setIsAutoUpdate:(BOOL)isAutoUpdate
{
    self.market.isAutoUpdate = isAutoUpdate;
}

-(BOOL)isAutoUpdate
{
    return self.market.isAutoUpdate;
}

@end
