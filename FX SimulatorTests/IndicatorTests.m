//
//  IndicatorTests.m
//  FX Simulator
//
//  Created by yuu on 2015/07/15.
//
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "IndicatorPlistSource.h"


@interface IndicatorTests : XCTestCase

@end

@implementation IndicatorTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    NSDictionary *dic = @{@"IndicatorName":@"SampleIndicator", @"DisplayIndex":@(1), @"IsMainChart":@(1), @"TimeScale":@(15)};
    IndicatorPlistSource *source = [[IndicatorPlistSource alloc] initWithDictionary:dic];
    
    XCTAssertTrue([dic isEqualToDictionary:[source sourceDictionary]], @"equal sourceDictionary");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
