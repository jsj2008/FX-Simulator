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
    AUD
};

@interface Currency : NSObject
-(id)initWithCurrencyType:(CurrencyType)currencyType;
-(id)initWithString:(NSString*)currencyString;
-(BOOL)isEqualCurrency:(Currency*)currency;
-(NSString*)toCodeString;
-(NSString*)toDisplayString;
@property (nonatomic, readonly) CurrencyType type;
@end
