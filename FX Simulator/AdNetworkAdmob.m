//
//  AdNetworkAdmob.m
//  FXSimulator
//
//  Created by yuu on 2015/12/22.
//
//

#import "AdNetworkAdmob.h"

#import "AdNetworkSettingsId.h"

@import GoogleMobileAds;

@interface AdNetworkAdmob () <GADBannerViewDelegate>
@property (nonatomic) BOOL isAdLoaded;
@property (nonatomic) UIView *adView;
@end

@implementation AdNetworkAdmob {
    __weak UIViewController *_adViewController;
    GADBannerView *_bannerView;
}

- (instancetype)initWithAdViewController:(UIViewController *)adViewController
{
    if (self = [super init]) {
        _adViewController = adViewController;
    }
    
    return self;
}

- (void)load
{
    [self reset];
    
    _bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait];
    _bannerView.adUnitID = [AdNetworkSettingsId admobId];
    _bannerView.delegate = self;
    _bannerView.rootViewController = _adViewController;
    self.adView = _bannerView;
        
    if ([self.delegate respondsToSelector:@selector(didLoadAdNetwork:)]) {
        [self.delegate didLoadAdNetwork:self];
    }
        
    GADRequest *request = [GADRequest request];
    
    [_bannerView loadRequest:request];
}

- (void)reset
{
    self.isAdLoaded = NO;
    [_bannerView removeFromSuperview];
    _bannerView.delegate = nil;
    _bannerView = nil;
}

#pragma mark - GADBannerViewDelegate

- (void)adViewDidReceiveAd:(GADBannerView *)bannerView
{
    self.isAdLoaded = YES;
    
    if ([self.delegate respondsToSelector:@selector(didLoadAd:)]) {
        [self.delegate didLoadAd:self];
    }
}

- (void)adView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(GADRequestError *)error
{
    [self reset];
    
    if ([self.delegate respondsToSelector:@selector(didFailToLoadAd:)]) {
        [self.delegate didFailToLoadAd:self];
    }
}

@end
