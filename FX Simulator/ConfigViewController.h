//
//  ConfigViewController.h
//  FX Simulator
//
//  Created  on 2014/10/30.
//  
//

#import <UIKit/UIKit.h>

@protocol ConfigViewControllerDelegate <NSObject>
@property (nonatomic, readwrite) NSNumber *autoUpdateInterval;
@end

@interface ConfigViewController : UITableViewController <ConfigViewControllerDelegate>
@property (nonatomic, readwrite) NSNumber *autoUpdateInterval;
@end
