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
-(id)initWithFMResultSet:(FMResultSet*)rs;
@property (nonatomic, readonly) NSNumber *recordID;
@property (nonatomic, readonly) NSNumber *executionOrderID;
//@property (nonatomic, readonly) NSNumber *usersOrderNumber;
@property (nonatomic, readonly) PositionSize *positionSize;
@end
