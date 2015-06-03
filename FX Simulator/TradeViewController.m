//
//  TradeViewController.m
//  ForexGame
//
//  Created  on 2014/05/26.
//  
//

#import "TradeViewController.h"

#import <QuartzCore/QuartzCore.h>
#import "ChartViewController.h"
#import "Market.h"
#import "ChartViewController.h"
#import "RatePanelViewController.h"
#import "SimulationManager.h"
#import "TradeDataViewController.h"

@interface TradeViewController ()

@end

@implementation TradeViewController {
    //Market *_market;
    ChartViewController *_chartViewController;
    RatePanelViewController *_ratePanelViewController;
    TradeDataViewController *_tradeDataViewController;
    SimulationManager *_simulationManager;
    UIView *_adView;
}

/*-(id)init
{
    if (self = [super init]) {
        _market = [MarketManager sharedMarket];
    }
    
    return self;
}*/

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        _simulationManager = [SimulationManager sharedSimulationManager];
    }
    
    return self;
}

/*-(void)awakeFromNib
{
    [super awakeFromNib];
    
    _market = [MarketManager sharedMarket];
}*/


/*- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}*/

/*-(void)loadView
{
    [super loadView];
    
    //chartViewController = [ChartViewController new];
    ratePanelViewController = [RatePanelViewController new];
    tradeDataViewController = [TradeDataViewController new];
    
    _adView = [UIView new];
    [self.view addSubview:_adView];
    
    //[self.view addSubview:chartViewController.view];
    [self.view addSubview:ratePanelViewController.view];
    [self.view addSubview:tradeDataViewController.view];
}*/

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _ratePanelViewController.delegate = _tradeDataViewController;
    _tradeDataViewController.delegate = _simulationManager;
    
    [_simulationManager addObserver:_chartViewController];
    [_simulationManager addObserver:_ratePanelViewController];
    [_simulationManager addObserver:_tradeDataViewController];
    
    //self.childViewControllers[0];
    
    //ChartViewController *chartViewController2 = [self.storyboard instantiateViewControllerWithIdentifier:@"ChartViewController"];
    //chartViewController = self.childViewControllers[0];
    //ratePanelViewController = self.childViewControllers[1];
    
    //chartViewController.tlabel.text = @"vvv";
    //ratePanelViewController.delegate = tradeDataViewController;
    //tradeDataViewController.delegate = self;
    
    //[_market addObserver:chartViewController];
    //[_market addObserver:ratePanelViewController];
    //[market addObserver:ratePanelViewController];
    //[market addObserver:tradeDataViewController];
    //[_market setDefaultData];
    
    [_simulationManager start];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    /*CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.view.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor darkGrayColor] CGColor], [(id)[UIColor colorWithRed:55/255.0 green:55/255.0 blue:55/255.0 alpha:1.0] CGColor], nil];
    [self.view.layer insertSublayer:gradient atIndex:0];*/
    /*self.view.backgroundColor = [UIColor blackColor];
    
    
    CGRect mainScreenRect = [[UIScreen mainScreen] applicationFrame];
    float statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    float adViewHeight = 49.0;
    float uiTabBarHeight = 49.0;
    
    float chartViewY = statusBarHeight;
    float chartViewWidth = mainScreenRect.size.width;
    float chartViewHeight = (mainScreenRect.size.height - adViewHeight - uiTabBarHeight)*1.6/2.6;
    
    float tradeViewY = statusBarHeight + chartViewHeight;
    float tradeViewWidth = mainScreenRect.size.width;
    float tradeViewHeight = (mainScreenRect.size.height - chartViewHeight - adViewHeight - uiTabBarHeight)*1.0/2.6;
    
    float positionViewY = statusBarHeight + chartViewHeight + tradeViewHeight;
    float positionViewWidth = mainScreenRect.size.width;
    float positionViewHeight = (mainScreenRect.size.height - chartViewHeight - tradeViewHeight - adViewHeight - uiTabBarHeight);
    
    self.view.frame = CGRectMake(0, 0, mainScreenRect.size.width, statusBarHeight + mainScreenRect.size.height - uiTabBarHeight);
    
    
    //chartViewController.view.frame = CGRectMake(0, chartViewY, chartViewWidth, chartViewHeight);
    ratePanelViewController.view.frame = CGRectMake(0, tradeViewY, tradeViewWidth, tradeViewHeight);
    tradeDataViewController.view.frame = CGRectMake(0, positionViewY, positionViewWidth, positionViewHeight);*/
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_simulationManager resume];
    //_market.isAutoUpdate = _market.isSaveDataAutoUpdate;
    //[market setPaused:NO];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [_simulationManager pause];
    //_market.isAutoUpdate = NO;
    //[market setPaused:YES];
    
}

/*-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [tradeDataViewController tradeViewTouchesBegan];
}*/

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ChartViewControllerSeg"]) {
        _chartViewController = segue.destinationViewController;
        _chartViewController.delegate = self;
        //[_market addObserver:segue.destinationViewController];
        //[_market setDefaultData];
    } else if ([segue.identifier isEqualToString:@"RatePanelViewControllerSeg"]) {
        _ratePanelViewController = segue.destinationViewController;
    } else if ([segue.identifier isEqualToString:@"TradeDataViewControllerSeg"]) {
        _tradeDataViewController = segue.destinationViewController;
        //controller.delegate = self;
        //[_market addObserver:segue.destinationViewController];
    }
}

-(void)chartViewTouched
{
    if (!_simulationManager.isAutoUpdate) {
        [_simulationManager add];
    }
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
