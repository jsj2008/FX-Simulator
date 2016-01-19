//
//  OrderHistoryTableViewCell.h
//  FX Simulator
//
//  Created  on 2014/09/19.
//  
//

#import <UIKit/UIKit.h>

@class ExecutionOrder;

@interface ExecutionHistoryTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *displayOrderTypeValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *displayOrderRateValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *displayOrderLotValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *displayProfitAndLossValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *displayOrderYMDTimeValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *displayOrderHMSTimeValueLabel;
@end
