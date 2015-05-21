//
//  OpenPositionUtils.m
//  FX Simulator
//
//  Created  on 2014/11/22.
//  
//

#import "OpenPositionUtils.h"
#import "OpenPositionRecord.h"
#import "PositionSize.h"
#import "Common.h"

@implementation OpenPositionUtils

+(NSArray*)selectLimitPositionSize:(PositionSize *)positionSize fromOpenPositionRecords:(NSArray *)records
{
    NSMutableArray *resultArray = [NSMutableArray array];
    
    position_size_t readTotalPositionSize = 0;
    
    for (OpenPositionRecord *record in records) {
        readTotalPositionSize += record.positionSize.sizeValue;
        
        // selectサイズ以上のオープンポジションを読み込んだとき
        if (positionSize.sizeValue <= readTotalPositionSize) {
            /*
             読み込んだサイズの合計と、selectサイズがちょうど同じならそのまま追加
             読み込んだサイズの方が大きければ、selectサイズより多い部分をカットして、
             そのオープンポジションの一部分をクローズ対象として追加
            */
            if (positionSize.sizeValue == readTotalPositionSize) {
                [resultArray addObject:record];
                break;
            } else if (positionSize.sizeValue < readTotalPositionSize) {
                position_size_t closePositionSize = record.positionSize.sizeValue - (readTotalPositionSize - positionSize.sizeValue);
                record.positionSize = [[PositionSize alloc] initWithSizeValue:closePositionSize];
                record.isAllPositionSize = NO;
                [resultArray addObject:record];
                break;
            }
        } else {
            [resultArray addObject:record];
        }
    }
    
    return [resultArray copy];
}

@end
