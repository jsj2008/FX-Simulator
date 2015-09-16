//
//  SelectCurrencyPairViewController.h
//  FX Simulator
//
//  Created  on 2015/04/26.
//  
//

#import <UIKit/UIKit.h>

typedef void (^SetDataBlock)(id selectData);

@interface CheckmarkViewController : UITableViewController
@property (nonatomic) NSArray *dataList;
@property (nonatomic) NSArray *dataStringValueList;
@property (nonatomic) id defaultData;
@property (nonatomic, copy) SetDataBlock setData;
@end
