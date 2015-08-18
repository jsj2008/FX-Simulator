//
//  OpenPositionModelFactory.m
//  FX Simulator
//
//  Created  on 2014/09/09.
//  
//

#import "OpenPositionFactory.h"

#import "SaveLoader.h"
#import "SaveData.h"
#import "OpenPosition.h"


@implementation OpenPositionFactory

+(OpenPosition*)createOpenPosition
{
    SaveData *saveData = [SaveLoader load];
    
    return saveData.openPosition;
}

@end
