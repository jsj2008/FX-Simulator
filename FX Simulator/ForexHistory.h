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
@class ForexHistoryData;
@class CurrencyPair;

/**
 通貨データを検索できる。一部キャッシュを持つ。
 キャッシュを持つメソッドだけ別クラスにして、このクラスのメソッドはクラスメソッドにするか。
*/

@interface ForexHistory : NSObject
-(id)initWithCurrencyPair:(CurrencyPair*)currencyPair timeScale:(MarketTimeScale*)timeScale;
-(NSArray*)selectMaxRowid:(int)rowid limit:(int)limit;
-(NSArray*)selectMaxCloseTimestamp:(int)timestamp limit:(int)num;
-(NSArray*)selectMaxCloseTimestamp:(int)maxTimestamp minOpenTimestamp:(int)minTimestamp;
-(ForexHistoryData*)selectRowidLimitCloseTimestamp:(MarketTime*)maxTimestamp;
-(ForexHistoryData*)selectOpenTimestamp:(int)timestamp;
-(int)selectCloseTimestampFromRowid:(int)rowid;
/**
 その通貨と時間軸でシュミレーションを始めることができる最小の時間。手動で設定してあるが、データベースから生成する。例 2010年1月1日
 */
-(MarketTime*)minimumSimulationStartTime;
/**
 その通貨と時間軸でシュミレーションを始めることができる最大の時間。手動で設定してあるが、データベースから生成する。例 2015年1月1日
 */
-(MarketTime*)maximumSimulationStartTime;
@end
