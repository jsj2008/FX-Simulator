//
//  SimulationState.h
//  FX Simulator
//
//  Created by yuu on 2015/06/11.
//
//

#import <Foundation/Foundation.h>


@class UIViewController;

@interface SimulationState : NSObject
/**
 資産が０以下になったときに、呼ぶ。
 資産が0以下である状態になる。
*/
-(void)shortage;
/**
 チャートが端まで読み込まれたときに、呼ぶ。
 Marketのデータが最後まで読み込まれた状態になる。
*/
-(void)didLoadForexDataEnd;
/**
 資産が0以下なのか、チャートが端まで読み込まれたのかなど、その状態に応じて、異なるアラートを出す。
 シュミレーションがストップしていないときは、アラートは表示されない。
*/
-(void)showAlert;
-(void)reset;
/**
 アラートを表示するUIViewController
*/
@property (nonatomic, weak) UIViewController *alertTarget;
@property (nonatomic, readonly) BOOL isStop;
@end
