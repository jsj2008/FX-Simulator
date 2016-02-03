//
//  Money.h
//  FX Simulator
//
//  Created  on 2014/12/04.
//  
//

#import <UIKit/UIKit.h>
#import "Common.h"

@class Currency;
@class FXSComparisonResult;

@interface Money : NSObject <NSCoding>
@property (nonatomic, readonly) amount_t amount;
@property (nonatomic, readonly) NSNumber *toMoneyValueObj;
@property (nonatomic, readonly) NSString *toDisplayString;
@property (nonatomic, readonly) UIColor *toDisplayColor;
@property (nonatomic, readonly) Currency *currency;
- (instancetype)initWithAmount:(amount_t)amount currency:(Currency *)currency;
- (instancetype)initWithNumber:(NSNumber *)number currency:(Currency*)currency;
- (instancetype)initWithString:(NSString *)string currency:(Currency*)currency;
- (Money *)addMoney:(Money *)money;
- (Money *)copyMoney;
- (FXSComparisonResult *)compareMoney:(Money *)money;
- (Money *)convertToCurrency:(Currency *)currency;
@end
