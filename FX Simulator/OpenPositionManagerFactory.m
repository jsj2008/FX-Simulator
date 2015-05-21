//
//  OpenPositionManagerFactory.m
//  FX Simulator
//
//  Created  on 2014/12/11.
//  
//

#import "OpenPositionManagerFactory.h"
#import "SaveLoader.h"
#import "SaveData.h"
#import "OpenPositionManager.h"

@implementation OpenPositionManagerFactory

+(OpenPositionManager*)createOpenPositionManager
{
    SaveData *saveData = [SaveLoader load];
    
    return [[OpenPositionManager alloc] initWithDataSource:saveData.openPositionDataSource];
}

@end
