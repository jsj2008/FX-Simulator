//
//  AdManager.m
//  FXSimulator
//
//  Created by yuu on 2015/12/20.
//
//

#import "AdManager.h"

#import "AdProvider.h"

@implementation AdManager {
    AdProvider *_adProvider;
    NSTimer *_timer;
}

- (instancetype)initWithAdViewController:(UIViewController *)adViewController
{
    if (self = [super init]) {
        _adProvider = [AdProvider defaultAdProviderWithAdViewController:adViewController];
        _adProvider.delegate = self;
    }
    
    return self;
}

- (void)loadAd
{
    [_adProvider loadAdNetwork];
    
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:30.0 target:self selector:@selector(loadAdNetwork:) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
}

- (void)loadAdNetwork:(NSTimer *)timer
{
    [_adProvider loadAdNetwork];
}

#pragma mark - AdProviderDelegate

- (void)didLoadAdNetwork:(id<AdNetwork>)adNetwork
{
    if ([self.delegate respondsToSelector:@selector(didLoadAdNetwork:)]) {
        [self.delegate didLoadAdNetwork:adNetwork.adView];
    }
}

- (void)didLoadAd:(id<AdNetwork>)adNetwork
{
    if ([self.delegate respondsToSelector:@selector(didLoadAd:)]) {
        [self.delegate didLoadAd:adNetwork.adView];
    }
}

@end
