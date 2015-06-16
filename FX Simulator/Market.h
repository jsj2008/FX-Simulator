//
//  Market.h
//  FX Simulator
//
//  Created  on 2014/11/13.
//  
//

#import <Foundation/Foundation.h>

@protocol MarketDelegate <NSObject>
/**
 オブザーバーに通知が伝わる前。
*/
-(void)willNotifyObservers;
/**
 オブザーバーに通知が伝わった後。
*/
-(void)didNotifyObservers;
@end

@class ForexHistoryData;
@class Rate;

@interface Market : NSObject
-(void)addObserver:(NSObject*)observer;
/**
 最新のCloseのBidレートを取得。
*/
-(Rate*)getCurrentBidRate;
/**
 最新のCloseのAskレートを取得。
*/
-(Rate*)getCurrentAskRate;
/**
 Startした瞬間、時間が進み、Observerのメソッドが呼ばれ、それぞれのObserverに値がセットされる。
*/
-(void)start;
/**
 ただの一時停止。セーブデータの自動更新設定は変更されない。
*/
-(void)pause;
/**
 セーブデータの自動更新設定(AutoUpdate)をそのまま反映するだけ。
*/
-(void)resume;
/// 時間を進める。
-(void)add;
-(BOOL)didLoadLastData;
@property (nonatomic, weak) id<MarketDelegate> delegate;
/**
 Onなら自動更新になり、セーブデータの自動更新設定もOnに変更される。
 Offでも同じ。
*/
@property (nonatomic) BOOL isAutoUpdate;
@property (nonatomic) NSArray* currentForexHistoryDataArray;
@property (nonatomic) ForexHistoryData *currentForexHistoryData;
@property (nonatomic, readonly) int currentLoadedRowid;
@property (nonatomic, readwrite) NSNumber *autoUpdateInterval;
@end
