//
//  OrderHistoryFactory.m
//  FX Simulator
//
//  Created  on 2014/12/11.
//  
//

#import "OrderHistoryFactory.h"
#import "SaveLoader.h"
#import "SaveData.h"
#import "OrderHistory.h"

@implementation OrderHistoryFactory

+(OrderHistory*)createOrderHistory
{
    SaveData *saveData = [SaveLoader load];
    
    return [[OrderHistory alloc] initWithDataSource:saveData.orderHistoryDataSource];
}

@end
