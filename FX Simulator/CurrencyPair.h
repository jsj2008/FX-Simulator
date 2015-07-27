//
//  CurrencyPair.h
//  ForexGame
//
//  Created  on 2014/06/25.
//  
//

#import <Foundation/Foundation.h>

@class Currency;

@interface CurrencyPair : NSObject <NSCoding>
-(id)initWithCurrencyPairString:(NSString*)currencyPairString;
-(id)initWithBaseCurrency:(Currency*)baseCurrency QuoteCurrency:(Currency*)quoteCurrency;
-(BOOL)isQuoteCurrencyEqualJPY;
-(BOOL)isEqualCurrencyPair:(CurrencyPair*)currencyPair;
/**
 データベースに登録するための文字列(USD/JPY => "USDJPY")、またNSDictionaryのKeyなどにも使う。
*/
-(NSString*)toCodeString;
-(NSString*)toDisplayString;
-(NSString*)toCodeReverseString;
-(NSArray*)toArray;
/**
 左側の通貨。
*/
@property (nonatomic, readonly) Currency *baseCurrency;
/**
 右側の通貨。
*/
@property (nonatomic, readonly) Currency *quoteCurrency;
@end
