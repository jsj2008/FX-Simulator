//
//  ExecutionOrdersCreateMode.h
//  FX Simulator
//
//  Created  on 2014/11/22.
//  
//

#import <Foundation/Foundation.h>

@class OpenPosition;
@class Order;

@interface ExecutionOrdersCreateMode : NSObject
@property (nonatomic, readonly) OpenPosition *openPosition;
- (instancetype)initWithOpenPosition:(OpenPosition *)openPosition;
- (NSArray *)create:(Order *)order __attribute__((objc_requires_super));
@end
