//
//  AdNetworkIAd.m
//  FXSimulator
//
//  Created by yuu on 2015/12/22.
//
//

#import "AdNetworkIAd.h"

@import iAd;

@interface AdNetworkIAd () <ADBannerViewDelegate>
@property (nonatomic) BOOL isAdLoaded;
@property (nonatomic) UIView *adView;
@end

@implementation AdNetworkIAd {
    ADBannerView *_bannerView;
}

- (void)load
{
    [self reset];
    
    _bannerView = [[ADBannerView alloc] initWithAdType:ADAdTypeBanner];
    self.adView = _bannerView;
        
    if ([self.delegate respondsToSelector:@selector(didLoadAdNetwork:)]) {
        [self.delegate didLoadAdNetwork:self];
    }
        
    _bannerView.delegate = self;
}

- (void)reset
{
    self.isAdLoaded = NO;
    [_bannerView removeFromSuperview];
    _bannerView.delegate = nil;
    _bannerView = nil;
}

#pragma mark - ADBannerViewDelegate

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    self.isAdLoaded = YES;
    
    if ([self.delegate respondsToSelector:@selector(didLoadAd:)]) {
        [self.delegate didLoadAd:self];
    }
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    [self reset];
    
    if ([self.delegate respondsToSelector:@selector(didFailToLoadAd:)]) {
        [self.delegate didFailToLoadAd:self];
    }
}

@end
