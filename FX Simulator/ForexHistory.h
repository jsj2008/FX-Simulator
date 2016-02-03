//
//  ForexData.h
//  ForexGame
//
//  Created  on 2014/03/23.
//  
//

#import <Foundation/Foundation.h>

@class Time;
@class TimeFrame;
@class ForexDataChunk;
@class ForexHistoryData;
@class CurrencyPair;

@interface ForexHistory : NSObject

- (instancetype)initWithCurrencyPair:(CurrencyPair *)currencyPair timeScale:(TimeFrame *)timeScale;

- (BOOL)existsDataSource;

- (ForexHistoryData *)nextDataOfTime:(Time *)time;

/**
 基準となる時間(Close Time)を中心に、前後のLimitに基づきデータを取得する。
 baseTimeが存在しない時は、そのbaseTimeの次のtimeのデータをbaseDataとする。
 @param time 基準となる時間
*/
- (ForexDataChunk *)selectBaseTime:(Time *)time frontLimit:(NSUInteger)frontLimit backLimit:(NSUInteger)backLimit;

/**
 closeTime以下の時間をlimit個、最新のデータから取得する。
*/
- (ForexDataChunk *)selectMaxCloseTime:(Time *)closeTime limit:(NSUInteger)limit;

/**
 closeTime以下の時間で、oldCloseTime時間より新しいデータを、新しい順に取得する。
*/
- (ForexDataChunk *)selectMaxCloseTime:(Time *)closeTime newerThan:(Time *)oldCloseTime;

/**
 その通貨と時間軸のテーブルの始値の最初の時間。
 */
- (Time *)minOpenTime;

/**
 その通貨と時間軸のテーブルの始値の最終の時間。
 */
- (Time *)maxOpenTime;

- (ForexHistoryData *)newestData;

@end
