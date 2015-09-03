//
//  FXSAlert.m
//  FX Simulator
//
//  Created by yuu on 2015/06/12.
//
//

#import "FXSAlert.h"

#import <UIKit/UIKit.h>

@implementation FXSAlert {
    NSString *_title;
    NSString *_message;
}

+ (void)showAlertTitle:(NSString *)title message:(NSString *)message controller:(UIViewController *)controller
{
    if (!controller) {
        return;
    }
    
    Class class = NSClassFromString(@"UIAlertController");
    
    if(class){
        // UIAlertControllerを使ってアラートを表示
        UIAlertController *alert = nil;
        alert = [UIAlertController alertControllerWithTitle:title
                                                    message:message
                                             preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK"
                                                  style:UIAlertActionStyleDefault
                                                handler:nil]];
        [controller presentViewController:alert animated:YES completion:nil];
    }else{
        // UIAlertViewを使ってアラートを表示
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK", nil];
        [alert show];
    }
    
}

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message
{
    if (self = [super init]) {
        _title = title;
        _message = message;
    }
    
    return self;
}

- (void)show
{
    [[self class] showAlertTitle:_title message:_message controller:self.controller];
}

@end
