//
//  AdNetwork.h
//  FXSimulator
//
//  Created by yuu on 2015/12/22.
//
//

#import <Foundation/Foundation.h>

@import UIKit;

@protocol AdNetwork;

@protocol AdNetworkDelegate <NSObject>
- (void)didLoadAdNetwork:(id<AdNetwork>)adNetwork;
- (void)didLoadAd:(id<AdNetwork>)adNetwork;
- (void)didFailToLoadAd:(id<AdNetwork>)adNetwork;
@end

@protocol AdNetwork <NSObject>
@property (nonatomic, weak) id<AdNetworkDelegate> delegate;
@property (nonatomic, readonly) BOOL isAdLoaded;
@property (nonatomic, readonly) UIView *adView;
- (void)load;
- (void)normalizeAdViewWithScreenSize:(CGSize)size;
@end
