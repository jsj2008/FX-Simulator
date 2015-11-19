//
//  ChartType.h
//  FXSimulator
//
//  Created by yuu on 2015/11/18.
//
//

#import <Foundation/Foundation.h>

@interface ChartType : NSObject <NSCoding>
+ (instancetype)mainChart;
+ (instancetype)subChart;
- (BOOL)isMainChart;
- (BOOL)isSubChart;
@end
