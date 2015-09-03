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
- (void)setDisplayData:(ExecutionOrder *)order;
@end
