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
#import "CoreDataManager.h"
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
    
    [CoreDataManager setCoreDataManager:_coreDataManagerInMemory];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    
    [CoreDataManager setCoreDataManager:nil];
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testCreateNewSaveData
{
    CurrencyPair *currencyPair = [[CurrencyPair alloc] initWithCurrencyPairString:@"EURUSD"];
    TimeFrame *timeFrame = [[TimeFrame alloc] initWithMinute:15];
    Currency *accountCurrency = [[Currency alloc] initWithCurrencyType:JPY];
    
    SaveData *saveData = [SaveData createNewSaveData];
    saveData.currencyPair = currencyPair;
    saveData.timeFrame = timeFrame;
    saveData.startTime = [Setting rangeForSimulation].start;
    saveData.lastLoadedTime = saveData.startTime;
    saveData.spread = [[Spread alloc] initWithPips:1 currencyPair:saveData.currencyPair];
    saveData.accountCurrency = accountCurrency;
    saveData.startBalance = [[Money alloc] initWithAmount:1000000 currency:saveData.accountCurrency];
    saveData.positionSizeOfLot = [[PositionSize alloc] initWithSizeValue:10000];
    saveData.tradePositionSize = [[PositionSize alloc] initWithSizeValue:10000];
    saveData.isAutoUpdate = YES;
    saveData.autoUpdateIntervalSeconds = 1.0;
    
    [saveData saveWithCompletion:nil error:^{
        XCTFail(@"Save error");
    }];
    
    NSUInteger slotNumber = 1;
    
    SaveData *newSaveData = [SaveData loadFromSlotNumber:slotNumber];
    
    XCTAssertNotNil(newSaveData, @"Not nil");
    XCTAssertEqual(slotNumber, newSaveData.slotNumber, @"Equal slotNumber");
    XCTAssertEqualObjects(currencyPair, newSaveData.currencyPair, @"Equal CurrencyPair");
    XCTAssertEqualObjects(timeFrame, newSaveData.timeFrame, @"Equal TimeFrame");
    
    XCTAssertEqualObjects(currencyPair, newSaveData.spread.currencyPair, @"Equal Spread CurrencyPair");
    XCTAssertEqualObjects(accountCurrency, newSaveData.startBalance.currency, @"Equal StartBalance Currency");
    
    XCTAssertNotNil(newSaveData.mainChart, @"MainChart not nil");
    XCTAssertEqualObjects(currencyPair, newSaveData.mainChart.currencyPair, @"Equal CurrencyPair");
    XCTAssertEqualObjects(timeFrame, newSaveData.mainChart.timeFrame, @"Equal TimeFrame");
    XCTAssertEqual(YES, newSaveData.mainChart.isDisplay, "isSelected YES");
    
    XCTAssertNotNil(newSaveData.subChartChunk, @"SubChartChunk not nil");
    XCTAssertTrue([newSaveData.subChartChunk existsChart], @"Exists SubChart");
    [newSaveData.subChartChunk enumerateCharts:^(Chart *chart) {
        XCTAssertEqualObjects(currencyPair, chart.currencyPair, @"Equal CurrencyPair");
    }];
    
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
