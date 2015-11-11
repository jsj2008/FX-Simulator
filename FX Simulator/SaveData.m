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
#import "Lot.h"
#import "Money.h"
#import "OpenPositionRelationChunk.h"
#import "PositionSize.h"
#import "Setting.h"
#import "Spread.h"
#import "Time.h"
#import "TimeFrame.h"
#import "TimeFrameChunk.h"

static BOOL FXSDefaultIsAutoUpdate = YES;
static float FXSDefaultAutoUpdateIntervalSeconds = 1.0;

@interface SaveData ()
@property (nonatomic) NSUInteger slotNumber;
@end

@implementation SaveData {
    SaveDataSource *_saveDataSource;
}

@synthesize account = _account;
@synthesize openPositions = _openPositions;
@synthesize executionOrders = _executionOrders;

+ (CoreDataManager *)coreDataManager
{
    return [CoreDataManager sharedManager];
}

+ (instancetype)createNewSaveDataFromSlotNumber:(NSUInteger)slotNumber currencyPair:(CurrencyPair *)currencyPair timeFrame:(TimeFrame *)timeFrame
{
    if (!currencyPair || !timeFrame) {
        return nil;
    }
    
    SaveDataSource *source = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([SaveDataSource class]) inManagedObjectContext:[self coreDataManager].managedObjectContext];
    
    SaveData *saveData = [[SaveData alloc] initWithSaveDataSource:source];
    
    saveData.slotNumber = slotNumber;
    saveData.currencyPair = currencyPair;
    saveData.timeFrame = timeFrame;
    
    [saveData setDefaultCharts];
    
    return saveData;
}

+ (instancetype)createDefaultNewSaveDataFromSlotNumber:(NSUInteger)slotNumber
{
    CurrencyPair *currencyPair = [[CurrencyPair alloc] initWithBaseCurrency:[[Currency alloc] initWithCurrencyType:USD] QuoteCurrency:[[Currency alloc] initWithCurrencyType:JPY]];
    TimeFrame *timeFrame = [[TimeFrame alloc] initWithMinute:15];
    
    SaveData *saveData = [self createNewSaveDataFromSlotNumber:slotNumber currencyPair:currencyPair timeFrame:timeFrame];
    
    saveData.startTime = [Setting rangeForSimulation].start;
    saveData.lastLoadedTime = saveData.startTime;
    saveData.spread = [[Spread alloc] initWithPips:1 currencyPair:saveData.currencyPair];
    saveData.accountCurrency = [[Currency alloc] initWithCurrencyType:JPY];
    saveData.startBalance = [[Money alloc] initWithAmount:1000000 currency:saveData.accountCurrency];
    saveData.positionSizeOfLot = [Setting defaultPositionSizeOfLot];
    
    saveData.tradePositionSize = [Setting defaultPositionSizeOfLot];
    saveData.isAutoUpdate = FXSDefaultIsAutoUpdate;
    saveData.autoUpdateIntervalSeconds = FXSDefaultAutoUpdateIntervalSeconds;
    
    return saveData;
}

+ (instancetype)createNewSaveDataFromMaterial:(id<NewSaveDataMaterial>)material
{
    if (![self validateMaterial:material]) {
        return nil;
    }
    
    SaveData *newSave = [SaveData createNewSaveDataFromSlotNumber:material.slotNumber currencyPair:material.currencyPair timeFrame:material.timeFrame];
    newSave.startTime = material.startTime;
    newSave.spread = [[Spread alloc] initWithPips:material.spread.spreadValue currencyPair:material.currencyPair];
    newSave.accountCurrency = material.accountCurrency;
    newSave.startBalance = [[Money alloc] initWithAmount:material.startBalance.amount currency:material.accountCurrency];
    newSave.positionSizeOfLot = material.positionSizeOfLot;
    
    newSave.lastLoadedTime = newSave.startTime;
    newSave.tradePositionSize = material.positionSizeOfLot;
    newSave.isAutoUpdate = FXSDefaultIsAutoUpdate;
    newSave.autoUpdateIntervalSeconds = FXSDefaultAutoUpdateIntervalSeconds;
    
    return newSave;
}

+ (BOOL)validateMaterial:(id<NewSaveDataMaterial>)material
{
    if (material.currencyPair && material.timeFrame && material.startTime && material.spread && material.accountCurrency && material.startBalance && material.positionSizeOfLot) {
        return YES;
    } else {
        return NO;
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
    
    SaveDataSource *source = nil;
    
    for (SaveDataSource *obj in objects) {
        source = obj;
    }
    
    return [[self alloc] initWithSaveDataSource:source];
}

- (instancetype)init
{
    return nil;
}

- (instancetype)initWithSaveDataSource:(SaveDataSource *)source
{
    if (source == nil) {
        return nil;
    }
    
    if (self = [super init]) {
        _saveDataSource = source;
    }
    
    return self;
}

- (void)setDefaultCharts
{
    if (self.currencyPair == nil || self.timeFrame == nil) {
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
    
    [self.openPositions delete];
    [self.executionOrders delete];
}

- (void)saveWithCompletion:(void (^)())completion error:(void (^)())error
{
    NSError *saveError = nil;
    
    [[[self class] coreDataManager] saveContext:&saveError];
 
    if (saveError) {
        if (error) {
            error();
        }
    } else {
        if (completion) {
            completion();
        }
    }
}

#pragma mark - getter,setter

- (Chart *)mainChart
{
    return [Chart createChartFromChartSource:[_saveDataSource.mainChartSources allObjects].firstObject];
}

- (ChartChunk *)subChartChunk
{
    NSMutableArray *subChartArray = [NSMutableArray array];
    
    [_saveDataSource.subChartSources enumerateObjectsUsingBlock:^(ChartSource *obj, BOOL *stop) {
        Chart *chart = [Chart createChartFromChartSource:obj];
        [subChartArray addObject:chart];
    }];
    
    return [[ChartChunk alloc] initWithChartArray:subChartArray];
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
    if (!currencyPair) {
        return;
    }
    
    NSArray *currencyPairs = @[currencyPair];
    
    _saveDataSource.currencyPairs = currencyPairs;
}

- (TimeFrame *)timeFrame
{
    return [[TimeFrame alloc] initWithMinute:_saveDataSource.timeFrame];
}

- (void)setTimeFrame:(TimeFrame *)timeFrame
{
    if (!timeFrame) {
        return;
    }
    
    _saveDataSource.timeFrame = (int)timeFrame.minute;
}

- (Time *)startTime
{
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:_saveDataSource.startTime];
    
    return [[Time alloc] initWithDate:startDate];
}

- (void)setStartTime:(Time *)startTime
{
    if (!startTime) {
        return;
    }
    
    _saveDataSource.startTime = startTime.date.timeIntervalSince1970;
}

- (Spread *)spread
{
    return ((NSArray *)_saveDataSource.spreads).firstObject;
}

- (void)setSpread:(Spread *)spread
{
    if (!spread) {
        return;
    }
    
    NSArray *spreads = @[spread];
    
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
    if (!accountCurrency) {
        return;
    }
    
    _saveDataSource.accountCurrency = accountCurrency;
}

- (PositionSize *)positionSizeOfLot
{
    return [[PositionSize alloc] initWithSizeValue:_saveDataSource.positionSizeOfLot];
}

- (void)setPositionSizeOfLot:(PositionSize *)positionSizeOfLot
{
    if (!positionSizeOfLot) {
        return;
    }
    
    _saveDataSource.positionSizeOfLot = (int)positionSizeOfLot.sizeValue;
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
    if (!startBalance) {
        return;
    }
    
    _saveDataSource.startBalance = startBalance;
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
    _saveDataSource.autoUpdateIntervalSeconds = autoUpdateInterval;
}

- (Account *)account
{
    if (!_account) {
        _account = [[Account alloc] initWithAccountCurrency:self.accountCurrency currencyPair:self.currencyPair startBalance:self.startBalance openPositions:self.openPositions executionOrders:self.executionOrders];
    }
    
    return _account;
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

@end
