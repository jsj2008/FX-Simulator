//
//  ForexDataArray.h
//  FX Simulator
//
//  Created by yuu on 2015/07/04.
//
//

#import <Foundation/Foundation.h>

@class Rate;

@interface ForexDataArray : NSObject
- (NSArray *)getForexDataLimit:(NSInteger)count;
- (Rate *)minRate;
- (Rate *)maxRate;
@property (nonatomic) NSArray *array;
@end
