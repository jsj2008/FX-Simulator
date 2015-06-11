//
//  SimulationManager.m
//  FX Simulator
//
//  Created by yuu on 2015/06/03.
//
//

#import "SimulationManager.h"

#import "Equity.h"
#import "Market.h"
#import "SimulationState.h"
#import "TradeViewController.h"

@interface SimulationManager ()
@property (nonatomic, readwrite) Market *market;
@end

@implementation SimulationManager {
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
        _market = [Market new];
        _simulationState = [SimulationState new];
    }
    
    return self;
}

-(void)autoUpdateSettingSwitchChanged:(BOOL)isSwitchOn
{
    self.market.isAutoUpdate = isSwitchOn;
}

-(void)updatedEquity:(Equity *)equity
{
    if ([equity isShortage]) {
        [self pause];
        [_simulationState shortage];
        [_simulationState showAlert];
    }
}

-(void)didLoadForexDataEnd
{
    
}

-(void)restartSimulation
{
    self.market = [Market new];
    [_simulationState reset];
}

-(void)addObserver:(NSObject *)observer
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
    [self.market add];
}

-(void)stop
{
    [self pause];
}

-(void)setIsAutoUpdate:(BOOL)isAutoUpdate
{
    self.market.isAutoUpdate = isAutoUpdate;
}

-(BOOL)isAutoUpdate
{
    return self.market.isAutoUpdate;
}

-(void)setAlertTargetController:(TradeViewController *)alertTargetController
{
    _simulationState.alertTarget = alertTargetController;
}

@end
