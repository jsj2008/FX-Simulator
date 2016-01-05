//
//  AdManager.h
//  FXSimulator
//
//  Created by yuu on 2015/12/20.
//
//

#import "AdProvider.h"

@protocol AdManagerDelegate <NSObject>
- (void)didLoadAdNetwork:(UIView *)adView;
- (void)didLoadAd:(UIView *)adView;
@end

@interface AdManager : NSObject <AdProviderDelegate>
@property (nonatomic, weak) id<AdManagerDelegate> delegate;
- (instancetype)initWithAdViewController:(UIViewController *)adViewController;
- (void)loadAd;
@end
