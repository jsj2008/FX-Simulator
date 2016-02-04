//
//  OpenPositionTableViewCell.m
//  FX Simulator
//
//  Created  on 2015/01/31.
//  
//

#import "OpenPositionTableViewCell.h"

#import "ForexHistoryData.h"
#import "OpenPosition.h"
#import "PositionType.h"
#import "Rate.h"
#import "PositionSize.h"
#import "Lot.h"
#import "Time.h"
#import "Currency.h"
#import "Money.h"
#import "Money+ConvertToAccountCurrency.h"

@implementation OpenPositionTableViewCell

/*-(void)setDisplayData:(OpenPosition *)openPosition currentMarket:(Market *)market
{
    self.displayOrderNumberValueLabel.text = @(openPosition.orderId).stringValue;
    
    self.displayOrderTypeValueLabel.text = openPosition.positionType.toDisplayString;
    
    self.displayOrderRateValueLabel.text = [openPosition.rate toDisplayString];
    
    self.displayOrderLotValueLabel.text = [[openPosition.positionSize toLot] toDisplayString];
    
    Money *displayProfitAndLoss = [[openPosition profitAndLossFromMarket:market] convertToAccountCurrency];
    self.displayProfitAndLossValueLabel.text = [displayProfitAndLoss toDisplayString];
    //self.displayProfitAndLossValueLabel.textColor;
    
    self.displayOrderYMDTimeValueLabel.text = [openPosition.rate.timestamp toDisplayYMDString];
    
    self.displayOrderHMSTimeValueLabel.text = [openPosition.rate.timestamp toDisplayHMSString];
}*/

/*- (void)awakeFromNib
{
    // Initialization code
}*/

/* 
 - (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}*/

@end
