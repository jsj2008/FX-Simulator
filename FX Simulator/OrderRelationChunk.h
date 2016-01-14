//
//  OrderRelationChunk.h
//  FXSimulator
//
//  Created by yuu on 2016/01/14.
//
//

#import <Foundation/Foundation.h>

@interface OrderRelationChunk : NSObject
- (instancetype)initWithSaveSlot:(NSUInteger)slot;
- (void)delete;
@end
