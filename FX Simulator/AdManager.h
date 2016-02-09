//
//  AdManager.h
//  FXSimulator
//
//  Created by yuu on 2015/12/20.
//
//

#import "AdProvider.h"

@protocol AdManagerDelegate <NSObject>
- (void)didLoadAdNetwork:(id<AdNetwork>)adNetwork;
- (void)didLoadAd:(id<AdNetwork>)adNetwork;
@end

@interface AdManager : NSObject <AdProviderDelegate>
@property (nonatomic, weak) id<AdManagerDelegate> delegate;
- (instancetype)initWithAdViewController:(UIViewController *)adViewController;
- (void)loadAd;
@end
