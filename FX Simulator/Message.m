//
//  Message.m
//  FXSimulator
//
//  Created by yuu on 2016/02/04.
//
//

#import "Message.h"

#import "FXSAlert.h"

@implementation Message {
    NSString *_title;
    NSString *_message;
}

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message
{
    if (self = [super init]) {
        _title = title;
        _message = message;
    }
    
    return self;
}

- (void)showAlertToController:(UIViewController *)controller
{
    [FXSAlert showAlertTitle:_title message:_message controller:controller];
}

@end
