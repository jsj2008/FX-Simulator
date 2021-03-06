//
//  OpenPositionRawRecord.h
//  FX Simulator
//
//  Created  on 2014/12/10.
//  
//

#import <Foundation/Foundation.h>

@class FMResultSet;
@class PositionSize;

/**
 OpenPositionデータベーステーブルのレコードをそのままオブジェクトにしたもの。
*/

@interface OpenPositionRawRecord : NSObject
@property (nonatomic, readonly) NSUInteger saveSlot;
@property (nonatomic, readonly) NSUInteger recordId;
@property (nonatomic, readonly) NSUInteger executionOrderId;
@property (nonatomic, readonly) PositionSize *positionSize;
- (instancetype)initWithFMResultSet:(FMResultSet*)rs;
@end
