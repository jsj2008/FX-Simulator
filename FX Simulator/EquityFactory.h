//
//  EquityFactory.h
//  FX Simulator
//
//  Created  on 2014/12/18.
//  
//

#import <Foundation/Foundation.h>

@class Equity;

@interface EquityFactory : NSObject
+(Equity*)createEquity;
@end
