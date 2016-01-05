//
//  AdProvider.h
//  FXSimulator
//
//  Created by yuu on 2015/12/22.
//
//

#import "AdNetwork.h"

@protocol AdProviderDelegate <NSObject>
- (void)didLoadAdNetwork:(id<AdNetwork>)adNetwork;
- (void)didLoadAd:(id<AdNetwork>)adNetwork;
@end

@interface AdProvider : NSObject <AdNetworkDelegate>
@property (nonatomic, weak) id<AdProviderDelegate> delegate;
+ (instancetype)defaultAdProviderWithAdViewController:(UIViewController *)adViewController;
- (instancetype)initWithAdNetworks:(NSArray *)adNetworks;
- (void)loadAdNetwork;
@end
