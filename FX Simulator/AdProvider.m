//
//  AdProvider.m
//  FXSimulator
//
//  Created by yuu on 2015/12/22.
//
//

#import "AdProvider.h"

#import "AdNetworkIAd.h"
#import "AdNetworkAdmob.h"

@implementation AdProvider {
    NSArray *_adNetworks;
    id<AdNetwork> _currentAdNetwork;
}

+ (instancetype)defaultAdProviderWithAdViewController:(UIViewController *)adViewController
{
    AdNetworkIAd *iAd = [AdNetworkIAd new];
    AdNetworkAdmob *admob = [[AdNetworkAdmob alloc] initWithAdViewController:adViewController];
    
    return [[[self class] alloc] initWithAdNetworks:@[iAd, admob]];
}

- (instancetype)initWithAdNetworks:(NSArray *)adNetworks
{
    if (adNetworks.count == 0) {
        return nil;
    }
    
    if (self = [super init]) {
        _adNetworks = adNetworks;
    }
    
    return self;
}

- (void)loadAdNetwork
{
    if (!_currentAdNetwork.isAdLoaded) {
        _currentAdNetwork = _adNetworks.firstObject;
        _currentAdNetwork.delegate = self;
        [_currentAdNetwork load];
    }
}

- (void)loadNextAdNetwork
{
    if (!_currentAdNetwork) {
        return;
    }
    
    NSUInteger index = [_adNetworks indexOfObject:_currentAdNetwork];
    NSUInteger nextAdNetworkIndex = index + 1;
    
    NSUInteger lastIndex = _adNetworks.count - 1;
    
    if (index == NSNotFound || lastIndex < nextAdNetworkIndex) {
        _currentAdNetwork = nil;
        return;
    }
    
    _currentAdNetwork.delegate = nil;
    _currentAdNetwork = [_adNetworks objectAtIndex:nextAdNetworkIndex];
    _currentAdNetwork.delegate = self;
    [_currentAdNetwork load];
}

#pragma mark - AdNetworkDelegate

- (void)didLoadAdNetwork:(id<AdNetwork>)adNetwork
{
    if ([self.delegate respondsToSelector:@selector(didLoadAdNetwork:)]) {
        [self.delegate didLoadAdNetwork:adNetwork];
    }
}

- (void)didLoadAd:(id<AdNetwork>)adNetwork
{
    if ([self.delegate respondsToSelector:@selector(didLoadAd:)]) {
        [self.delegate didLoadAd:adNetwork];
    }
}

- (void)didFailToLoadAd:(id<AdNetwork>)adNetwork
{
    [self loadNextAdNetwork];
}

@end
