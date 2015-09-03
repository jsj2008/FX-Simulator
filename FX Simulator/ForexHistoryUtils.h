//
//  ForexHistoryUtils.h
//  FX Simulator
//
//  Created  on 2014/11/12.
//  
//

#import <Foundation/Foundation.h>

@interface ForexHistoryUtils : NSObject
+ (NSString *)createTableName:(NSString *)currencyPair timeScale:(int)minute;
@end
