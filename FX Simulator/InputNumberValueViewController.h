//
//  InputNumberValueViewController.h
//  FXSimulator
//
//  Created by yuu on 2015/09/16.
//
//

#import <UIKit/UIKit.h>

typedef void (^SetInputNumberValueBlock)(NSNumber *inputNumberValue);

@interface InputNumberValueViewController : UIViewController
@property (nonatomic) NSNumber *defaultNumberValue;
@property (nonatomic) NSNumber *minNumberValue;
@property (nonatomic) NSNumber *maxNumberValue;
@property (nonatomic, copy) SetInputNumberValueBlock setInputNumberValue;
@end
