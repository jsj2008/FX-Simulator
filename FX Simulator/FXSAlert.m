//
//  FXSAlert.m
//  FX Simulator
//
//  Created by yuu on 2015/06/12.
//
//

#import "FXSAlert.h"

#import <UIKit/UIKit.h>

@implementation FXSAlert

+(void)showAlert:(UIViewController*)controller title:(NSString*)title message:(NSString*)message
{
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

@end
