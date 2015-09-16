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

@class UIViewController;
@class CurrencyPair;
@class ForexDataChunk;
@class ForexHistoryData;
@class Time;
@class TimeFrame;
@class Rate;
@class Rates;
@class SaveData;

@interface Market : NSObject

@property (nonatomic, weak) id<MarketDelegate> delegate;
@property (nonatomic, readonly) Time *currentTime;

/**
 Onなら自動更新になり、セーブデータの自動更新設定もOnに変更される。
 Offでも同じ。
 */
@property (nonatomic) BOOL isAutoUpdate;

@property (nonatomic, readonly) BOOL isStart;
@property (nonatomic, readwrite) NSNumber *autoUpdateInterval;

- (instancetype)initWithCurrencyPair:(CurrencyPair *)currencyPair timeFrame:(TimeFrame *)timeFrame lastLoadedTime:(Time *)time;

- (void)add;

//- (void)loadSaveData:(SaveData *)saveData;

/**
 UIViewControllerに限定。
 オブザーバに通知される順番は決まっていない（たぶん）。
 Marketの更新に応じて、データを更新する時は、オブザーバ(UIViewController)に通知が伝わる前にする。
 オブザーバ(UIViewController)に通知が伝わる前に、データを更新したとき、そのデータは表示(UIViewController)には反映されない。
*/
//- (void)addObserver:(UIViewController *)observer;

/**
 最新のRatesを取得。
 */
- (Rates *)getCurrentRatesOfCurrencyPair:(CurrencyPair *)currencyPair;

/**
 Startした瞬間、時間が進み、Observerのメソッドが呼ばれ、それぞれのObserverに値がセットされる。
*/
//- (void)start;

/**
 ただの一時停止。セーブデータの自動更新設定は変更されない。
*/
//- (void)pause;

/**
 セーブデータの自動更新設定(AutoUpdate)をそのまま反映するだけ。
*/
//- (void)resume;

/** 
 時間を進める。
*/
//- (void)add;

- (BOOL)didLoadLastData;

@end
