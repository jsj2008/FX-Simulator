//
//  NormalizedOrdersFactory.h
//  FXSimulator
//
//  Created by yuu on 2015/09/05.
//
//

#import <Foundation/Foundation.h>

@class OpenPositionRelationChunk;
@class Order;

@interface NormalizedOrdersFactory : NSObject
- (instancetype)initWithOpenPositions:(OpenPositionRelationChunk *)openPositions;
- (NSArray *)createNormalizedOrdersFromOrder:(Order *)order;
@end
