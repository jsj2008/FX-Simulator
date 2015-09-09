//
//  NormalizedOrdersFactory.h
//  FXSimulator
//
//  Created by yuu on 2015/09/05.
//
//

#import <Foundation/Foundation.h>

@class Order;

@interface NormalizedOrdersFactory : NSObject
+ (NSArray *)createNormalizedOrdersFromOrder:(Order *)order;
@end
