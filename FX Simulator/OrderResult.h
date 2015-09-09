//
//  OrderResult.h
//  FXSimulator
//
//  Created by yuu on 2015/09/05.
//
//

#import <Foundation/Foundation.h>

@interface OrderResult : NSObject
@property (nonatomic, readonly) BOOL isSuccess;
@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) NSString *message;
- (instancetype)initWithIsSuccess:(BOOL)isSuccess title:(NSString *)title message:(NSString *)message;
@end
