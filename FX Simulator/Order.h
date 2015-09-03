//
//  Order.h
//  FX Simulator
//
//  Created  on 2014/11/23.
//  
//

#import "OrderBase.h"

@import UIKit;

@class FMResultSet;
@class OpenPosition;

@interface Order : PositionBase

@property (nonatomic, readonly) NSUInteger orderId;
@property (nonatomic, weak) UIViewController *alertTargetController;

- (instancetype)initWithFMResultSet:(FMResultSet *)resultSet;

/**
 単純なコピー
*/
- (instancetype)copyOrderNewPositionSize:(PositionSize *)positionSize;

- (void)execute;

@end
