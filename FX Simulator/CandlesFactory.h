//
//  CandlesFactory.h
//  FX Simulator
//
//  Created  on 2014/10/30.
//  
//

#import <Foundation/Foundation.h>

@interface CandlesFactory : NSObject
+(NSArray*)createCandlesFromForexHistoryDataArray:(NSArray*)forexHistoryDataArray chartViewWidth:(float)width chartViewHeight:(float)height;
@end
