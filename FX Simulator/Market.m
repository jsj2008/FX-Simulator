//
//  Market.m
//  FX Simulator
//
//  Created  on 2014/11/13.
//  
//

#import "Market.h"

#import "CurrencyPair.h"
#import "ForexDataChunk.h"
#import "ForexDataChunkStore.h"
#import "ForexHistoryFactory.h"
#import "ForexHistory.h"
#import "ForexHistoryData.h"
#import "Time.h"
#import "TimeFrameChunk.h"
#import "Rate.h"
#import "Rates.h"
#import "Setting.h"

static NSInteger FXSMaxForexDataStore = 500;

@interface Market ()
@property (nonatomic, readwrite) int currentLoadedRowid;
@property (nonatomic) Rate *currentRate;
@property (nonatomic) Time *currentTime;
@property (nonatomic) ForexHistoryData *currentForexData;
@end

@implementation Market {
    ForexDataChunkStore *_forexDataChunkStore;
    ForexHistory *_forexHistory;
    ForexHistoryData *_lastData;
    TimeFrame *_completionTimeFrame;
}

- (instancetype)initWithCurrencyPair:(CurrencyPair *)currencyPair timeFrame:(TimeFrame *)timeFrame lastLoadedTime:(Time *)time
{
    if (self = [super init]) {
        _forexHistory = [ForexHistoryFactory createForexHistoryFromCurrencyPair:currencyPair timeScale:timeFrame];
        _currentTime = time;
        _currentForexData = [_forexHistory selectMaxCloseTime:_currentTime limit:1].current;
        _forexDataChunkStore = [[ForexDataChunkStore alloc] initWithCurrencyPair:currencyPair timeScale:timeFrame getMaxLimit:FXSMaxForexDataStore];
        _lastData = [_forexHistory newestData];
        _completionTimeFrame = [Setting timeFrameList].minTimeFrame;
    }
    
    return self;
}

- (void)add
{
    ForexHistoryData *newCurrentData = [_forexDataChunkStore getChunkFromNextDataOfTime:self.currentTime limit:1].current;
    
    if (newCurrentData == nil) {
        return;
    }
    
    [self updateMarketFromNewCurrentData:newCurrentData];
}

- (Rates *)currentRatesOfCurrencyPair:(CurrencyPair *)currencyPair
{
    Rate *currentBidRate = [self getCurrentBidRateOfCurrencyPair:currencyPair];
    
    if (!currentBidRate) {
        return nil;
    }
    
    return [[Rates alloc] initWithBidRtae:currentBidRate];
}

- (Rate *)getCurrentBidRateOfCurrencyPair:(CurrencyPair *)currencyPair
{
    if ([self.currentForexData.close.currencyPair isEqualCurrencyPair:currencyPair]) {
        return self.currentForexData.close;
    } else {
        return nil;
    }
}

- (Rate *)getCurrentAskRateOfCurrencyPair:(CurrencyPair *)currencyPair
{
    Rate *currentBidRate = [self getCurrentBidRateOfCurrencyPair:currencyPair];
    
    if (!currentBidRate) {
        return nil;
    }
    
    return [[[Rates alloc] initWithBidRtae:currentBidRate] askRate];
}

- (ForexDataChunk *)chunkForCurrencyPair:(CurrencyPair *)currencyPair timeFrame:(TimeFrame *)timeFrame Limit:(NSUInteger)limit
{
    ForexHistory *forexDatabase = [[ForexHistory alloc] initWithCurrencyPair:currencyPair timeScale:timeFrame];
    ForexDataChunk *chunk = [forexDatabase selectMaxCloseTime:self.currentTime limit:limit];
    
    [chunk complementedByTimeFrame:_completionTimeFrame currentTime:self.currentTime];
    
    return chunk;
}

- (ForexDataChunk *)chunkForCenterForexData:(ForexHistoryData *)forexData frontLimit:(NSUInteger)frontLimit backLimit:(NSUInteger)backLimit
{
    ForexHistory *forexDb = [[ForexHistory alloc] initWithCurrencyPair:forexData.currencyPair timeScale:forexData.timeScale];
    
    ForexDataChunk *chunk = [forexDb selectBaseTime:forexData.close.timestamp frontLimit:frontLimit backLimit:backLimit];
    
    [chunk maxTime:self.currentTime];
    
    if (![chunk existForexData:forexData]) {
        return nil;
    }

    if ([chunk forexDataCountFromBeginOldestForexData:forexData] < frontLimit + 1) {
        [chunk complementedByTimeFrame:_completionTimeFrame currentTime:self.currentTime];
    }
    
    return chunk;
}

/**
 ObserverにMarketの更新前、更新、更新後を通知。
*/
- (void)updateMarketFromNewCurrentData:(ForexHistoryData *)data
{
    self.currentForexData = data;
    self.currentRate = data.close;
    self.currentTime = self.currentRate.timestamp;
}

- (BOOL)didLoadLastData
{
    if (_lastData.ratesID == self.currentForexData.ratesID) {
        return YES;
    } else {
        return NO;
    }
}

@end
