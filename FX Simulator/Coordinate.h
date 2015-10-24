//
//  Coordinate.h
//  FXSimulator
//
//  Created by yuu on 2015/10/24.
//
//

#import <Foundation/Foundation.h>

@interface Coordinate : NSObject
@property (nonatomic, readonly) float value;
- (instancetype)initWithCoordinateValue:(float)value;
@end
