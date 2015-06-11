//
//  SimulationState.m
//  FX Simulator
//
//  Created by yuu on 2015/06/11.
//
//

#import "SimulationState.h"

#import <UIKit/UIKit.h>

static NSString* const shortageAlertTitle = @"資産が足りません。";
static NSString* const chartEndAlertTitle = @"チャートが端まで読み込まれました。";

@implementation SimulationState {
    BOOL _isShortage;
    BOOL _isForexDataEnd;
}

-(instancetype)init
{
    if (self = [super init]) {
        _isShortage = NO;
        _isForexDataEnd = NO;
    }
    
    return self;
}

-(void)shortage
{
    _isShortage = YES;
}

-(void)didLoadForexDataEnd
{
    _isForexDataEnd = YES;
}

- (void)showAlert
{
    NSString *title = @"";
    
    if (_isShortage) {
        title = shortageAlertTitle;
    } else if (_isForexDataEnd) {
        title = chartEndAlertTitle;
    }
    
    Class class = NSClassFromString(@"UIAlertController");
    if(class){
        // UIAlertControllerを使ってアラートを表示
        UIAlertController *alert = nil;
        alert = [UIAlertController alertControllerWithTitle:title
                                                    message:nil
                                             preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK"
                                                  style:UIAlertActionStyleDefault
                                                handler:nil]];
        [self.alertTarget presentViewController:alert animated:YES completion:nil];
    }else{
        // UIAlertViewを使ってアラートを表示
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK", nil];
        [alert show];
    }
}

-(void)reset
{
    _isShortage = NO;
    _isForexDataEnd = NO;
}

-(BOOL)isStop
{
    if (_isShortage || _isForexDataEnd) {
        return YES;
    }
    
    return NO;
}

@end
