//
//  MarketTimeScale.h
//  FX Simulator
//
//  Created  on 2014/12/02.
//  
//

#import <Foundation/Foundation.h>

@interface TimeFrame : NSObject <NSCoding>
@property (nonatomic, readonly) NSUInteger minute;
@property (nonatomic, readonly) NSNumber *minuteValueObj;
- (instancetype)initWithMinute:(NSUInteger)minute;
- (NSComparisonResult)compareTimeFrame:(TimeFrame *)timeFrame;
- (BOOL)isEqualToTimeFrame:(TimeFrame *)timeFrame;
- (NSString *)toDisplayString;
@end
