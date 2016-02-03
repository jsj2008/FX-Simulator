//
//  SettingTests.m
//  FXSimulator
//
//  Created by yuu on 2016/02/03.
//
//

#import <XCTest/XCTest.h>

#import "CurrencyPair.h"
#import "ForexHistory.h"
#import "Money.h"
#import "Setting.h"
#import "TimeFrame.h"
#import "TimeFrameChunk.h"

@interface SettingTests : XCTestCase

@end

@implementation SettingTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testCanConvertToAccountCurrency
{
    BOOL canConvertToAccountCurrency = YES;
    
    for (CurrencyPair *currencyPair in [Setting currencyPairList]) {
        for (Currency *accountCurrency in [Setting accountCurrencyList]) {
            Money *money = [[Money alloc] initWithAmount:100 currency:currencyPair.quoteCurrency];
            if (![money convertToCurrency:accountCurrency]) {
                canConvertToAccountCurrency = NO;
            }
        }
    }
    
    XCTAssertTrue(canConvertToAccountCurrency, @"Can Convert To Account Currency");
}

- (void)testExistsForexHistory
{
    __block BOOL existsForexHistory = YES;
    
    for (CurrencyPair *currencyPair in [Setting currencyPairList]) {
        [[Setting timeFrameList] enumerateTimeFrames:^(TimeFrame *timeFrame) {
            if (![[ForexHistory alloc] initWithCurrencyPair:currencyPair timeScale:timeFrame].existsDataSource) {
                existsForexHistory = NO;
            }
        }];
    }
    
    XCTAssertTrue(existsForexHistory, @"Exists ForexHistory");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
