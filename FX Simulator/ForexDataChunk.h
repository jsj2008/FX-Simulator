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

@interface ForexDataChunk : NSObject
- (instancetype)initWithForexDataArray:(NSArray *)array;

/**
 最新のForexDataから順に列挙。
 @param limit 列挙する最大数。
 @param reverse YESのときは,limitで得たForexDataを、古いものから列挙。
*/
- (void)enumerateObjectsUsingBlock:(void (^)(ForexHistoryData *obj, NSUInteger idx))block limit:(NSUInteger)limit resultReverse:(BOOL)reverse;

/**
 Closeの平均レートを列挙していく、またその平均の先頭データobjも一緒に列挙する。
 残りのデータ数がterm未満だったら、そこで終了する。
 @param obj 平均をとるデータの先頭データ。
 @param average closeのterm期間の平均レート
*/
- (void)enumerateObjectsAndAverageRatesUsingBlock:(void (^)(ForexHistoryData *obj, NSUInteger idx, Rate *average))block averageTerm:(NSUInteger)term limit:(NSUInteger)limit resultReverse:(BOOL)reverse;

/**
 残りのデータ数がterm未満だったら、そこで終了する。
 */
- (void)enumerateObjectsAndAverageOHLCRatesUsingBlock:(void (^)(ForexHistoryData *obj, NSUInteger idx, Rate *averageOpen, Rate *averageHigh, Rate *averageLow, Rate *averageClose))block averageTerm:(NSUInteger)term limit:(NSUInteger)limit resultReverse:(BOOL)reverse;

//- (ForexDataChunk *)getForexDataLimit:(NSUInteger)limit;
- (ForexDataChunk *)getForexDataChunkInRange:(NSRange)range;
- (double)getMinRateLimit:(NSUInteger)limit;
- (double)getMaxRateLimit:(NSUInteger)limit;
@property (nonatomic, readonly) NSUInteger count;
@property (nonatomic, readonly) ForexHistoryData *current;
@end
