//
//  OrderResult.m
//  FXSimulator
//
//  Created by yuu on 2015/09/05.
//
//

#import "Result.h"

#import "FXSAlert.h"
#import "Message.h"

@interface Result ()
@property (nonatomic, readonly) BOOL isSuccess;
@end

@implementation Result {
    Message *_message;
}

- (instancetype)initWithIsSuccess:(BOOL)isSuccess title:(NSString *)title message:(NSString *)message
{
    if (self = [super init]) {
        _isSuccess = isSuccess;
        _message = [[Message alloc] initWithTitle:title message:message];
    }
    
    return self;
}

- (void)success:(void (^)())completion failure:(void (^)())error
{
    if (self.isSuccess) {
        if (completion) {
            completion();
        }
    } else {
        if (error) {
            error();
        }
    }
}

- (void)showAlertToController:(UIViewController *)controller
{
    if (!self.isSuccess) {
        [_message showAlertToController:controller];
    }
}

@end
