//
//  TableNameFormatter.h
//  FX Simulator
//
//  Created  on 2014/10/21.
//  
//

#import <Foundation/Foundation.h>

@interface TableNameFormatter : NSObject
+(NSString*)orderHistoryTableNameForSaveSlot:(int)num;
+(NSString*)executionHistoryTableNameForSaveSlot:(int)num;
+(NSString*)openPositionTableNameForSaveSlot:(int)num;
@end
