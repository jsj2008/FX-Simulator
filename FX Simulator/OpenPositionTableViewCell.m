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
#import "MarketTime.h"
#import "Currency.h"
#import "Money.h"
#import "Money+ConvertToAccountCurrency.h"

@interface OpenPositionTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *displayOrderNumberValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *displayOrderTypeValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *displayOrderRateValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *displayOrderLotValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *displayProfitAndLossValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *displayOrderYMDTimeValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *displayOrderHMSTimeValueLabel;
@end

@implementation OpenPositionTableViewCell  {
    /*UILabel *usersOrderNumberLabel;
    UILabel *tradeTypeLabel;
    UILabel *tradeRateLabel;
    UILabel *tradeLotLabel;
    UILabel *profitAndLossLabel;
    UILabel *tradeYMDTimeLabel;
    UILabel *tradeHMSTimeLabel;
    NSArray *labelList;*/
}

-(void)setDisplayData:(OpenPosition *)openPosition currentMarket:(Market *)market
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
        //closeUsersOrderNumberLabel = [UILabel new];
        profitAndLossLabel = [UILabel new];
        tradeYMDTimeLabel = [UILabel new];
        tradeHMSTimeLabel = [UILabel new];
        labelList = @[usersOrderNumberLabel, tradeTypeLabel, tradeRateLabel, tradeLotLabel, profitAndLossLabel, tradeYMDTimeLabel, tradeHMSTimeLabel];
        [self.contentView addSubview:usersOrderNumberLabel];
        [self.contentView addSubview:tradeTypeLabel];
        [self.contentView addSubview:tradeRateLabel];
        [self.contentView addSubview:tradeLotLabel];
        //[self.contentView addSubview:closeUsersOrderNumberLabel];
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
    
    int labelMarginLeft = 5;
    int labelWidth = self.frame.size.width / 4 - labelMarginLeft;
    int miniLabelWidth = labelWidth / 2;
    int bigLabelWidth = labelWidth + miniLabelWidth / 2;
    int labelHeight = self.frame.size.height / 2;
    int bigLabelHeight = self.frame.size.height;
    
    usersOrderNumberLabel.frame = CGRectMake(labelMarginLeft, 0, miniLabelWidth, labelHeight);
    tradeTypeLabel.frame = CGRectMake(labelMarginLeft, labelHeight, miniLabelWidth, labelHeight);
    tradeRateLabel.frame = CGRectMake(labelMarginLeft*2 + miniLabelWidth, 0, bigLabelWidth, labelHeight);
    tradeLotLabel.frame = CGRectMake(labelMarginLeft*2 + miniLabelWidth, labelHeight, bigLabelWidth, labelHeight);
    //closeUsersOrderNumberLabel.frame = CGRectMake(labelMarginLeft*3 + miniLabelWidth + bigLabelWidth, 0, bigLabelWidth, labelHeight);
    profitAndLossLabel.frame = CGRectMake(labelMarginLeft*3 + miniLabelWidth + bigLabelWidth, 0, bigLabelWidth, bigLabelHeight);
    tradeYMDTimeLabel.frame = CGRectMake(labelMarginLeft*4 + miniLabelWidth + bigLabelWidth*2, 0, labelWidth, labelHeight);
    tradeHMSTimeLabel.frame = CGRectMake(labelMarginLeft*4 + miniLabelWidth + bigLabelWidth*2, labelHeight, labelWidth, labelHeight);
    
    [labelList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UILabel *label = obj;
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor whiteColor];
    }];
    
}*/

/*- (void)awakeFromNib
{
    // Initialization code
}*

/* 
 - (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}*/

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
