//
//  ForexDataArray.h
//  FX Simulator
//
//  Created by yuu on 2015/07/04.
//
//

#import <Foundation/Foundation.h>

@class ForexHistoryData;
@class Rate;


/**
 連続するForexDataの集合を管理する。
*/
@interface ForexDataChunk : NSObject
- (instancetype)initWithForexDataArray:(NSArray *)array;

/**
 最新のForexDataから順に列挙。
 @param limit 列挙する最大数。
 @param reverse YESのときは,limitで得たForexDataを、古いものから列挙。
*/
- (void)enumerateObjectsUsingBlock:(void (^)(ForexHistoryData *obj, NSUInteger idx))block limit:(NSUInteger)limit resultReverse:(BOOL)reverse;

/**
 最新の平均レート(Close)から順に列挙。
 Closeの平均レートを列挙していく、またその平均の先頭データobjも一緒に列挙する。
 残りのデータ数がterm未満だったら、そこで終了する。
 @param obj 平均をとるデータの先頭データ。
 @param average closeのterm期間の平均レート
*/
- (void)enumerateObjectsAndAverageRatesUsingBlock:(void (^)(ForexHistoryData *obj, NSUInteger idx, Rate *average))block averageTerm:(NSUInteger)term limit:(NSUInteger)limit resultReverse:(BOOL)reverse;

/**
 最新の平均レート(Open, High, Low, Close)から順に列挙。
 残りのデータ数がterm未満だったら、そこで終了する。
 */
- (void)enumerateObjectsAndAverageOHLCRatesUsingBlock:(void (^)(ForexHistoryData *obj, NSUInteger idx, Rate *averageOpen, Rate *averageHigh, Rate *averageLow, Rate *averageClose))block averageTerm:(NSUInteger)term limit:(NSUInteger)limit resultReverse:(BOOL)reverse;

//- (ForexDataChunk *)getForexDataLimit:(NSUInteger)limit;
- (ForexDataChunk *)getForexDataChunkInRange:(NSRange)range;
- (Rate *)getMinRate;
- (Rate *)getMaxRate;
- (Rate *)getMinRateLimit:(NSUInteger)limit;
- (Rate *)getMaxRateLimit:(NSUInteger)limit;

/**
 基準となるデータからの相対位置にあるデータを先頭に、最大Limit個のデータを取得する。
*/
- (ForexDataChunk *)getChunkFromBaseData:(ForexHistoryData *)data relativePosition:(NSInteger)pos limit:(NSUInteger)limit;

/**
 最新のデータを先頭に追加する。
*/
- (void)addCurrentData:(ForexHistoryData *)data;
/*- (ForexDataChunk *)getChunkFromHeadData:(ForexHistoryData *)data limit:(NSUInteger)limit;
- (ForexDataChunk *)getChunkFromHeadData:(ForexHistoryData *)data back:(NSUInteger)back limit:(NSUInteger)limit;
- (ForexDataChunk *)getChunkFromNextDataOf:(ForexHistoryData *)data limit:(NSUInteger)limit;*/
@property (nonatomic, readonly) NSUInteger count;
@property (nonatomic, readonly) ForexHistoryData *current;
@property (nonatomic, readonly) ForexHistoryData *oldest;
@end
