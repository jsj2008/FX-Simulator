//
//  MarketTimeScale.h
//  FX Simulator
//
//  Created  on 2014/12/02.
//  
//

#import <Foundation/Foundation.h>

@interface MarketTimeScale : NSObject
-(id)initWithMinute:(int)minute;
- (BOOL)isEqualToTimeScale:(MarketTimeScale *)timeScale;
-(NSString*)toDisplayString;
@property (nonatomic, readonly) int minute;
@property (nonatomic, readonly) NSNumber *minuteValueObj;
@end
