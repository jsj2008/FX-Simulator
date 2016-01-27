//
//  MainViewController.m
//  FX Simulator
//
//  Created  on 2014/10/30.
//  
//

#import "MainViewController.h"

#import "NewStartViewController.h"
#import "SimulationManager.h"
#import "TradeViewController.h"

@interface MainViewController () <NewStartViewControllerDelegate>

@end

@implementation MainViewController {
    SimulationManager *_simulationManager;
    TradeViewController *_tradeViewController;
}

-  (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        _simulationManager = [SimulationManager new];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(didBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    [notificationCenter addObserver:self selector:@selector(willEnterBackground) name:UIApplicationWillResignActiveNotification object:nil];
    
    self.customizableViewControllers = nil;
    
    for (UIViewController *viewController in self.viewControllers) {
        
        UIViewController *controller = viewController;
        
        if ([controller isMemberOfClass:[UINavigationController class]]) {
            controller = ((UINavigationController *)controller).topViewController;
        }
        
        if ([controller conformsToProtocol:@protocol(SimulationManagerDelegate)]) {
            [_simulationManager addDelegate:(id<SimulationManagerDelegate>)controller];
        }
        if ([controller isMemberOfClass:[TradeViewController class]]) {
            _tradeViewController = (TradeViewController *)controller;
        } else if ([controller isMemberOfClass:[NewStartViewController class]]) {
            ((NewStartViewController *)controller).delegate = self;
        }
    }
    
    [_simulationManager startSimulation];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    // more navigation controller layout
    self.moreNavigationController.navigationBar.backgroundColor = [UIColor blackColor];
    self.moreNavigationController.navigationBar.barTintColor = [UIColor blackColor];
    self.moreNavigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    UITableView *view = (UITableView*)((UIViewController*)[self.moreNavigationController.viewControllers objectAtIndex:0]).view;
    view.backgroundColor = [UIColor blackColor];
    if ([[view subviews] count]) {
        for (UITableViewCell *cell in [view visibleCells]) {
            cell.backgroundColor = [UIColor blackColor];
            cell.textLabel.textColor = [UIColor whiteColor];
        }
    }
}

- (void)didBecomeActive
{
    [_simulationManager resumeTime];
}

- (void)willEnterBackground
{
    [_simulationManager pauseTime];
    [_simulationManager save];
}

- (void)didStartSimulationWithNewData
{
    self.selectedViewController = _tradeViewController;
}

- (void)dealloc
{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
