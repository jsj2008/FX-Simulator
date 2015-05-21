//
//  OpenPositionModelFactory.h
//  FX Simulator
//
//  Created  on 2014/09/09.
//  
//

#import <Foundation/Foundation.h>

@class OpenPosition;

@interface OpenPositionFactory : NSObject
+(OpenPosition*)createOpenPosition;
@end
