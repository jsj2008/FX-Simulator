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
#import "ExecutionOrder.h"
#import "Market.h"
#import "OpenPosition.h"
#import "Order.h"
#import "OrderManager.h"
#import "OrderResult.h"
#import "SaveData.h"
#import "SaveLoader.h"
#import "Setting.h"
#import "SimulationState.h"
#import "SimulationStateResult.h"
#import "SimulationTimeManager.h"
#import "TimeFrame.h"
#import "TradeDatabase.h"
#import "TradeViewController.h"

@implementation SimulationManager {
    Market *_market;
    NSHashTable *_delegates;
    OrderManager *_orderManager;
    SaveData *_saveData;
    SimulationState *_simulationState;
    SimulationTimeManager *_simulationTimeManager;
    NSDate *_previousAddTimeDate;
}

- (instancetype)init
{
    if (self = [super init]) {
        _delegates = [NSHashTable weakObjectsHashTable];
    }
    
    return self;
}

- (void)addDelegate:(id<SimulationManagerDelegate>)delegate
{
    [_delegates addObject:delegate];
}

- (void)loadSaveData:(SaveData *)saveData
{
    if (!saveData) {
        return;
    }
    
    _saveData = saveData;
    _market = [[Market alloc] initWithCurrencyPair:saveData.currencyPair timeFrame:saveData.timeFrame lastLoadedTime:saveData.lastLoadedTime spread:saveData.spread];
    _orderManager = [OrderManager createOrderManagerFromOpenPositions:saveData.openPositions];
    [_orderManager addDelegate:_saveData.account];
    [_orderManager addState:self];
    _simulationState = [[SimulationState alloc] initWithAccount:saveData.account Market:_market];
    _simulationTimeManager = [[SimulationTimeManager alloc] initWithAutoUpdateIntervalSeconds:saveData.autoUpdateIntervalSeconds isAutoUpdate:saveData.isAutoUpdate];
    [_simulationTimeManager addObserver:self];
    
    for (id<SimulationManagerDelegate> delegate in _delegates) {
        if ([delegate respondsToSelector:@selector(loadSaveData:)]) {
            [delegate loadSaveData:_saveData];
        }
        if ([delegate respondsToSelector:@selector(loadMarket:)]) {
            [delegate loadMarket:_market];
        }
        if ([delegate respondsToSelector:@selector(loadOrderManager:)]) {
            [delegate loadOrderManager:_orderManager];
        }
    }
    
    for (id<SimulationManagerDelegate> delegate in _delegates) {
        if ([delegate respondsToSelector:@selector(saveDataDidLoad)]) {
            [delegate saveDataDidLoad];
        }
    }
    
    [SaveLoader setLastLoadedSaveDataSlotNumber:saveData.slotNumber];
}

- (void)startSimulation
{
    for (id<SimulationManagerDelegate> delegate in _delegates) {
        if ([delegate respondsToSelector:@selector(loadSimulationManager:)]) {
            [delegate loadSimulationManager:self];
        }
    }
        
    [self loadSaveData:[SaveLoader loadDefaultSaveData]];
}

- (void)startSimulationForSaveData:(SaveData *)saveData
{
    [self loadSaveData:saveData];
}

- (void)save
{
    _saveData.lastLoadedTime = _market.currentTime;
    [_saveData saveWithCompletion:nil error:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"currentLoadedRowid"] && [object isKindOfClass:[SimulationTimeManager class]]) {
        
        SimulationStateResult *result = [_simulationState isStop];
        
        if (result.isStop) {
            return;
        }
        
        [_market add];
        
        [self notifyDelegatesOfUpdate];
    }
}

- (void)notifyDelegatesOfUpdate
{
    for (id<SimulationManagerDelegate> delegate in _delegates) {
        if ([delegate respondsToSelector:@selector(update)]) {
            [delegate update];
        }
    }
    
    [self didNotifyDelegatesOfUpdate];
}

- (void)didNotifyDelegatesOfUpdate
{
    SimulationStateResult *result = [_simulationState isStop];
    
    if (result.isStop) {
        [self pauseTime];
        for (id<SimulationManagerDelegate> delegate in _delegates) {
            if ([delegate respondsToSelector:@selector(simulationStopped:)]) {
                [delegate simulationStopped:result];
            }
        }
    }
}

- (void)startTime
{
    if (!self.isStartTime) {
        [self notifyDelegatesOfUpdate];
        [_simulationTimeManager start];
    }
}

- (void)pauseTime
{
    [_simulationTimeManager pause];
}

- (void)resumeTime
{
    [_simulationTimeManager resume];
}

- (void)addTime
{
    NSDate *now = [NSDate date];
    
    if (!_previousAddTimeDate || [Setting minAutoUpdateIntervalSeconds] < [now timeIntervalSinceDate:_previousAddTimeDate]) {
        _previousAddTimeDate = now;
        [_simulationTimeManager add];
    }
}

- (float)autoUpdateIntervalSeconds
{
    return _saveData.autoUpdateIntervalSeconds;
}

- (void)setAutoUpdateIntervalSeconds:(float)autoUpdateIntervalSeconds
{
    _saveData.autoUpdateIntervalSeconds = autoUpdateIntervalSeconds;
    [_simulationTimeManager setAutoUpdateIntervalSeconds:_saveData.autoUpdateIntervalSeconds];
}

- (void)setIsAutoUpdate:(BOOL)isAutoUpdate
{
    _saveData.isAutoUpdate = isAutoUpdate;
    [_simulationTimeManager setIsAutoUpdate:_saveData.isAutoUpdate];
}

- (OrderResult *)isOrderable:(Order *)order;
{
    SimulationStateResult *result = [_simulationState isStop];
    
    if (result.isStop) {
        return [[OrderResult alloc] initWithIsSuccess:NO title:result.title message:nil];
    } else {
        return [[OrderResult alloc] initWithIsSuccess:YES title:nil message:nil];
    }
}

- (BOOL)isStartTime
{
    return _simulationTimeManager.isStart;
}

@end
