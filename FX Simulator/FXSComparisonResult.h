//
//  FXSComparisonResult.h
//  FXSimulator
//
//  Created by yuu on 2015/11/14.
//
//

#import <Foundation/Foundation.h>

@interface FXSComparisonResult : NSObject
@property (nonatomic, readonly) NSComparisonResult result;
- (instancetype)initWithComparisonResult:(NSComparisonResult)result;
@end
