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
#import "SaveDataSource.h"
#import "CoreDataInMemoryManager.h"
#import "Chart.h"
#import "ChartChunk.h"
#import "Currency.h"
#import "CurrencyPair.h"
#import "TimeFrame.h"
#import "FXSTimeRange.h"
#import "Setting.h"
#import "Spread.h"
#import "PositionSize.h"
#import "Lot.h"
#import "Money.h"

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

- (void)testCreateNewSaveData
{
    NSUInteger slotNumber = 1;
    CurrencyPair *currencyPair = [[CurrencyPair alloc] initWithCurrencyPairString:@"EURUSD"];
    TimeFrame *timeFrame = [[TimeFrame alloc] initWithMinute:15];
    
    SaveData *saveData = [SaveData createNewSaveDataFromSlotNumber:slotNumber currencyPair:currencyPair timeFrame:timeFrame];
    saveData.startTime = [Setting rangeForCurrencyPair:saveData.currencyPair timeScale:saveData.timeFrame].start;
    saveData.lastLoadedTime = saveData.startTime;
    saveData.spread = [[Spread alloc] initWithPips:1 currencyPair:saveData.currencyPair];
    saveData.accountCurrency = [[Currency alloc] initWithCurrencyType:JPY];
    saveData.startBalance = [[Money alloc] initWithAmount:1000000 currency:saveData.accountCurrency];
    saveData.positionSizeOfLot = [[PositionSize alloc] initWithSizeValue:10000];
    saveData.tradePositionSize = [[PositionSize alloc] initWithSizeValue:10000];
    saveData.isAutoUpdate = YES;
    saveData.autoUpdateIntervalSeconds = 1.0;
    
    [_coreDataManagerInMemory saveContext];
    
    NSManagedObjectContext *context = _coreDataManagerInMemory.managedObjectContext;
    
    NSFetchRequest *fetchRequest = [NSFetchRequest new];
    NSEntityDescription * entityDescription = [NSEntityDescription entityForName:NSStringFromClass([SaveDataSource class]) inManagedObjectContext:context];
    [fetchRequest setEntity:entityDescription];
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"(slotNumber = %d)", slotNumber];
    [fetchRequest setPredicate:predicate];
    
    NSError * error2;
    NSArray * objects = [context executeFetchRequest:fetchRequest error:&error2];
    
    SaveData *newSaveData = [[SaveData alloc] initWithSaveDataSource:objects.firstObject];
    
    XCTAssertNotNil(newSaveData, @"Not nil");
    
    XCTAssertEqual(slotNumber, newSaveData.slotNumber, @"Equal slotNumber");
    XCTAssertEqualObjects(currencyPair, newSaveData.currencyPair, @"Equal CurrencyPair");
    XCTAssertEqualObjects(timeFrame, newSaveData.timeFrame, @"Equal TimeFrame");
    
    XCTAssertEqualObjects(currencyPair, newSaveData.mainChart.currencyPair, @"Equal CurrencyPair");
    XCTAssertEqualObjects(timeFrame, newSaveData.mainChart.timeFrame, @"Equal TimeFrame");
    XCTAssertEqual(YES, newSaveData.mainChart.isSelected, "isSelected YES");
    
    [newSaveData.subChartChunk enumerateCharts:^(Chart *chart) {
        XCTAssertEqualObjects(currencyPair, chart.currencyPair, @"Equal CurrencyPair");
        XCTAssertEqualObjects(timeFrame, chart.timeFrame, @"Equal TimeFrame");
    }];
    
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
