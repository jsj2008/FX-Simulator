//
//  SaveData.m
//  FX Simulator
//
//  Created  on 2014/10/08.
//  
//

#import "SaveData.h"

#import "SaveDataSource.h"
#import "Account.h"
#import "Chart.h"
#import "ChartSource.h"
#import "ChartChunk.h"
#import "CoreDataManager.h"
#import "Currency.h"
#import "CurrencyPair.h"
#import "ExecutionOrderRelationChunk.h"
#import "FXSTimeRange.h"
#import "FXSTest.h"
#import "Leverage.h"
#import "Lot.h"
#import "Market.h"
#import "Money.h"
#import "OpenPositionRelationChunk.h"
#import "OrderRelationChunk.h"
#import "PositionSize.h"
#import "Setting.h"
#import "Spread.h"
#import "Time.h"
#import "TimeFrame.h"
#import "TimeFrameChunk.h"

static BOOL FXSDefaultIsAutoUpdate = YES;
static float FXSDefaultAutoUpdateIntervalSeconds = 0.8;
static NSUInteger FXSDefaultLeverage = 100;

@interface SaveData ()
@property (nonatomic) NSUInteger slotNumber;
@property (nonatomic) NSDate *createdAt;
@property (nonatomic) BOOL isNew;
@property (nonatomic, readonly) OrderRelationChunk *orders;
@end

@implementation SaveData {
    SaveDataSource *_saveDataSource;
}

@synthesize account = _account;
@synthesize orders = _orders;
@synthesize openPositions = _openPositions;
@synthesize executionOrders = _executionOrders;
@synthesize market = _market;

+ (CoreDataManager *)coreDataManager
{
    return [CoreDataManager sharedManager];
}

// CoreDataのinsertNewObjectの前に取得する。
+ (NSUInteger)newSlotNumber
{
    NSManagedObjectContext *context = [self coreDataManager].managedObjectContext;
    
    NSFetchRequest *fetchRequest = [NSFetchRequest new];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:NSStringFromClass([SaveDataSource class]) inManagedObjectContext:context];
    [fetchRequest setEntity:entityDescription];
    
    NSError *error2;
    NSArray *objects = [context executeFetchRequest:fetchRequest error:&error2];
    
    NSUInteger newSlotNumber;
    
    if (objects.count == 0) {
        newSlotNumber = 1;
    } else {
        newSlotNumber = [[objects valueForKeyPath:@"@max.slotNumber"] unsignedIntegerValue] + 1;
    }
    
    return newSlotNumber;
}

+ (instancetype)createNewSaveData
{
    NSUInteger slotNumber = [self newSlotNumber];
    
    SaveDataSource *source = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([SaveDataSource class]) inManagedObjectContext:[self coreDataManager].managedObjectContext];
    
    SaveData *saveData = [[SaveData alloc] initWithSaveDataSource:source isNew:YES];
    
    saveData.slotNumber = slotNumber;
    
    saveData.createdAt = [NSDate date];
    
    return saveData;
}

+ (instancetype)createDefaultNewSaveData
{
    SaveData *saveData = [self createNewSaveData];
    
    saveData.currencyPair = [self defaultCurrencyPair];
    saveData.timeFrame = [[TimeFrame alloc] initWithMinute:15];
    saveData.startTime = [Time timeWithBlock:^(NSDateComponents *components) {
        components.year = 2010;
        components.month = 1;
        components.day = 1;
        components.hour = 0;
        components.minute = 0;
        components.second = 0;
    }];;
    saveData.lastLoadedTime = saveData.startTime;
    saveData.spread = [[Spread alloc] initWithPips:1 currencyPair:saveData.currencyPair];
    saveData.startBalance = [self defaultStartBalance];
    saveData.accountCurrency = saveData.startBalance.currency;
    // SettingのpositionSizeOfLotListにある値
    saveData.positionSizeOfLot = [[PositionSize alloc] initWithSizeValue:10000];;
    
    saveData.tradePositionSize = saveData.positionSizeOfLot;
    saveData.isAutoUpdate = FXSDefaultIsAutoUpdate;
    saveData.autoUpdateIntervalSeconds = FXSDefaultAutoUpdateIntervalSeconds;
    saveData.leverage = [[Leverage alloc] initWithLeverage:FXSDefaultLeverage];
    
    return saveData;
}

+ (Currency *)defaultAccountCurrency
{
    if ([Setting isLocaleJapanese]) {
        return [[Currency alloc] initWithCurrencyType:JPY];
    } else {
        return [[Currency alloc] initWithCurrencyType:USD];
    }
}

+ (Money *)defaultStartBalance
{
    Currency *defaultAccountCurrency = [self defaultAccountCurrency];
    
    if ([defaultAccountCurrency isEqualCurrency:[[Currency alloc] initWithCurrencyType:JPY]]) {
        return [[Money alloc] initWithAmount:1000000 currency:defaultAccountCurrency];
    } else if ([defaultAccountCurrency isEqualCurrency:[[Currency alloc] initWithCurrencyType:USD]]) {
        return [[Money alloc] initWithAmount:10000 currency:defaultAccountCurrency];
    }
    
    return nil;
}

+ (CurrencyPair *)defaultCurrencyPair
{
    if ([Setting isLocaleJapanese]) {
        return [[CurrencyPair alloc] initWithBaseCurrencyType:USD quoteCurrencyType:JPY];
    } else {
        return [[CurrencyPair alloc] initWithBaseCurrencyType:EUR quoteCurrencyType:USD];
    }
}

+ (instancetype)loadFromSlotNumber:(NSUInteger)slotNumber
{
    NSManagedObjectContext *context = [self coreDataManager].managedObjectContext;
    
    NSFetchRequest *fetchRequest = [NSFetchRequest new];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:NSStringFromClass([SaveDataSource class]) inManagedObjectContext:context];
    [fetchRequest setEntity:entityDescription];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(slotNumber = %d)", slotNumber];
     [fetchRequest setPredicate:predicate];
    
    NSError *error2;
    NSArray *objects = [context executeFetchRequest:fetchRequest error:&error2];
    
    SaveDataSource *source = objects.firstObject;
    
    return [[self alloc] initWithSaveDataSource:source isNew:NO];
}

- (instancetype)init
{
    return nil;
}

- (instancetype)initWithSaveDataSource:(SaveDataSource *)source isNew:(BOOL)isNew;
{
    if (!source) {
        return nil;
    }
    
    if (self = [super init]) {
        _saveDataSource = source;
        _isNew = isNew;
    }
    
    return self;
}

- (void)setDefaultCharts
{
    if (!self.currencyPair || !self.timeFrame) {
        return;
    }
    
    Chart *mainChart = [Chart createNewMainChartFromSaveDataSource:_saveDataSource];
    mainChart.chartIndex = 0;
    mainChart.currencyPair = self.currencyPair;
    mainChart.timeFrame = self.timeFrame;
    mainChart.isDisplay = YES;
    
    [[Setting timeFrameList] enumerateTimeFrames:^(NSUInteger idx, TimeFrame *timeFrame) {
        Chart *subChart = [Chart createNewSubChartFromSaveDataSource:_saveDataSource];
        subChart.chartIndex = idx;
        subChart.currencyPair = self.currencyPair;
        subChart.timeFrame = timeFrame;
        
        if (idx == 0) {
            subChart.isDisplay = YES;
        } else {
            subChart.isDisplay = NO;
        }
        
    } execept:self.timeFrame];
}

- (void)delete
{
    NSManagedObjectContext *context = [[self class] coreDataManager].managedObjectContext;
    
    [context deleteObject:_saveDataSource];
    
    [self.orders delete];
    [self.openPositions delete];
    [self.executionOrders delete];
}

- (BOOL)validate
{
    if (self.slotNumber != 0 && self.currencyPair && self.timeFrame && self.startTime && self.spread && self.accountCurrency && self.startBalance && self.positionSizeOfLot && !self.spread.currencyPair.isAllCurrencyPair && !self.startBalance.currency.isAllCurrency && self.createdAt) {
        return YES;
    } else {
        return NO;
    }
}

- (void)saveWithCompletion:(void (^)())completion error:(void (^)())error
{
    if (![self validate]) {
        if (error) {
            error();
        }
        return;
    }
    
    if (self.isNew && !self.mainChart && !self.subChartChunk.existsChart) {
        [self setDefaultCharts];
    }
    
    NSError *saveError = nil;
    
    [[[self class] coreDataManager] saveContext:&saveError];
 
    if (saveError) {
        if (error) {
            error();
        }
    } else {
        self.isNew = NO;
        if (completion) {
            completion();
        }
    }
}

#pragma mark - getter,setter

- (Chart *)mainChart
{
    Chart *mainChart;
    
    for (ChartSource *chartSource in _saveDataSource.chartSources.allObjects) {
        Chart *chart = [Chart createChartFromChartSource:chartSource];
        if ([chart isMainChart]) {
            mainChart = chart;
        }
    }
    
    return mainChart;
}

- (ChartChunk *)subChartChunk
{
    NSMutableArray *subCharts = [NSMutableArray array];
    
    for (ChartSource *chartSource in _saveDataSource.chartSources.allObjects) {
        Chart *chart = [Chart createChartFromChartSource:chartSource];
        if ([chart isSubChart]) {
            [subCharts addObject:chart];
        }
    }
    
    return [[ChartChunk alloc] initWithChartArray:subCharts];
}

- (NSUInteger)slotNumber
{
    return _saveDataSource.slotNumber;
}

- (void)setSlotNumber:(NSUInteger)slotNumber
{
    _saveDataSource.slotNumber = (int)slotNumber;
}

- (CurrencyPair *)currencyPair
{
    return ((NSArray *)_saveDataSource.currencyPairs).firstObject;
}

- (void)setCurrencyPair:(CurrencyPair *)currencyPair
{
    super.currencyPair = self.currencyPair;
    
    super.currencyPair = currencyPair;
    
    NSArray *currencyPairs = @[super.currencyPair];
    
    _saveDataSource.currencyPairs = currencyPairs;
}

- (TimeFrame *)timeFrame
{
    return [[TimeFrame alloc] initWithMinute:_saveDataSource.timeFrame];
}

- (void)setTimeFrame:(TimeFrame *)timeFrame
{
    super.timeFrame = self.timeFrame;
    
    super.timeFrame = timeFrame;
    
    _saveDataSource.timeFrame = (int)super.timeFrame.minute;
}

- (Time *)startTime
{
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:_saveDataSource.startTime];
    
    return [[Time alloc] initWithDate:startDate];
}

- (void)setStartTime:(Time *)startTime
{
    super.startTime = self.startTime;
    
    super.startTime = startTime;
    
    _saveDataSource.startTime = super.startTime.date.timeIntervalSince1970;
}

- (Spread *)spread
{
    return ((NSArray *)_saveDataSource.spreads).firstObject;
}

- (void)setSpread:(Spread *)spread
{
    super.spread = self.spread;
    
    super.spread = spread;
    
    NSArray *spreads = @[super.spread];
    
    _saveDataSource.spreads = spreads;
}

- (Time *)lastLoadedTime
{
    NSDate *lastLoadedDate = [NSDate dateWithTimeIntervalSince1970:_saveDataSource.lastLoadedTime];
    
    return [[Time alloc] initWithDate:lastLoadedDate];
}

- (void)setLastLoadedTime:(Time *)lastLoadedTime
{
    if (!lastLoadedTime) {
        return;
    }
    
    _saveDataSource.lastLoadedTime = lastLoadedTime.date.timeIntervalSince1970;
}

- (Currency *)accountCurrency
{
    return _saveDataSource.accountCurrency;
}

- (void)setAccountCurrency:(Currency *)accountCurrency
{
    super.accountCurrency = self.accountCurrency;
    
    super.accountCurrency = accountCurrency;
    
    _saveDataSource.accountCurrency = super.accountCurrency;
}

- (PositionSize *)positionSizeOfLot
{
    return [[PositionSize alloc] initWithSizeValue:_saveDataSource.positionSizeOfLot];
}

- (void)setPositionSizeOfLot:(PositionSize *)positionSizeOfLot
{
    super.positionSizeOfLot = self.positionSizeOfLot;
    
    super.positionSizeOfLot = positionSizeOfLot;
    
    _saveDataSource.positionSizeOfLot = (int)super.positionSizeOfLot.sizeValue;
}

- (PositionSize *)tradePositionSize
{
    return [[PositionSize alloc] initWithSizeValue:_saveDataSource.tradePositionSize];
}

- (void)setTradePositionSize:(PositionSize *)tradePositionSize
{
    if (!tradePositionSize) {
        return;
    }
    
    PositionSize *maxTradePositionSize = [Setting maxTradePositionSize];
    NSComparisonResult resultMax = [maxTradePositionSize comparePositionSize:tradePositionSize];
    
    if (resultMax == NSOrderedAscending) {
        tradePositionSize = maxTradePositionSize;
    }
    
    PositionSize *minTradePositionSize = self.positionSizeOfLot;
    NSComparisonResult resultMin = [minTradePositionSize comparePositionSize:tradePositionSize];
    
    if (resultMin == NSOrderedDescending) {
        tradePositionSize = minTradePositionSize;
    }
    
    _saveDataSource.tradePositionSize = tradePositionSize.sizeValue;
}

- (Money *)startBalance
{
    return _saveDataSource.startBalance;
}

- (void)setStartBalance:(Money *)startBalance
{
    super.startBalance = self.startBalance;
    
    super.startBalance = startBalance;
    
    _saveDataSource.startBalance = super.startBalance;
}

- (Leverage *)leverage
{
    return [[Leverage alloc] initWithLeverage:_saveDataSource.leverage];
}

- (void)setLeverage:(Leverage *)leverage
{
    super.leverage = self.leverage;
    
    super.leverage = leverage;
    
    _saveDataSource.leverage = super.leverage.leverage;
}

- (BOOL)isAutoUpdate
{
    return _saveDataSource.isAutoUpdate;
}

- (void)setIsAutoUpdate:(BOOL)isAutoUpdate
{
    _saveDataSource.isAutoUpdate = isAutoUpdate;
}

- (float)autoUpdateIntervalSeconds
{
    return _saveDataSource.autoUpdateIntervalSeconds;
}

- (void)setAutoUpdateIntervalSeconds:(float)autoUpdateInterval
{
    float maxInterval = [Setting maxAutoUpdateIntervalSeconds];
    
    if (maxInterval < autoUpdateInterval) {
        autoUpdateInterval = maxInterval;
    }
    
    float minInterval = [Setting minAutoUpdateIntervalSeconds];
    
    if (minInterval > autoUpdateInterval) {
        autoUpdateInterval = minInterval;
    }
    
    _saveDataSource.autoUpdateIntervalSeconds = autoUpdateInterval;
}

- (NSDate *)createdAt
{
    return [NSDate dateWithTimeIntervalSince1970:_saveDataSource.createdAt];
}

- (void)setCreatedAt:(NSDate *)createdAt
{
    _saveDataSource.createdAt = createdAt.timeIntervalSince1970;
}

- (Account *)account
{
    if (!_account) {
        _account = [[Account alloc] initWithAccountCurrency:self.accountCurrency currencyPair:self.currencyPair startBalance:self.startBalance leverage:self.leverage openPositions:self.openPositions executionOrders:self.executionOrders market:self.market];
    }
    
    return _account;
}

- (OrderRelationChunk *)orders
{
    if (!_orders) {
        _orders = [[OrderRelationChunk alloc] initWithSaveSlot:self.slotNumber];
    }
    
    return _orders;
}

- (OpenPositionRelationChunk *)openPositions
{
    if (!_openPositions) {
        _openPositions = [[OpenPositionRelationChunk alloc] initWithSaveSlot:self.slotNumber];
    }
    
    return _openPositions;
}

- (ExecutionOrderRelationChunk *)executionOrders
{
    if (!_executionOrders) {
        _executionOrders = [[ExecutionOrderRelationChunk alloc] initWithSaveSlot:self.slotNumber];
    }
    
    return _executionOrders;
}

- (Market *)market
{
    if (!_market) {
        _market = [[Market alloc] initWithCurrencyPair:self.currencyPair timeFrame:self.timeFrame lastLoadedTime:self.lastLoadedTime spread:self.spread];
    }
    
    return _market;
}

@end
