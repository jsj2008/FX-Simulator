//
//  SimulationManager.h
//  FX Simulator
//
//  Created by yuu on 2015/06/03.
//
//

#import <Foundation/Foundation.h>
#import "OrderManager.h"

@class Market;
@class Message;
@class OrderFactory;
@class OrderManager;
@class SaveData;
@class SimulationManager;
@class SimulationStateResult;

@protocol SimulationManagerDelegate <NSObject>
/**
 loadSimulationManagerの後に呼ばれる。
 その後、新しいセーブデータが開始される度に呼ばれる。
*/
- (void)loadSaveData:(SaveData *)saveData;
@optional
- (void)loadMarket:(Market *)market;
- (void)loadOrderFactory:(OrderFactory *)orderFactory;
- (void)loadOrderManager:(OrderManager *)orderManager;
- (void)saveDataDidLoad;

/**
 アプリ起動後、最初に1回だけ呼ばれる。
*/
- (void)loadSimulationManager:(SimulationManager *)simulationManager;

- (void)marketDidUpdate;
- (void)simulationStopped:(Message *)message;
- (void)didOrder:(Result *)result;
@end

@class UIViewController;
@class Account;
@class FXSAlert;
@class Balance;
@class Market;
@class SaveData;
@class TradeViewController;

/**
 シミュレーションの状態をチェックして、それにもとづいてシミュレーションを管理する。
 Marketオブジェクトを持ち、Marketの時間が進むと、それに応じて、オブザーバにMarketの変更を伝える。
*/

@interface SimulationManager : NSObject <OrderManagerState, OrderManagerDelegate>
@property (nonatomic) float autoUpdateIntervalSeconds;
@property (nonatomic) BOOL isAutoUpdate;
@property (nonatomic, readonly) BOOL isStartTime;

- (void)addDelegate:(id<SimulationManagerDelegate>)delegate;
- (void)startSimulation;
- (void)startSimulationForSaveData:(SaveData *)saveData;
- (void)save;

/**
 Startした瞬間、時間が進み、Observerのメソッドが呼ばれ、それぞれのObserverに値がセットされる。
*/
-(void)startTime;

/**
 ただの一時停止。セーブデータの自動更新設定は変更されない。
 */
-(void)pauseTime;

/**
 セーブデータの自動更新設定(AutoUpdate)をそのまま反映するだけ。
*/
-(void)resumeTime;

/** 
 手動で時間を進める。
*/
-(void)addTime;

- (Result *)isOrderable:(Order *)order;

@end
