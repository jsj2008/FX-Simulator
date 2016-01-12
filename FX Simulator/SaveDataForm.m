//
//  SaveDataForm.m
//  FXSimulator
//
//  Created by yuu on 2015/11/14.
//
//

#import "SaveDataForm.h"

#import "Money.h"
#import "SaveData.h"
#import "Spread.h"

@implementation SaveDataForm

- (SaveData *)createSaveData
{
    SaveData *saveData = [SaveData createDefaultNewSaveData];
    
    saveData.currencyPair = self.currencyPair;
    saveData.timeFrame = self.timeFrame;
    saveData.startTime = self.startTime;
    saveData.accountCurrency = self.accountCurrency;
    saveData.spread = [[Spread alloc] initWithPips:self.spread.spreadValue currencyPair:self.currencyPair];
    saveData.startBalance = [[Money alloc] initWithAmount:self.startBalance.amount currency:self.accountCurrency];
    saveData.positionSizeOfLot = self.positionSizeOfLot;
    saveData.leverage = self.leverage;
    
    saveData.tradePositionSize = saveData.positionSizeOfLot;
    
    return saveData;
}

@end
