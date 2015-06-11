//
//  SimulationManager.m
//  FX Simulator
//
//  Created by yuu on 2015/06/03.
//
//

#import "SimulationManager.h"

#import "Equity.h"
#import "Market.h"
#import "TradeViewController.h"

@interface SimulationManager ()
@property (nonatomic, readwrite) Market *market;
@end

@implementation SimulationManager {
    /// チャートが端まで読み込まれた、口座残高が足りなくなったなど、これ以上シュミレーションができないときに使う。
    BOOL _isSimulationStop;
}

static SimulationManager *sharedSimulationManager;

+(SimulationManager*)sharedSimulationManager
{
    @synchronized(self) {
        if (sharedSimulationManager == nil) {
            sharedSimulationManager = [SimulationManager new];
        }
    }
    
    return sharedSimulationManager;
}

-(instancetype)init
{
    if (self = [super init]) {
        _market = [Market new];
        _isSimulationStop = NO;
    }
    
    return self;
}

-(void)autoUpdateSettingSwitchChanged:(BOOL)isSwitchOn
{
    self.market.isAutoUpdate = isSwitchOn;
}

-(void)updatedEquity:(Equity *)equity
{
    if ([equity isShortage]) {
        [self stop];
        [self showAlertTitle:@"資産が足りません。" Message:nil];
    }
}

-(void)restartSimulation
{
    self.market = [Market new];
    _isSimulationStop = NO;
}

-(void)addObserver:(NSObject *)observer
{
    [self.market addObserver:observer];
}

-(void)start
{
    [self.market start];
}

-(void)pause
{
    [self.market pause];
}

-(void)resume
{
    [self.market resume];
}

-(void)add
{
    [self.market add];
}

-(void)stop
{
    [self pause];
    _isSimulationStop = YES;
}

-(void)setIsAutoUpdate:(BOOL)isAutoUpdate
{
    self.market.isAutoUpdate = isAutoUpdate;
}

-(BOOL)isAutoUpdate
{
    return self.market.isAutoUpdate;
}

- (void)showAlertTitle:(NSString *)title Message:(NSString *)message
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
        [self.alertTargetController presentViewController:alert animated:YES completion:nil];
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
