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
#import "Setting.h"
#import "MarketTime.h"
#import "ForexDataChunk.h"
#import "ForexDataChunkStore.h"
#import "ForexHistoryFactory.h"
#import "ForexHistory.h"
#import "ForexHistoryData.h"
#import "Rates.h"


static NSInteger kMaxForexDataStore;
static NSString * const kKeyPath = @"currentForexHistoryData";

@interface Market ()
@property (nonatomic, readwrite) int currentLoadedRowid;
@end

@implementation Market {
    SaveData *saveData;
    MarketTimeManager *_marketTimeManager;
    NSMutableArray *_observers;
    ForexDataChunkStore *_forexDataChunkStore;
    ForexHistory *forexHistory;
    ForexHistoryData *_lastData;
    ForexHistoryData *_startForexData;
}

+(void)initialize
{
    kMaxForexDataStore = [Setting maxDisplayForexDataCountOfChartView] + [Setting maxIndicatorTerm] - 1;
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
    
    _forexDataChunkStore = [[ForexDataChunkStore alloc] initWithCurrencyPair:saveData.currencyPair timeScale:saveData.timeScale];
    
    forexHistory = [ForexHistoryFactory createForexHistoryFromCurrencyPair:saveData.currencyPair timeScale:saveData.timeScale];
    _lastData = [forexHistory lastRecord];
    _startForexData = [forexHistory selectRowidLimitCloseTimestamp:saveData.lastLoadedCloseTimestamp];
    
    _marketTimeManager = [MarketTimeManager new];
    [_marketTimeManager addObserver:self];
    
    //_currentLoadedRowid = _marketTimeManager.currentLoadedRowid;
    _isStart = NO;
#warning ここでもMarket更新している。
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

/*- (NSArray *)getForexDataLimit:(NSInteger)count
{
    NSInteger lastIndex = self.currentForexHistoryDataArray.count - 1;
    NSInteger getStartIndex = lastIndex - count + 1;
    
    if (lastIndex < 0 || getStartIndex < 0) {
        return nil;
    }
    
    return [self.currentForexHistoryDataArray subarrayWithRange:NSMakeRange(getStartIndex, lastIndex)];
}*/

-(void)setDefaultData
{
    self.currentForexDataChunk = [_forexDataChunkStore getChunkFromHeadData:_startForexData limit:kMaxForexDataStore];
    
    [self updateMarketForCurrentData:_startForexData];
    
    /// observerが全て更新され、Marketのデータがセットされる。
    //self.currentLoadedRowid = _marketTimeManager.currentLoadedRowid;
}

- (void)updateMarketForCurrentData:(ForexHistoryData *)data
{
    //self.currentForexDataChunk = [_forexDataChunkStore getChunkFromHeadData:self.currentForexHistoryData limit:kMaxForexDataStore];
    
    // Market更新前を通知。
    if ([self.delegate respondsToSelector:@selector(willNotifyObservers)]) {
        [self.delegate willNotifyObservers];
    }
    
    // Market更新。
    self.currentForexHistoryData = data;
    // SimulatorManager
    // observeの呼ばれる順番は不規則
    // Marketの更新"直後"に実行したいものはObserverにしない
    // MarketTimeの変化でのみcurrentTimestampが変化
    // currentTimestampの変化で、MarketのObserverを更新
    
    // Market更新後を通知。
    if ([self.delegate respondsToSelector:@selector(didNotifyObservers)]) {
        [self.delegate didNotifyObservers];
    }
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
    int getDataCount = kMaxForexDataStore; // MarketがあらかじめForexHistoryから取得するデータ数
    
    self.currentForexDataChunk = [forexHistory selectMaxRowid:_currentLoadedRowid limit:getDataCount];
    self.currentForexHistoryData = self.currentForexDataChunk.current;
    /*self.currentForexHistoryDataArray = [forexHistory selectMaxRowid:_currentLoadedRowid limit:getDataCount];
    self.currentForexHistoryData = [self.currentForexHistoryDataArray lastObject];*/
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"currentLoadedRowid"] && [object isKindOfClass:[MarketTimeManager class]]) {
        
        self.currentForexDataChunk = [_forexDataChunkStore getChunkFromNextDataOf:self.currentForexHistoryData limit:kMaxForexDataStore];
        
        if (self.currentForexDataChunk == nil) {
            return;
        }
        
        [self updateMarketForCurrentData:self.currentForexDataChunk.current];
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
