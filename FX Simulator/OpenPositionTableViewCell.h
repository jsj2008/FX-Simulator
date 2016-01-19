//
//  OpenPositionTableViewCell.h
//  FX Simulator
//
//  Created  on 2015/01/31.
//  
//

#import <UIKit/UIKit.h>

@class Currency;
@class OpenPosition;
@class Market;

@interface OpenPositionTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *displayOrderTypeValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *displayOrderRateValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *displayOrderLotValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *displayProfitAndLossValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *displayOrderYMDTimeValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *displayOrderHMSTimeValueLabel;
/**
 OpenPositionRecordと最新のレートによって表示するデータをセットする。損益は口座の設定通貨に変換する。
*/
//- (void)setDisplayData:(OpenPosition *)openPosition currentMarket:(Market *)market;
@end
