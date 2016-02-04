//
//  AdViewController.m
//  FXSimulator
//
//  Created by yuu on 2015/12/22.
//
//

#import "AdViewController.h"

#import "AdManager.h"

@interface AdViewController () <AdManagerDelegate>

@end

@implementation AdViewController {
    AdManager *_adManager;
    UIView *_adView;
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
    
    if (_adView) {
        float adViewY = self.view.frame.size.height - _adView.frame.size.height;
        _adView.frame = CGRectMake(_adView.frame.origin.x, adViewY, _adView.frame.size.width, _adView.frame.size.height);
    }
}

- (void)didLoadAdNetwork:(UIView *)adView
{
    _adView = adView;
    
    [self.view addSubview:_adView];
    
    _adView.hidden = YES;
}

- (void)didLoadAd:(UIView *)adView
{
    _adView.hidden = NO;
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
