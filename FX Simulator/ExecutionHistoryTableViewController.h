//
//  OrderHistoryTableViewController.h
//  FX Simulator
//
//  Created  on 2014/09/18.
//  
//

#import <UIKit/UIKit.h>
#import "NewStartViewController.h"

@interface ExecutionHistoryTableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, NewStartViewControllerDelegate>
- (void)updatedSaveData;
@end
