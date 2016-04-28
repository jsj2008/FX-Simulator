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
#import "Message.h"
#import "OpenPosition.h"
#import "Order.h"
#import "OrderFactory.h"
#import "OrderManager.h"
#import "Result.h"
#import "SaveData.h"
#import "SaveLoader.h"
#import "Setting.h"
#import "SimulationState.h"
#import "SimulationStateResult.h"
#import "SimulationTimeManager.h"
#import "TimeFrame.h"
#import "TradeDatabase.h"

@implementation SimulationManager {
    Account *_account;
    Market *_market;
    NSHashTable *_delegates;
    OrderFactory *_orderFactory;
    OrderManager *_orderManager;
    SaveData *_saveData;
    SimulationState *_simulationState;
    SimulationTimeManager *_simulationTimeManager;
    NSDate *_previousAddTimeDate;
    BOOL _isSimulationStopped;
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
    
    _isSimulationStopped = NO;
    
    _saveData = saveData;
    _account = saveData.account;
    _market = _saveData.market;
    _orderFactory = [[OrderFactory alloc] initWithSaveSlot:saveData.slotNumber openPositions:saveData.openPositions];
    _orderManager = [OrderManager createOrderManagerFromOpenPositions:saveData.openPositions];
    [_orderManager addDelegate:self];
    [_orderManager addState:self];
    [_orderManager addState:_account];
    _simulationState = [[SimulationState alloc] initWithAccount:_account Market:_market];
    _simulationTimeManager = [[SimulationTimeManager alloc] initWithAutoUpdateIntervalSeconds:saveData.autoUpdateIntervalSeconds isAutoUpdate:saveData.isAutoUpdate];
    [_simulationTimeManager addObserver:self];
    
    [_account update];
    
    for (id<SimulationManagerDelegate> delegate in _delegates) {
        if ([delegate respondsToSelector:@selector(loadSaveData:)]) {
            [delegate loadSaveData:_saveData];
        }
        if ([delegate respondsToSelector:@selector(loadMarket:)]) {
            [delegate loadMarket:_market];
        }
        if ([delegate respondsToSelector:@selector(loadOrderFactory:)]) {
            [delegate loadOrderFactory:_orderFactory];
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
        
        if (_isSimulationStopped) {
            return;
        }
        
        [_market add];
        
        [self notifyDelegatesOfMarketDidUpdate];
    }
}

- (void)notifyDelegatesOfMarketDidUpdate
{
    for (id<SimulationManagerDelegate> delegate in _delegates) {
        if ([delegate respondsToSelector:@selector(marketDidUpdate)]) {
            [delegate marketDidUpdate];
        }
    }
    
    [self didNotifyDelegatesOfMarketDidUpdate];
}

- (void)didNotifyDelegatesOfMarketDidUpdate
{
    SimulationStateResult *result = [_simulationState isStop];
    
    if (result.isStop) {
        [self stopSimulationWithResult:result];
    }
}

- (void)stopSimulation
{
    [self pauseTime];
    
    _isSimulationStopped = YES;
}

- (void)stopSimulationWithResult:(SimulationStateResult *)result
{
    [self stopSimulation];
    
    for (id<SimulationManagerDelegate> delegate in _delegates) {
        if ([delegate respondsToSelector:@selector(simulationStopped:)]) {
            [delegate simulationStopped:[[Message alloc] initWithTitle:result.title message:result.message]];
        }
    }
}

- (void)startTime
{
    if (!self.isStartTime) {
        
        [_simulationTimeManager start];
        
        SimulationStateResult *result = [_simulationState isStop];
        
        if (result.isStop) {
            [self stopSimulationWithResult:result];
            return;
        }
        
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
    [_simulationTimeManager add];
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

- (BOOL)isAutoUpdate
{
    return _saveData.isAutoUpdate;
}

- (void)setIsAutoUpdate:(BOOL)isAutoUpdate
{
    _saveData.isAutoUpdate = isAutoUpdate;
    [_simulationTimeManager setIsAutoUpdate:_saveData.isAutoUpdate];
}

- (Result *)isOrderable:(Order *)order;
{
    SimulationStateResult *result = [_simulationState isStop];
    
    if (result.isStop) {
        return [[Result alloc] initWithIsSuccess:NO title:result.title message:nil];
    } else {
        return [[Result alloc] initWithIsSuccess:YES title:nil message:nil];
    }
}

- (void)didOrder:(Result *)result
{
    [_account didOrder:result];
        
    for (id<SimulationManagerDelegate> delegate in _delegates) {
        if ([delegate respondsToSelector:@selector(didOrder:)]) {
            [delegate didOrder:result];
        }
    }
}

- (BOOL)isStartTime
{
    return _simulationTimeManager.isStart;
}

@end
