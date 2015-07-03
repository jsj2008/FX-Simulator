//
//  ConfigViewController.h
//  FX Simulator
//
//  Created  on 2014/10/30.
//  
//

#import <UIKit/UIKit.h>
#import "NewStartViewController.h"
#import "SetAutoUpdateIntervalViewController.h"


@interface ConfigViewController : UITableViewController <NewStartViewControllerDelegate, SetAutoUpdateIntervalViewControllerDelegate>
-(void)updatedSaveData;
@property (nonatomic, readwrite) NSNumber *autoUpdateInterval;
@end
