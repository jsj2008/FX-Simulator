//
//  SimulationManager.h
//  FX Simulator
//
//  Created by yuu on 2015/06/03.
//
//

#import <Foundation/Foundation.h>

@protocol SimulationManagerDelegate <NSObject>
/// 新しいシュミレーションが始まったことを伝える。
-(void)restartedSimulation;
@end

@class Balance;
@class Market;

/**
 シュミレーションの状態をチェックして、それにもとづいてシュミレーションを管理する。
*/

@interface SimulationManager : NSObject
+(SimulationManager*)sharedSimulationManager;
/// 口座残高をチェックする。マイナスならシュミレーションを停止する。
-(void)updatedBalance:(Balance*)balance;
-(void)restartSimulation;
-(void)addObserver:(NSObject*)observer;
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
/**
 Onなら自動更新になり、セーブデータの自動更新設定もOnに変更される。
 Offでも同じ。
 */
@property (nonatomic, assign) id<SimulationManagerDelegate> delegate;
@property (nonatomic) BOOL isAutoUpdate;
@property (nonatomic, readonly) Market *market;
@end
