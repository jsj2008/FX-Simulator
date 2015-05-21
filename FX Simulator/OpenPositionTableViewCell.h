//
//  OpenPositionTableViewCell.h
//  FX Simulator
//
//  Created  on 2015/01/31.
//  
//

#import <UIKit/UIKit.h>

@class Currency;
@class OpenPositionRecord;
@class Rate;

@interface OpenPositionTableViewCell : UITableViewCell
/**
 OpenPositionRecordと最新のレートによって表示するデータをセットする。損益は口座の設定通貨に変換する。
*/
-(void)setDisplayData:(OpenPositionRecord*)record currentRate:(Rate*)rate;
/*@property (weak, nonatomic) IBOutlet UILabel *displayOrderNumberValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *displayOrderTypeValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *displayOrderRateValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *displayOrderLotValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *displayProfitAndLossValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *displayOrderTimeValueLabel;*/


/*@property (nonatomic, readwrite) NSString *displayUsersOrderNumber;
@property (nonatomic, readwrite) NSString *displayTradeType;
@property (nonatomic, readwrite) UIColor *displayTradeTypeColor;
@property (nonatomic, readwrite) NSString *displayTradeRate;
@property (nonatomic, readwrite) NSString *displayTradeLot;
//@property (nonatomic, readwrite) NSString *displayCloseUsersOrderNumber;
@property (nonatomic, readwrite) NSString *displayProfitAndLoss;
@property (nonatomic, readwrite) UIColor *displayProfitAndLossColor;
@property (nonatomic, readwrite) NSString *displayTradeYMDTime;
@property (nonatomic, readwrite) NSString *displayTradeHMSTime;*/
@end
