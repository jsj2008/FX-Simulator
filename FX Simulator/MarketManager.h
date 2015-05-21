//
//  MarketLoader.h
//  FX Simulator
//
//  Created  on 2014/11/13.
//  
//

#import <Foundation/Foundation.h>

@class Market;

@interface MarketManager : NSObject
+(Market*)sharedMarket;
@end
