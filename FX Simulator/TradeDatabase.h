//
//  TradeDatabase.h
//  FX Simulator
//
//  Created  on 2014/07/17.
//  
//

#import <Foundation/Foundation.h>

@interface TradeDatabase : NSObject

+ (void)transaction:(void (^)())block completion:(void (^)(BOOL isRollbacked))completion;

@end
