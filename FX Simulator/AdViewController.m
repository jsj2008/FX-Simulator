//
//  AdViewController.m
//  FXSimulator
//
//  Created by yuu on 2015/12/22.
//
//

#import "AdViewController.h"

#import "AdManager.h"
#import "AdNetwork.h"

@interface AdViewController () <AdManagerDelegate>

@end

@implementation AdViewController {
    AdManager *_adManager;
    id<AdNetwork> _currentLoadedAdNetwork;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        _adManager = [[AdManager alloc] initWithAdViewController:self];
        _adManager.delegate = self;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [_adManager loadAd];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if (_currentLoadedAdNetwork) {
        UIView *adView = _currentLoadedAdNetwork.adView;
        float adViewY = self.view.frame.size.height - adView.frame.size.height;
        adView.frame = CGRectMake(adView.frame.origin.x, adViewY, adView.frame.size.width, adView.frame.size.height);
    }
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        [_currentLoadedAdNetwork normalizeAdViewWithScreenSize:size];
    } completion:nil];
}

- (void)didLoadAdNetwork:(id<AdNetwork>)adNetwork
{
    _currentLoadedAdNetwork = adNetwork;
    
    UIView *adView = _currentLoadedAdNetwork.adView;
    
    [self.view addSubview:adView];
    
    adView.hidden = YES;
}

- (void)didLoadAd:(id<AdNetwork>)adNetwork
{
    adNetwork.adView.hidden = NO;
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
