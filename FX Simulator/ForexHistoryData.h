//
//  ForexHistoryData.h
//  FX Simulator
//
//  Created  on 2014/10/30.
//  
//

#import <Foundation/Foundation.h>

@class FMResultSet;
@class CurrencyPair;
@class Rate;
@class ForexDataChunk;
@class Time;
@class TimeFrame;

typedef NS_ENUM(NSUInteger, RateType) {
    Open = 1,
    High,
    Low,
    Close
};

/**
 ある時間足のデータ。Open(始値),High(高値),Low(安値),Close(終値)を持つ。
*/

@interface ForexHistoryData : NSObject

@property (nonatomic, readonly) int ratesID;
@property (nonatomic, readonly) CurrencyPair *currencyPair;
@property (nonatomic, readonly) TimeFrame *timeScale;
@property (nonatomic, readonly) Rate *open;
@property (nonatomic, readonly) Rate *high;
@property (nonatomic, readonly) Rate *low;
@property (nonatomic, readonly) Rate *close;
@property (nonatomic, readonly) Time *latestTime;
@property (nonatomic, readonly) Time *oldestTime;
@property (nonatomic, readonly) NSString *displayOpenTimestamp;
@property (nonatomic, readonly) NSString *displayCloseTimestamp;

- (instancetype)initWithFMResultSet:(FMResultSet*)rs currencyPair:(CurrencyPair*)currencyPair timeScale:(TimeFrame *)timeScale;
- (instancetype)initWithForexDataChunk:(ForexDataChunk *)chunk timeScale:(TimeFrame *)timeScale;

/**
 CloseTimeを比較する。
*/
- (NSComparisonResult)compareTime:(ForexHistoryData *)data;

- (Rate *)getRateForType:(RateType)type;
- (BOOL)isEqualToForexData:(ForexHistoryData *)data;

@end
