//
//  EquityFactory.m
//  FX Simulator
//
//  Created  on 2014/12/18.
//  
//

#import "EquityFactory.h"

#import "SaveLoader.h"
#import "SaveData.h"
#import "Money.h"
#import "ExecutionHistory.h"
#import "Balance.h"
#import "Equity.h"

@implementation EquityFactory

+(Equity*)createEquity
{
    SaveData *saveData = [SaveLoader load];
    
    Money *startBalance = saveData.startBalance;
    
    ExecutionHistory *executionHistory = [ExecutionHistory loadExecutionHistory];
    
    Balance *balance = [[Balance alloc] initWithStartBalance:startBalance ExecutionHistory:executionHistory];
    
    return [[Equity alloc] initWithBalance:balance];
}

@end
