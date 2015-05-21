//
//  OrderHistoryTableViewCell.h
//  FX Simulator
//
//  Created  on 2014/09/19.
//  
//

#import <UIKit/UIKit.h>

@class ExecutionHistoryRecord;

@interface ExecutionHistoryTableViewCell : UITableViewCell
-(void)setDisplayData:(ExecutionHistoryRecord*)record;
/*@property (weak, nonatomic) IBOutlet UILabel *displayUsersOrderNumberValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *displayOrderTypeValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *displayOrderRateValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *displayOrderLotValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *displayCloseUsersOrderNumberValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *displayProfitAndLossValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *displayOrderTimeValueLabel;*/

/*@property (nonatomic, readwrite) NSString *displayUsersOrderNumber;
@property (nonatomic, readwrite) NSString *displayTradeType;
@property (nonatomic, readwrite) UIColor *displayTradeTypeColor;
@property (nonatomic, readwrite) NSString *displayTradeRate;
@property (nonatomic, readwrite) NSString *displayTradeLot;
@property (nonatomic, readwrite) NSString *displayCloseUsersOrderNumber;
@property (nonatomic, readwrite) NSString *displayProfitAndLoss;
@property (nonatomic, readwrite) UIColor *displayProfitAndLossColor;
@property (nonatomic, readwrite) NSString *displayTradeYMDTime;
@property (nonatomic, readwrite) NSString *displayTradeHMSTime;*/
@end
