//
//  ForexData.h
//  ForexGame
//
//  Created  on 2014/03/23.
//  
//

#import <Foundation/Foundation.h>

@class MarketTime;
@class MarketTimeScale;
@class ForexDataChunk;
@class ForexHistoryData;
@class CurrencyPair;

/**
 通貨データを検索できる。一部キャッシュを持つ。
 キャッシュを持つメソッドだけ別クラスにして、このクラスのメソッドはクラスメソッドにするか。
*/

@interface ForexHistory : NSObject
-(id)initWithCurrencyPair:(CurrencyPair*)currencyPair timeScale:(MarketTimeScale*)timeScale;
- (ForexDataChunk *)selectCenterData:(ForexHistoryData *)data sideLimit:(NSUInteger)limit;
- (ForexDataChunk *)selectMaxRowid:(int)rowid limit:(int)limit;
-(NSArray*)selectMaxCloseTimestamp:(int)timestamp limit:(int)num;
-(NSArray*)selectMaxCloseTimestamp:(int)maxTimestamp minOpenTimestamp:(int)minTimestamp;
-(ForexHistoryData*)selectRowidLimitCloseTimestamp:(MarketTime*)maxTimestamp;
-(ForexHistoryData*)selectOpenTimestamp:(int)timestamp;
-(int)selectCloseTimestampFromRowid:(int)rowid;
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
