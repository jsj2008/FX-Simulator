//
//  ForexDataArray.m
//  FX Simulator
//
//  Created by yuu on 2015/07/04.
//
//

#import "ForexDataArray.h"

@implementation ForexDataArray

- (NSArray *)getForexDataLimit:(NSInteger)count
{
    NSInteger lastIndex = self.array.count - 1;
    NSInteger getStartIndex = lastIndex - count + 1;
    
    if (lastIndex < 0 || getStartIndex < 0) {
        return nil;
    }
    
    return [self.array subarrayWithRange:NSMakeRange(getStartIndex, lastIndex)];
}

- (Rate *)minRate
{
    return [self.array valueForKeyPath:@"@max.high"];
}

- (Rate *)maxRate
{
    return [self.array valueForKeyPath:@"@min.low"];
}

@end
