//
//  ChartDataArea.h
//  FXSimulator
//
//  Created by yuu on 2015/10/24.
//
//

#import <Foundation/Foundation.h>

@class Coordinate;

@interface CoordinateRange : NSObject
@property (nonatomic, readonly) Coordinate *begin;
@property (nonatomic, readonly) Coordinate *end;
- (instancetype)initWithBegin:(Coordinate *)begin end:(Coordinate *)end;
@end
