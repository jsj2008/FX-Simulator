//
//  TradeType.h
//  ForexGame
//
//  Created  on 2014/06/23.
//  
//

#import <Foundation/Foundation.h>

@interface PositionType : NSObject

@property (nonatomic, readonly) BOOL isShort;
@property (nonatomic, readonly) BOOL isLong;

- (instancetype)initWithShort;
- (instancetype)initWithLong;
- (BOOL)isEqualPositionType:(PositionType*)positionType;
- (instancetype)reverseType;
- (NSString *)toDisplayString;

@end
