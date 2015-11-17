//
//  CurrencyPair.h
//  ForexGame
//
//  Created  on 2014/06/25.
//  
//

#import <Foundation/Foundation.h>
#import "Currency.h"

@class Currency;

@interface CurrencyPair : NSObject <NSCoding>

/**
 左側の通貨。
 */
@property (nonatomic, readonly) Currency *baseCurrency;

/**
 右側の通貨。
 */
@property (nonatomic, readonly) Currency *quoteCurrency;

+ (instancetype)allCurrencyPair;
- (instancetype)initWithBaseCurrency:(Currency *)baseCurrency QuoteCurrency:(Currency *)quoteCurrency;
- (instancetype)initWithBaseCurrencyType:(CurrencyType)baseCurrencyType quoteCurrencyType:(CurrencyType)quoteCurrencyType;
- (instancetype)initWithCurrencyPairString:(NSString *)currencyPairString;
- (BOOL)isAllCurrencyPair;
- (BOOL)isQuoteCurrencyEqualJPY;
- (BOOL)isEqualCurrencyPair:(CurrencyPair *)currencyPair;

/**
 データベースに登録するための文字列(USD/JPY => "USDJPY")、またNSDictionaryのKeyなどにも使う。
*/
- (NSString *)toCodeString;

- (NSString *)toDisplayString;
- (NSString *)toCodeReverseString;
- (NSArray *)toArray;

@end
