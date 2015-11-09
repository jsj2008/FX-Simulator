//
//  TradeViewController.m
//  ForexGame
//
//  Created  on 2014/05/26.
//  
//

#import "TradeViewController.h"

#import <QuartzCore/QuartzCore.h>
#import "SaveData.h"
#import "ChartViewController.h"
#import "Market.h"
#import "ChartViewController.h"
#import "OrderManager.h"
#import "OrderResult.h"
#import "Rate.h"
#import "RatePanelViewController.h"
#import "SimulationManager.h"
#import "TradeDataViewController.h"

@interface TradeViewController ()

@end

@implementation TradeViewController {
    ChartViewController *_chartViewController;
    RatePanelViewController *_ratePanelViewController;
    TradeDataViewController *_tradeDataViewController;
    Market *_market;
    OrderManager *_orderManager;
    SaveData *_saveData;
    SimulationManager *_simulationManager;
    UIView *_adView;
}

- (void)loadSimulationManager:(SimulationManager *)simulationManager
{
    _simulationManager = simulationManager;
}

/**
 1回目は、prepareForSegueの前に呼ばれる
 */
- (void)loadSaveData:(SaveData *)saveData
{
    _saveData = saveData;
}

- (void)loadMarket:(Market *)market
{
    _market = market;
}

- (void)loadOrderManager:(OrderManager *)orderManager
{
    _orderManager = orderManager;
}

- (void)saveDataDidLoad
{
    if (!_chartViewController || !_ratePanelViewController || !_tradeDataViewController) {
        return;
    }
    
    [_chartViewController setChart:_saveData.mainChart];
    [_ratePanelViewController loadSaveData:_saveData];
    [_ratePanelViewController loadMarket:_market];
    [_ratePanelViewController loadOrderManager:_orderManager];
    [_tradeDataViewController loadSaveData:_saveData];
    [_tradeDataViewController loadMarket:_market];
    [_orderManager addDelegate:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ChartViewControllerSeg"]) {
        _chartViewController = segue.destinationViewController;
        _chartViewController.delegate = self;
    } else if ([segue.identifier isEqualToString:@"RatePanelViewControllerSeg"]) {
        _ratePanelViewController = segue.destinationViewController;
    } else if ([segue.identifier isEqualToString:@"TradeDataViewControllerSeg"]) {
        _tradeDataViewController = segue.destinationViewController;
        _tradeDataViewController.delegate = self;
    }
    
    [self saveDataDidLoad];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!_simulationManager.isStartTime) {
        [_simulationManager startTime];
    } else {
        [_simulationManager resumeTime];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [_simulationManager pauseTime];
}

/*-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [tradeDataViewController tradeViewTouchesBegan];
}*/

- (void)autoUpdateSettingSwitchChanged:(BOOL)isSwitchOn
{
    [_simulationManager setIsAutoUpdate:isSwitchOn];
}

- (void)update
{
    [_chartViewController update:_market];
    [_ratePanelViewController update];
    [_tradeDataViewController update];
}

- (void)chartViewTouched
{
    [_simulationManager addTime];
}

- (void)didOrder:(OrderResult *)result
{
    [result completion:nil error:^{
        [result showAlertToController:self];
    }];
    
    [_tradeDataViewController didOrder:result];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
