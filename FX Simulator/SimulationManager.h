//
//  SimulationManager.h
//  FX Simulator
//
//  Created by yuu on 2015/06/03.
//
//

#import <Foundation/Foundation.h>
#import "Market.h"
#import "TradeDataViewController.h"

@protocol SimulationManagerDelegate <NSObject>
/// 新しいシュミレーションが始まったことを伝える。
-(void)restartedSimulation;
@end

@class UIViewController;
@class Account;
@class Balance;
@class Market;
@class TradeViewController;

/**
 シュミレーションの状態をチェックして、それにもとづいてシュミレーションを管理する。
 Marketオブジェクトを持ち、Marketの時間が進むと、それに応じて、オブザーバにMarketの変更を伝える。
*/

@interface SimulationManager : NSObject <MarketDelegate, TradeDataViewControllerDelegate>
+(SimulationManager*)sharedSimulationManager;
-(void)willNotifyObservers;
-(void)didNotifyObservers;
-(void)didOrder;
-(void)autoUpdateSettingSwitchChanged:(BOOL)isSwitchOn;
+(void)restartSimulation;
-(void)addObserver:(UIViewController*)observer;
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
/// 手動で時間を進める。
-(void)add;
-(BOOL)isStop;
-(void)showAlert:(UIViewController*)controller;
/**
 アラート(チャートが端まで読み込まれたとき、資産が０以下になったときなど)を表示するUIViewController
*/
@property (nonatomic, weak) TradeViewController *alertTargetController;
/**
 Onなら自動更新になり、セーブデータの自動更新設定もOnに変更される。
 Offでも同じ。
 */
@property (nonatomic) BOOL isAutoUpdate;
@property (nonatomic, readonly) Account *account;
@property (nonatomic, readonly) Market *market;
@end
