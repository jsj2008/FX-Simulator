//
//  Rates.h
//  FX Simulator
//
//  Created  on 2015/03/29.
//  
//

#import <Foundation/Foundation.h>

@class Rate;
@class Spread;

@interface Rates : NSObject
@property (nonatomic, readonly) Rate *bidRate;
@property (nonatomic, readonly) Rate *askRate;
-(instancetype)initWithBidRtae:(Rate *)bidRate spread:(Spread *)spread;
@end
