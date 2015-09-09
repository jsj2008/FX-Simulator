//
//  NormalizedOrdersFactory.m
//  FXSimulator
//
//  Created by yuu on 2015/09/05.
//
//

#import "NormalizedOrdersFactory.h"

#import "OrdersCreateMode.h"
#import "OrdersCreateModeFactory.h"

@implementation NormalizedOrdersFactory

+ (NSArray *)createNormalizedOrdersFromOrder:(Order *)order
{
    OrdersCreateMode *createMode = [OrdersCreateModeFactory createModeFromOrder:order];
    
    return [createMode create:order];
}

@end
