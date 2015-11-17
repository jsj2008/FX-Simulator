//
//  Currency.h
//  FX Simulator
//
//  Created  on 2014/11/28.
//  
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, CurrencyType) {
    USD = 1,
    JPY,
    EUR,
    GBP,
    AUD,
    ALL
};

@interface Currency : NSObject <NSCoding>
@property (nonatomic, readonly) CurrencyType type;
+ (instancetype)allCurrency;
- (instancetype)initWithCurrencyType:(CurrencyType)currencyType;
- (instancetype)initWithString:(NSString *)currencyString;
- (BOOL)isAllCurrency;
- (BOOL)isEqualCurrency:(Currency *)currency;
- (NSString *)toCodeString;
- (NSString *)toDisplayString;
@end
