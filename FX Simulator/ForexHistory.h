//
//  ForexData.h
//  ForexGame
//
//  Created  on 2014/03/23.
//  
//

#import <Foundation/Foundation.h>

@class MarketTime;
@class TimeFrame;
@class ForexDataChunk;
@class ForexHistoryData;
@class CurrencyPair;

/**
 通貨データを検索できる。一部キャッシュを持つ。
 キャッシュを持つメソッドだけ別クラスにして、このクラスのメソッドはクラスメソッドにするか。
*/

@interface ForexHistory : NSObject

-(id)initWithCurrencyPair:(CurrencyPair*)currencyPair timeScale:(TimeFrame*)timeScale;

/**
 基準となる時間(Close Time)を中心に、前後のLimitに基づきデータを取得する。
 @param time 基準となる時間
*/
- (ForexDataChunk *)selectBaseTime:(MarketTime *)time frontLimit:(NSUInteger)frontLimit backLimit:(NSUInteger)backLimit;

- (ForexDataChunk *)selectMaxRowid:(int)rowid limit:(int)limit;

/**
 closeレートの時間が、CloseTimeと同じデータを取得する。
*/
-(ForexHistoryData *)selectCloseTime:(MarketTime *)closeTime;

/**
 closeTime以下の時間をlimit個、最新のデータから取得する。
*/
-(NSArray*)selectMaxCloseTime:(MarketTime *)closeTime limit:(NSUInteger)limit;

/**
 closeTime以下の時間で、oldCloseTime時間より新しいデータを、新しい順に取得する。
*/
- (ForexDataChunk *)selectMaxCloseTime:(MarketTime *)closeTime newerThan:(MarketTime *)oldCloseTime;

/**
 その通貨と時間軸のテーブルの始値の最初の時間。
 */
-(MarketTime*)minOpenTime;

/**
 その通貨と時間軸のテーブルの始値の最終の時間。
 */
-(MarketTime*)maxOpenTime;

-(ForexHistoryData*)lastRecord;

@end
