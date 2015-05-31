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
    MarketTimeManager *marketTime;
    ForexHistory *forexHistory;
    BOOL _isStart;
}

-(id)init
{
    if (self = [super init]) {
        saveData = [SaveLoader load];
        forexHistory = [ForexHistoryFactory createForexHistoryFromCurrencyPair:saveData.currencyPair timeScale:saveData.timeScale];
        marketTime = [MarketTimeManager new];
        [marketTime addObserver:self];
        _currentLoadedRowid = marketTime.currentLoadedRowid;
        _isStart = NO;
        [self setMarketData];
    }
    
    return self;
}

-(void)addObserver:(NSObject *)observer
{
    [self addObserver:observer forKeyPath:kKeyPath options:NSKeyValueObservingOptionNew context:NULL];
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
    self.currentLoadedRowid = marketTime.currentLoadedRowid;
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
    [marketTime setIsAutoUpdate:NO];
}

-(void)resume
{
    [marketTime setIsAutoUpdate:saveData.isAutoUpdate];
}

-(void)add
{
    [marketTime add];
}

-(void)startTime
{
    _isStart = YES;
    [marketTime start];
}

-(void)setIsAutoUpdate:(BOOL)isAutoUpdate
{
    saveData.isAutoUpdate = isAutoUpdate;
    
    if (_isStart) {
        [marketTime setIsAutoUpdate:isAutoUpdate];
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
        
        self.currentLoadedRowid = _currentLoadedRowid;
        // SimulatorManager
        // observeの呼ばれる順番は不規則
        // Marketの更新"直後"に実行したいものはObserverにしない
        // MarketTimeの変化でのみcurrentTimestampが変化
        // currentTimestampの変化で、MarketのObserverを更新
        //self.currentTimestamp = self.currentForexHistoryData.close.timestamp.timestampValue;
        //int t = self.currentForexHistoryData.close.timestamp.timestampValue;
        //self.currentTimestamp = 100;
        //self.isAutoUpdate = YES;
    }
}

-(void)setAutoUpdateInterval:(NSNumber *)autoUpdateInterval
{
    marketTime.autoUpdateInterval = autoUpdateInterval;
}

@end
