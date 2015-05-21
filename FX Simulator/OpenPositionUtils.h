//
//  OpenPositionUtils.h
//  FX Simulator
//
//  Created  on 2014/11/22.
//  
//

#import <Foundation/Foundation.h>

@class PositionSize;

@interface OpenPositionUtils : NSObject
+(NSArray*)selectLimitPositionSize:(PositionSize*)positionSize fromOpenPositionRecords:(NSArray*)records;
@end
