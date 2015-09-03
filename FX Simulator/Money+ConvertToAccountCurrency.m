//
//  Money+Money_ConvertToAccountCurrency.m
//  FX Simulator
//
//  Created  on 2015/04/15.
//  
//

#import "Money+ConvertToAccountCurrency.h"

#import "CurrencyConverter.h"
#import "SaveData.h"
#import "SaveLoader.h"

@implementation Money (ConvertToAccountCurrency)

- (Money *)convertToAccountCurrency
{
    SaveData *saveData = [SaveLoader load];
    
    return [CurrencyConverter convert:self to:saveData.accountCurrency];
}

@end
