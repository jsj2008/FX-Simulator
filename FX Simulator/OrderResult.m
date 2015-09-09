//
//  OrderResult.m
//  FXSimulator
//
//  Created by yuu on 2015/09/05.
//
//

#import "OrderResult.h"

@implementation OrderResult

- (instancetype)initWithIsSuccess:(BOOL)isSuccess title:(NSString *)title message:(NSString *)message
{
    if (self = [super init]) {
        _isSuccess = isSuccess;
        _title = title;
        _message = message;
    }
    
    return self;
}

@end
