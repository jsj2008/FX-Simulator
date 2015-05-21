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
//#import "TradeDbDataSource.h"
#import "OpenPosition.h"

//#import "OpenPositionMock.h"

@implementation OpenPositionFactory

+(OpenPosition*)createOpenPosition
{
    SaveData *saveData = [SaveLoader load];
    
    OpenPosition *openPosition = [[OpenPosition alloc] initWithDataSource:saveData.openPositionDataSource AccountCurrency:saveData.accountCurrency];
    
    return openPosition;
    
    //return [[OpenPosition alloc] initWithDataSource:saveData.openPositionDataSource];
    //return [OpenPositionMock new];
}

@end
