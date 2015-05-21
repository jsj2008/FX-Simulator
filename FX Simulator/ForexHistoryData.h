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

/**
 ある時間足のデータ。Open(始値),High(高値),Low(安値),Close(終値)を持つ。
*/

@interface ForexHistoryData : NSObject
-(id)initWithFMResultSet:(FMResultSet*)rs currencyPair:(CurrencyPair*)currencyPair;
/**
 ForexHistoryDataの配列から、さらに一つのForexHistoryDataを生成する。
*/
-(id)initWithForexHistoryDataArray:(NSArray*)array;
@property (nonatomic, readonly) int ratesID;
@property (nonatomic, readonly) CurrencyPair *currencyPair;
@property (nonatomic, readonly) Rate *open;
@property (nonatomic, readonly) Rate *high;
@property (nonatomic, readonly) Rate *low;
@property (nonatomic, readonly) Rate *close;
@property (nonatomic, readonly) NSString *displayOpenTimestamp;
@property (nonatomic, readonly) NSString *displayCloseTimestamp;
@end
