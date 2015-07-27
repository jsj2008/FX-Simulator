//
//  MarketTimeScale.h
//  FX Simulator
//
//  Created  on 2014/12/02.
//  
//

#import <Foundation/Foundation.h>

@interface TimeFrame : NSObject
-(id)initWithMinute:(int)minute;
- (NSComparisonResult)compare:(TimeFrame *)timeFrame;
- (BOOL)isEqualToTimeFrame:(TimeFrame *)timeFrame;
-(NSString*)toDisplayString;
@property (nonatomic, readonly) int minute;
@property (nonatomic, readonly) NSNumber *minuteValueObj;
@end
