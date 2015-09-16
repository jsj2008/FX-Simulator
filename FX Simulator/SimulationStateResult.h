//
//  SimulationStateResult.h
//  FXSimulator
//
//  Created by yuu on 2015/09/10.
//
//

#import <Foundation/Foundation.h>

@interface SimulationStateResult : NSObject
@property (nonatomic, readonly) BOOL isStop;
@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) NSString *message;
- (instancetype)initWithIsStop:(BOOL)isStop title:(NSString *)title message:(NSString *)message;
@end
