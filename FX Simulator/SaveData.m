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
@property (nonatomic) BOOL isNew;
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

+ (instancetype)createNewSaveDataFromCurrencyPair:(CurrencyPair *)currencyPair timeFrame:(TimeFrame *)timeFrame
{
    if (!currencyPair || !timeFrame) {
        return nil;
    }
    
    NSUInteger slotNumber = [[self class] newSlotNumber];
    
    SaveDataSource *source = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([SaveDataSource class]) inManagedObjectContext:[self coreDataManager].managedObjectContext];
    
    SaveData *saveData = [[SaveData alloc] initWithSaveDataSource:source isNew:YES];
    
    saveData.slotNumber = slotNumber;
    saveData.currencyPair = currencyPair;
    saveData.timeFrame = timeFrame;
    
    return saveData;
}

+ (instancetype)createNewSaveData
{
    NSUInteger slotNumber = [[self class] newSlotNumber];
    
    SaveDataSource *source = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([SaveDataSource class]) inManagedObjectContext:[self coreDataManager].managedObjectContext];
    
    SaveData *saveData = [[SaveData alloc] initWithSaveDataSource:source isNew:YES];
    
    saveData.slotNumber = slotNumber;
   
    return saveData;
}

+ (instancetype)createDefaultNewSaveData
{
    CurrencyPair *currencyPair = [[CurrencyPair alloc] initWithBaseCurrency:[[Currency alloc] initWithCurrencyType:USD] QuoteCurrency:[[Currency alloc] initWithCurrencyType:JPY]];
    TimeFrame *timeFrame = [[TimeFrame alloc] initWithMinute:15];
    
    SaveData *saveData = [self createNewSaveDataFromCurrencyPair:currencyPair timeFrame:timeFrame];
    
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
    
    SaveData *newSave = [SaveData createNewSaveDataFromCurrencyPair:material.currencyPair timeFrame:material.timeFrame];
    
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
    
    [self.openPositions delete];
    [self.executionOrders delete];
}

- (BOOL)validate
{
    if (self.slotNumber != 0 && self.currencyPair && self.timeFrame && self.startTime && self.spread && self.accountCurrency && self.startBalance && self.positionSizeOfLot && !self.spread.currencyPair.isAllCurrencyPair && !self.startBalance.currency.isAllCurrency) {
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
