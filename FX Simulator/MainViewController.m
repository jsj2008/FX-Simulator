//
//  MainViewController.m
//  FX Simulator
//
//  Created  on 2014/10/30.
//  
//

#import "MainViewController.h"

#import "ExecutionHistoryTableViewController.h"
#import "NewStartViewController.h"
#import "OpenPositionTableViewController.h"
#import "SubChartViewController.h"
#import "TradeViewController.h"

#import "ChartViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NewStartViewController *newStartViewController;
    
    for (UIViewController *controller in self.viewControllers) {
        if ([controller isMemberOfClass:[NewStartViewController class]]) {
            newStartViewController = (NewStartViewController*)controller;
            newStartViewController.delegate = self;
            //((NewStartViewController*)controller).delegate = self;
        }
    }
    
    for (UIViewController *controller in self.viewControllers) {
        if ([controller conformsToProtocol:@protocol(NewStartViewControllerDelegate)]) {
            [newStartViewController addDelegate:(id<NewStartViewControllerDelegate>)controller];
        }
        /*if ([controller isKindOfClass:[TradeViewController class]]) {
            controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TradeViewController"];
        }*/
        /*if ([controller conformsToProtocol:@protocol(NewStartViewControllerDelegate)]) {
            [newStartViewController addDelegate:(id<NewStartViewControllerDelegate>)controller];
        }*/
    }
    
    //TradeViewController *tradeViewController = [[TradeViewController alloc]init];
    //[tradeViewController viewDidLoad];
    
    /*self.view.backgroundColor = [UIColor orangeColor];
    
    // タブの中身（UIViewController）をインスタンス化
    TradeViewController *tradeViewController = [[TradeViewController alloc]init];
    SubChartViewController *subChartViewController = [[SubChartViewController alloc] init];
    OpenPositionTableViewController *openPositionViewController = [OpenPositionTableViewController new];
    ExecutionHistoryTableViewController *executionHistoryViewController = [ExecutionHistoryTableViewController new];
    ConfigViewController *configViewController = [ConfigViewController new];
    NewStartTableViewController *newStartViewController = [NewStartTableViewController new];
    
    _tabs = [NSArray arrayWithObjects:tradeViewController, subChartViewController, openPositionViewController, executionHistoryViewController, configViewController, newStartViewController, nil];
    
    // タブコントローラにタブの中身をセット
    [self setViewControllers:_tabs animated:NO];

    
    [UITabBar appearance].barTintColor = [UIColor blackColor];
    
    //tradeViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"trade" image:[UIImage imageNamed:@"graph.png"] tag:0];
    subChartViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"チャート" image:[UIImage imageNamed:@"display.png"] tag:1];
    openPositionViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"ポジション" image:[UIImage imageNamed:@"portfolio.png"] tag:2];
    executionHistoryViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"約定履歴" image:[UIImage imageNamed:@"clock.png"] tag:3];
    configViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Config" image:[UIImage imageNamed:@"config.png"] tag:4];
    newStartViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"New" image:[UIImage imageNamed:@"note.png"] tag:5];*/
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    //self.navigationController.navigationBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    //self.navigationController.navigationBar.translucent = NO;
    
    // more navigation controller layout
    self.moreNavigationController.navigationBar.translucent = NO;
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

-(void)updatedSaveData
{
    /*for (UIViewController *controller __strong in self.viewControllers) {
        if ([controller isMemberOfClass:[TradeViewController class]]) {
            controller = [self.storyboard instantiateViewControllerWithIdentifier:@"TradeViewController"];
        } else if ([controller isMemberOfClass:[SubChartViewController class]]) {
            controller = [self.storyboard instantiateViewControllerWithIdentifier:@"SubChartViewController"];
        } else if ([controller isMemberOfClass:[OpenPositionTableViewController class]]) {
            controller = [self.storyboard instantiateViewControllerWithIdentifier:@"OpenPositionTableViewController"];
        } else if ([controller isMemberOfClass:[ExecutionHistoryTableViewController class]]) {
            controller = [self.storyboard instantiateViewControllerWithIdentifier:@"ExecutionHistoryTableViewController"];
        } else if ([controller isMemberOfClass:[ChartViewController class]]) {
            controller = [self.storyboard instantiateViewControllerWithIdentifier:@"ChartViewController"];
        }
    }*/
}

/*-(void)changeStatusBarFrame
{
    for (UIViewController *controller in _tabs) {
        [controller viewDidLayoutSubviews];
    }
}*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
