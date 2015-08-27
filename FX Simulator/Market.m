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


static NSInteger FXSMaxForexDataStore = 500;
static NSString * const kKeyPath = @"currentTime";

@interface Market ()
@property (nonatomic, readwrite) int currentLoadedRowid;
@property (nonatomic) Rate *currentRate;
@property (nonatomic) MarketTime *currentTime;
@property (nonatomic) ForexHistoryData *currentForexData;
@end

@implementation Market {
    SaveData *saveData;
    MarketTimeManager *_marketTimeManager;
    NSMutableArray *_observers;
    ForexDataChunkStore *_forexDataChunkStore;
    ForexHistory *forexHistory;
    ForexHistoryData *_lastData;
}

-(id)init
{
    if (self = [super init]) {
        
        /**
         newした段階で、Marketに初期データをセットしておく。
        */
        [self setInitData];
        
        _observers = [NSMutableArray array];
    }
    
    return self;
}

-(void)setInitData
{
    saveData = [SaveLoader load];
    
    forexHistory = [ForexHistoryFactory createForexHistoryFromCurrencyPair:saveData.currencyPair timeScale:saveData.timeFrame];
    _currentTime = saveData.lastLoadedTime;
    _currentForexData = [forexHistory selectMaxCloseTime:_currentTime limit:1].firstObject;
    
    _forexDataChunkStore = [[ForexDataChunkStore alloc] initWithCurrencyPair:saveData.currencyPair timeScale:saveData.timeFrame getMaxLimit:FXSMaxForexDataStore];
    
    _lastData = [forexHistory lastRecord];
    
    _marketTimeManager = [MarketTimeManager new];
    [_marketTimeManager addObserver:self];
    
    _isStart = NO;

}

-(void)addObserver:(UIViewController *)observer
{
    [_observers addObject:observer];
    
    [self addObserver:(NSObject*)observer forKeyPath:kKeyPath options:NSKeyValueObservingOptionNew context:NULL];
}

-(Rate*)getCurrentBidRate
{
    return self.currentForexData.close;
}

-(Rate*)getCurrentAskRate
{
    return [[[Rates alloc] initWithBidRtae:self.currentForexData.close] askRate];
}

/**
 ObserverにMarketの更新前、更新、更新後を通知。
*/
- (void)updateMarketFromNewCurrentData:(ForexHistoryData *)data
{
    // Market更新前を通知。
    if ([self.delegate respondsToSelector:@selector(willNotifyObservers)]) {
        [self.delegate willNotifyObservers];
    }
    
    self.currentForexData = data;
    self.currentRate = data.close;
    
    // Market更新。
    self.currentTime = self.currentRate.timestamp;
    
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
    // 初期データでMarketを更新しておく。
    [self updateMarketFromNewCurrentData:self.currentForexData];
    
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

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"currentLoadedRowid"] && [object isKindOfClass:[MarketTimeManager class]]) {
        
        ForexDataChunk *currentForexDataChunk = [_forexDataChunkStore getChunkFromNextDataOfTime:self.currentTime limit:1];
        
        ForexHistoryData *newCurrentData = currentForexDataChunk.current;
        
        if (newCurrentData == nil) {
            return;
        }
        
        [self updateMarketFromNewCurrentData:newCurrentData];
    }
}

-(void)setAutoUpdateInterval:(NSNumber *)autoUpdateInterval
{
    _marketTimeManager.autoUpdateInterval = autoUpdateInterval;
}

-(BOOL)didLoadLastData
{
    if (_lastData.ratesID == self.currentForexData.ratesID) {
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
