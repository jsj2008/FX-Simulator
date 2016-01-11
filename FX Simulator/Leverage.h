//
//  Leverage.h
//  FXSimulator
//
//  Created by yuu on 2016/01/07.
//
//

#import <Foundation/Foundation.h>

@interface Leverage : NSObject
@property (nonatomic, readonly) NSUInteger leverage;
@property (nonatomic, readonly) NSNumber *leverageNumber;
@property (nonatomic, readonly) NSString *stringValue;
- (instancetype)initWithLeverage:(NSUInteger)leverage;
- (instancetype)initWithLeverageNumber:(NSNumber *)leverageNumber;
@end
