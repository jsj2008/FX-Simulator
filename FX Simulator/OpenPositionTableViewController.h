//
//  PortfolioViewController.h
//  FX Simulator
//
//  Created  on 2014/10/30.
//  
//

#import "NewStartViewController.h"

@interface OpenPositionTableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, NewStartViewControllerDelegate>
-(void)reloadSaveData;
@end
