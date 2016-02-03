//
//  OrderResult.m
//  FXSimulator
//
//  Created by yuu on 2015/09/05.
//
//

#import "Result.h"

#import "FXSAlert.h"

@interface Result ()
@property (nonatomic, readonly) BOOL isSuccess;
@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) NSString *message;
@end

@implementation Result

- (instancetype)initWithIsSuccess:(BOOL)isSuccess title:(NSString *)title message:(NSString *)message
{
    if (self = [super init]) {
        _isSuccess = isSuccess;
        _title = title;
        _message = message;
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
        [FXSAlert showAlertTitle:self.title message:self.message controller:controller];
    }
}

@end
