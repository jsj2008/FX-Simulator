//
//  CandlesFactory.h
//  FX Simulator
//
//  Created  on 2014/10/30.
//  
//

#import <Foundation/Foundation.h>

@class ForexDataChunk;

@interface CandlesFactory : NSObject
+(NSArray*)createCandlesFromForexHistoryDataChunk:(ForexDataChunk*)chunk displayForexDataCount:(NSInteger)count chartViewWidth:(float)width chartViewHeight:(float)height;
@end
