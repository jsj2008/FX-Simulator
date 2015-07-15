//
//  SimpleMovingAverageTests.m
//  FX Simulator
//
//  Created by yuu on 2015/07/15.
//
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "SimpleMovingAverage.h"
#import "SimpleMovingAverageSource.h"

@interface SimpleMovingAverageTests : XCTestCase

@end

@implementation SimpleMovingAverageTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSourceCreateFromDictionary {
    NSUInteger term = 20;
    UIColor *color = [UIColor whiteColor];
    NSData *lineColorData = [NSKeyedArchiver archivedDataWithRootObject:color];
    NSDictionary *dic = @{@"IndicatorName":@"SimpleMovingAverage", @"DisplayIndex":@(1), @"IsMainChart":@(1), @"TimeScale":@(15), @"Term":@(term), @"LineColorData":lineColorData};
    SimpleMovingAverageSource *source = [[SimpleMovingAverageSource alloc] initWithDictionary:dic];
    
    XCTAssertTrue(source.term == term, @"equal term");
    XCTAssertTrue([source.lineColor isEqual:color], @"equal color");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
