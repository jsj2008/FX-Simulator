//
//  SaveDataTests.m
//  FXSimulator
//
//  Created by yuu on 2015/08/21.
//
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "SaveData.h"
#import "CoreDataInMemoryManager.h"
#import "Chart.h"
#import "CurrencyPair.h"

@interface SaveDataTests : XCTestCase

@end

@implementation SaveDataTests {
    CoreDataInMemoryManager *_coreDataManagerInMemory;
}

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    _coreDataManagerInMemory = [CoreDataInMemoryManager new];
    
    [SaveData setCoreDataManager:_coreDataManagerInMemory];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    
    [SaveData setCoreDataManager:nil];
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
