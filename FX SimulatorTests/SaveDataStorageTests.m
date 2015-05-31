//
//  SaveDataStorageTests.m
//  FX Simulator
//
//  Created  on 2015/05/27.
//  
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "SaveData.h"
#import "SaveDataFileStorage.h"
#import "SaveDataStorageFactory.h"

@interface SaveDataStorageTests : XCTestCase

@end

@implementation SaveDataStorageTests {
    id<SaveDataStorage> _storage;
}

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    _storage = [SaveDataStorageFactory createSaveDataStorage];
    [_storage deleteAll];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    
    [_storage deleteAll];
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

/*- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}*/

- (void)testNewSave {
    SaveData *saveData = [[SaveData alloc] initWithDefaultDataAndSlotNumber:1];
    XCTAssertTrue([_storage newSave:saveData], @"create save data");
    
    BOOL result = [_storage existSaveDataSlotNumber:saveData.slotNumber];
    XCTAssertTrue(result, @"exist save data");
}

@end
