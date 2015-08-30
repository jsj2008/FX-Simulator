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

@interface Money : NSObject <NSCoding>
- (instancetype)initWithAmount:(amount_t)amount currency:(Currency*)currency;
- (Money *)addMoney:(Money*)money;
- (Money *)convertToCurrency:(Currency *)currency;
@property (nonatomic, readonly) amount_t amount;
@property (nonatomic, readonly) NSNumber *toMoneyValueObj;
@property (nonatomic, readonly) NSString *toDisplayString;
@property (nonatomic, readonly) UIColor *toDisplayColor;
@property (nonatomic, readonly) Currency *currency;
@end
