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
#import "SaveLoader.h"
#import "ChartViewController.h"
#import "Market.h"
#import "ChartViewController.h"
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
    SimulationManager *_simulationManager;
    UIView *_adView;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        _simulationManager = [SimulationManager sharedSimulationManager];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    SaveData *saveData = [SaveLoader load];
    
    [_chartViewController setChart:saveData.mainChart];
    
    _ratePanelViewController.delegate = _tradeDataViewController;
    _tradeDataViewController.delegate = _simulationManager;
    
    _simulationManager.alertTargetController = self;
    
    [_simulationManager addObserver:self];
    [_simulationManager addObserver:_ratePanelViewController];
    [_simulationManager addObserver:_tradeDataViewController];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!_simulationManager.isStart) {
        [_simulationManager start];
    }
    
    [_simulationManager resume];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [_simulationManager pause];
}

/*-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [tradeDataViewController tradeViewTouchesBegan];
}*/

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ChartViewControllerSeg"]) {
        _chartViewController = segue.destinationViewController;
        _chartViewController.delegate = self;
    } else if ([segue.identifier isEqualToString:@"RatePanelViewControllerSeg"]) {
        _ratePanelViewController = segue.destinationViewController;
    } else if ([segue.identifier isEqualToString:@"TradeDataViewControllerSeg"]) {
        _tradeDataViewController = segue.destinationViewController;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"currentTime"] && [object isKindOfClass:[Market class]]) {
        [_chartViewController updateChartForTime:((Market*)object).currentTime];
    }
}

- (void)chartViewTouched
{
    if (!_simulationManager.isAutoUpdate) {
        [_simulationManager add];
    }
}

- (void)updatedSaveData
{
    [_chartViewController updatedSaveData];
    [_ratePanelViewController updatedSaveData];
    [_tradeDataViewController updatedSaveData];
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
