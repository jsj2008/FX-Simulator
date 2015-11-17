//
//  FXSComparisonResult.m
//  FXSimulator
//
//  Created by yuu on 2015/11/14.
//
//

#import "FXSComparisonResult.h"

@implementation FXSComparisonResult

- (instancetype)initWithComparisonResult:(NSComparisonResult)result
{
    if (self = [super init]) {
        _result = result;
    }
    
    return self;
}

@end
