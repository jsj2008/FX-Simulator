//
//  SimulationStateResult.m
//  FXSimulator
//
//  Created by yuu on 2015/09/10.
//
//

#import "SimulationStateResult.h"

@implementation SimulationStateResult

- (instancetype)initWithIsStop:(BOOL)isStop title:(NSString *)title message:(NSString *)message
{
    if (self = [super init]) {
        _isStop = isStop;
        _title = title;
        _message = message;
    }
    
    return self;
}

@end
