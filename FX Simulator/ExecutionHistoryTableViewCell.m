//
//  OrderHistoryTableViewCell.m
//  FX Simulator
//
//  Created  on 2014/09/19.
//  
//

#import "ExecutionHistoryTableViewCell.h"

#import "ForexHistoryData.h"
#import "ExecutionOrder.h"
#import "OrderType.h"
#import "Rate.h"
#import "PositionSize.h"
#import "Lot.h"
#import "MarketTime.h"
#import "Currency.h"
#import "Money.h"
#import "Money+ConvertToAccountCurrency.h"

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

@implementation ExecutionHistoryTableViewCell {
    /*UILabel *usersOrderNumberLabel;
    UILabel *tradeTypeLabel;
    UILabel *tradeRateLabel;
    UILabel *tradeLotLabel;
    UILabel *closeUsersOrderNumberLabel;
    UILabel *profitAndLossLabel;
    UILabel *tradeYMDTimeLabel;
    UILabel *tradeHMSTimeLabel;
    NSArray *labelList;*/
}

/*- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        // Initialization code
        //UITableViewCell *a = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        //self.backgroundColor = [UIColor blackColor];
        usersOrderNumberLabel = [UILabel new];
        tradeTypeLabel = [UILabel new];
        tradeRateLabel = [UILabel new];
        tradeLotLabel = [UILabel new];
        closeUsersOrderNumberLabel = [UILabel new];
        profitAndLossLabel = [UILabel new];
        tradeYMDTimeLabel = [UILabel new];
        tradeHMSTimeLabel = [UILabel new];
        labelList = @[usersOrderNumberLabel, tradeTypeLabel, tradeRateLabel, tradeLotLabel, closeUsersOrderNumberLabel, profitAndLossLabel, tradeYMDTimeLabel, tradeHMSTimeLabel];
        [self.contentView addSubview:usersOrderNumberLabel];
        [self.contentView addSubview:tradeTypeLabel];
        [self.contentView addSubview:tradeRateLabel];
        [self.contentView addSubview:tradeLotLabel];
        [self.contentView addSubview:closeUsersOrderNumberLabel];
        [self.contentView addSubview:profitAndLossLabel];
        [self.contentView addSubview:tradeYMDTimeLabel];
        [self.contentView addSubview:tradeHMSTimeLabel];
    }
    
    return self;
}*/

/*-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.backgroundColor = [UIColor blackColor];
    
    float labelMarginLeft = 5;
    float labelWidth = self.frame.size.width / 4 - labelMarginLeft;
    float miniLabelWidth = labelWidth / 2;
    float bigLabelWidth = labelWidth + miniLabelWidth / 2;
    float labelHeight = self.frame.size.height / 2;
    
    usersOrderNumberLabel.frame = CGRectMake(labelMarginLeft, 0, miniLabelWidth, labelHeight);
    tradeTypeLabel.frame = CGRectMake(labelMarginLeft, labelHeight, miniLabelWidth, labelHeight);
    tradeRateLabel.frame = CGRectMake(labelMarginLeft*2 + miniLabelWidth, 0, bigLabelWidth, labelHeight);
    tradeLotLabel.frame = CGRectMake(labelMarginLeft*2 + miniLabelWidth, labelHeight, bigLabelWidth, labelHeight);
    closeUsersOrderNumberLabel.frame = CGRectMake(labelMarginLeft*3 + miniLabelWidth + bigLabelWidth, 0, bigLabelWidth, labelHeight);
    profitAndLossLabel.frame = CGRectMake(labelMarginLeft*3 + miniLabelWidth + bigLabelWidth, labelHeight, bigLabelWidth, labelHeight);
    tradeYMDTimeLabel.frame = CGRectMake(labelMarginLeft*4 + miniLabelWidth + bigLabelWidth*2, 0, labelWidth, labelHeight);
    tradeHMSTimeLabel.frame = CGRectMake(labelMarginLeft*4 + miniLabelWidth + bigLabelWidth*2, labelHeight, labelWidth, labelHeight);
    
    [labelList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UILabel *label = obj;
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor whiteColor];
    }];
 
}*/

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDisplayData:(ExecutionOrder *)record
{
    self.displayUsersOrderNumberValueLabel.text = @(record.orderHistoryId).stringValue;
    
    self.displayOrderTypeValueLabel.text = record.orderType.toDisplayString;
    
    self.displayOrderRateValueLabel.text = [record.orderRate toDisplayString];
    
    self.displayOrderLotValueLabel.text = [[record.positionSize toLot] toDisplayString];
    
    //self.displayCloseUsersOrderNumberValueLabel.text = record.closeUsersOrderNumber.stringValue;
    
    //Money *displayProfitAndLoss = [record.profitAndLoss convertToAccountCurrency];
    //self.displayProfitAndLossValueLabel.text = [displayProfitAndLoss toDisplayString];
    //self.displayProfitAndLossValueLabel.textColor;
    
    self.displayOrderYMDTimeValueLabel.text = [record.orderRate.timestamp toDisplayYMDString];
    
    self.displayOrderHMSTimeValueLabel.text = [record.orderRate.timestamp toDisplayHMSString];
}

/*-(void)setDisplayUsersOrderNumber:(NSString *)displayUsersOrderNumber
{
    usersOrderNumberLabel.text = displayUsersOrderNumber;
}

-(void)setDisplayTradeType:(NSString *)displayTradeType
{
    tradeTypeLabel.text = displayTradeType;
}

-(void)setDisplayTradeTypeColor:(UIColor *)displayTradeTypeColor
{
    tradeTypeLabel.textColor = displayTradeTypeColor;
}

-(void)setDisplayTradeRate:(NSString *)displayTradeRate
{
    tradeRateLabel.text = displayTradeRate;
}

-(void)setDisplayTradeLot:(NSString *)displayTradeLot
{
    tradeLotLabel.text = displayTradeLot;
}

-(void)setDisplayCloseUsersOrderNumber:(NSString *)displayCloseUsersOrderNumber
{
    closeUsersOrderNumberLabel.text = displayCloseUsersOrderNumber;
}

-(void)setDisplayProfitAndLoss:(NSString *)displayProfitAndLoss
{
    profitAndLossLabel.text = displayProfitAndLoss;
}

-(void)setDisplayProfitAndLossColor:(UIColor *)displayProfitAndLossColor
{
    profitAndLossLabel.textColor = displayProfitAndLossColor;
}

-(void)setDisplayTradeYMDTime:(NSString *)displayTradeYMDTime
{
    tradeYMDTimeLabel.text = displayTradeYMDTime;
}

-(void)setDisplayTradeHMSTime:(NSString *)displayTradeHMSTime
{
    tradeHMSTimeLabel.text = displayTradeHMSTime;
}*/

@end
