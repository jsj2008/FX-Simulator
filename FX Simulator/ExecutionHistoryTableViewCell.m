//
//  OrderHistoryTableViewCell.m
//  FX Simulator
//
//  Created  on 2014/09/19.
//  
//

#import "ExecutionHistoryTableViewCell.h"

#import "Currency.h"
#import "ExecutionOrder.h"
#import "ForexHistoryData.h"
#import "Time.h"
#import "Lot.h"
#import "Money.h"
#import "Money+ConvertToAccountCurrency.h"
#import "PositionType.h"
#import "Rate.h"
#import "PositionSize.h"

@interface ExecutionHistoryTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *displayUsersOrderNumberValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *displayOrderTypeValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *displayOrderRateValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *displayOrderLotValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *displayCloseUsersOrderNumberValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *displayProfitAndLossValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *displayOrderYMDTimeValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *displayOrderHMSTimeValueLabel;
@end

@implementation ExecutionHistoryTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDisplayData:(ExecutionOrder *)order
{
    self.displayUsersOrderNumberValueLabel.text = @(order.orderId).stringValue;
    
    self.displayOrderTypeValueLabel.text = order.positionType.toDisplayString;
    
    self.displayOrderRateValueLabel.text = [order.rate toDisplayString];
    
    self.displayOrderLotValueLabel.text = [[order.positionSize toLot] toDisplayString];
    
    self.displayCloseUsersOrderNumberValueLabel.text = @(order.closeTargetOrderId).stringValue;
    
    Money *displayProfitAndLoss = [order.profitAndLoss convertToAccountCurrency];
    self.displayProfitAndLossValueLabel.text = [displayProfitAndLoss toDisplayString];
    self.displayProfitAndLossValueLabel.textColor = [displayProfitAndLoss toDisplayColor];
    
    self.displayOrderYMDTimeValueLabel.text = [order.rate.timestamp toDisplayYMDString];
    
    self.displayOrderHMSTimeValueLabel.text = [order.rate.timestamp toDisplayHMSString];
}

@end
