//
//  AdNetworkIAd.h
//  FXSimulator
//
//  Created by yuu on 2015/12/22.
//
//

#import "AdNetwork.h"

@interface AdNetworkIAd : NSObject <AdNetwork>
@property (nonatomic, weak) id<AdNetworkDelegate> delegate;
@property (nonatomic, readonly) BOOL isAdLoaded;
@property (nonatomic, readonly) UIView *adView;
- (void)load;
@end
