//
//  OpenPositionManagerFactory.h
//  FX Simulator
//
//  Created  on 2014/12/11.
//  
//

#import <Foundation/Foundation.h>

@class OpenPositionManager;

@interface OpenPositionManagerFactory : NSObject
+(OpenPositionManager*)createOpenPositionManager;
@end
