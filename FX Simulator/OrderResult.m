//
//  OrderResult.m
//  FXSimulator
//
//  Created by yuu on 2015/09/05.
//
//

#import "OrderResult.h"

#import "FXSAlert.h"

@interface OrderResult ()
@property (nonatomic, readonly) BOOL isSuccess;
@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) NSString *message;
@end

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

- (void)completion:(void (^)())completion error:(void (^)())error
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
