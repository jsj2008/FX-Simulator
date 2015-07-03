//
//  Market.m
//  FX Simulator
//
//  Created  on 2014/11/13.
//  
//

#import "Market.h"

#import "SaveLoader.h"
#import "SaveData.h"
#import "MarketTimeManager.h"
#import "CurrencyPair.h"
#import "Rate.h"
#import "MarketTime.h"
#import "ForexHistoryFactory.h"
#import "ForexHistory.h"
#import "ForexHistoryData.h"
#import "Rates.h"


static NSString * const kKeyPath = @"currentLoadedRowid";

@interface Market ()
@property (nonatomic, readwrite) int currentLoadedRowid;
@end

@implementation Market {
    SaveData *saveData;
    MarketTimeManager *_marketTimeManager;
    NSMutableArray *_observers;
    ForexHistory *forexHistory;
    ForexHistoryData *_lastData;
}

-(id)init
{
    if (self = [super init]) {
        [self setInitData];
        _observers = [NSMutableArray array];
    }
    
    return self;
}

-(void)setInitData
{
    saveData = [SaveLoader load];
    forexHistory = [ForexHistoryFactory createForexHistoryFromCurrencyPair:saveData.currencyPair timeScale:saveData.timeScale];
    _lastData = [forexHistory lastRecord];
    _marketTimeManager = [MarketTimeManager new];
    [_marketTimeManager addObserver:self];
    _currentLoadedRowid = _marketTimeManager.currentLoadedRowid;
    _isStart = NO;
    [self setMarketData];
}

-(void)addObserver:(UIViewController *)observer
{
    [_observers addObject:observer];
    
    [self addObserver:(NSObject*)observer forKeyPath:kKeyPath options:NSKeyValueObservingOptionNew context:NULL];
}

-(Rate*)getCurrentBidRate
{
    return self.currentForexHistoryData.close;
}

-(Rate*)getCurrentAskRate
{
    return [[[Rates alloc] initWithBidRtae:self.currentForexHistoryData.close] askRate];
}

-(void)setDefaultData
{
    /// observerが全て更新され、Marketのデータがセットされる。
    self.currentLoadedRowid = _marketTimeManager.currentLoadedRowid;
}

-(void)start
{
    [self setDefaultData];
    
    if (saveData.isAutoUpdate) {
        [self startTime];
    }
}

-(void)pause
{
    [_marketTimeManager pause];
}

-(void)resume
{
    [_marketTimeManager resume];
}

-(void)updatedSaveData
{
    [_marketTimeManager end];
    [self setInitData];
}

-(void)add
{
    [_marketTimeManager add];
}

-(void)startTime
{
    _isStart = YES;
    [_marketTimeManager start];
}

-(void)setIsAutoUpdate:(BOOL)isAutoUpdate
{
    if (_isStart) {
        if (YES == isAutoUpdate) {
            [_marketTimeManager resume];
        } else {
            [_marketTimeManager pause];
        }
    } else {
        if (YES == saveData.isAutoUpdate) {
            [self startTime];
        }
    }
    //[marketTime setIsAutoUpdate:isAutoUpdate];
    //saveData.isAutoUpdate = isAutoUpdate;
}

-(void)setMarketData
{
    int getDataCount = 40; // MarketがあらかじめForexHistoryから取得するデータ数
    self.currentForexHistoryDataArray = [forexHistory selectMaxRowid:_currentLoadedRowid limit:getDataCount];
    self.currentForexHistoryData = [self.currentForexHistoryDataArray lastObject];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"currentLoadedRowid"] && [object isKindOfClass:[MarketTimeManager class]]) {
        
        _currentLoadedRowid = [[object valueForKey:@"currentLoadedRowid"] intValue];
        
        [self setMarketData];
        
        if ([self.delegate respondsToSelector:@selector(willNotifyObservers)]) {
            [self.delegate willNotifyObservers];
        }
        
        self.currentLoadedRowid = _currentLoadedRowid;
        // SimulatorManager
        // observeの呼ばれる順番は不規則
        // Marketの更新"直後"に実行したいものはObserverにしない
        // MarketTimeの変化でのみcurrentTimestampが変化
        // currentTimestampの変化で、MarketのObserverを更新
        
        if ([self.delegate respondsToSelector:@selector(didNotifyObservers)]) {
            [self.delegate didNotifyObservers];
        }
    }
}

-(void)setAutoUpdateInterval:(NSNumber *)autoUpdateInterval
{
    _marketTimeManager.autoUpdateInterval = autoUpdateInterval;
}

-(BOOL)didLoadLastData
{
    if (_lastData.ratesID == self.currentForexHistoryData.ratesID) {
        return YES;
    } else {
        return NO;
    }
}

-(void)dealloc
{
    for (NSObject *obj in _observers) {
        [self removeObserver:obj forKeyPath:kKeyPath];
    }
}

@end
