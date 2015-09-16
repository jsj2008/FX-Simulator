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

typedef void (^SetSaveDataBlock)(SaveData *, Market *market);
typedef void (^LoadSaveDataBlock)(SetSaveDataBlock);

@interface TradeViewController ()

@end

@implementation TradeViewController {
    ChartViewController *_chartViewController;
    RatePanelViewController *_ratePanelViewController;
    TradeDataViewController *_tradeDataViewController;
    LoadSaveDataBlock _loadSaveDataBlock;
    Market *_market;
    OrderManager *_orderManager;
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
- (void)loadSaveData:(SaveData *)saveData market:(Market *)market
{
    __block BOOL isSaveDataLoaded = NO;
    
    _loadSaveDataBlock = ^(SetSaveDataBlock setSaveDataBlock) {
        if (!isSaveDataLoaded) {
            if (saveData && setSaveDataBlock ) {
                setSaveDataBlock(saveData, market);
                isSaveDataLoaded = YES;
            }
        }
    };
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
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    SetSaveDataBlock setSaveDataBlock = ^(SaveData *saveData, Market *market) {
        _market = market;
        [_chartViewController setChart:saveData.mainChart];
        _orderManager = [OrderManager createOrderManager];
        [_ratePanelViewController loadSaveData:saveData];
        [_ratePanelViewController loadMarket:market];
        [_ratePanelViewController loadOrderManager:_orderManager];
        [_tradeDataViewController loadSaveData:saveData];
        [_tradeDataViewController loadMarket:market];
        [_orderManager addDelegate:_tradeDataViewController];
    };
    
    if (_loadSaveDataBlock) {
        _loadSaveDataBlock(setSaveDataBlock);
    }
    
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
    [_chartViewController updateChartForTime:_market.currentTime];
    [_ratePanelViewController update];
    [_tradeDataViewController update];
}

- (void)chartViewTouched
{
    [_simulationManager addTime];
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
