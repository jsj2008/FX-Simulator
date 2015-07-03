//
//  MarketTime.m
//  FX Simulator
//
//  Created  on 2014/11/19.
//  
//

#import "MarketTimeManager.h"

#import <QuartzCore/QuartzCore.h>
#import "SaveLoader.h"
#import "SaveData.h"
#import "CurrencyPair.h"
#import "Rate.h"
#import "MarketTime.h"
#import "ForexHistoryFactory.h"
#import "ForexHistory.h"
#import "ForexHistoryData.h"

static NSString * const kKeyPath = @"currentLoadedRowid";

@interface MarketTimeManager ()

@property (nonatomic, readwrite) int currentLoadedRowid;

@end

@implementation MarketTimeManager {
    SaveData *saveData;
    NSMutableArray *_observers;
    ForexHistory *forexHistory;
    float startTime;
    float duration;
    CADisplayLink *_link;
}

-(id)init
{
    if (self = [super init]) {
        [self setInitData];
        _observers = [NSMutableArray array];
    }
    
    return self;
}

-(void)setInitData
{
    saveData = [SaveLoader load];
    forexHistory = [[ForexHistory alloc] initWithCurrencyPair:saveData.currencyPair timeScale:saveData.timeScale];
    [self loadTime];
    self.autoUpdateInterval = saveData.autoUpdateInterval;
}

-(void)loadTime
{
    ForexHistoryData *forexHistoryData = [forexHistory selectRowidLimitCloseTimestamp:saveData.lastLoadedCloseTimestamp];
    _currentLoadedRowid = forexHistoryData.ratesID;
}

-(void)addObserver:(NSObject *)observer
{
    [_observers addObject:observer];
    
    [self addObserver:observer forKeyPath:kKeyPath options:NSKeyValueObservingOptionNew context:NULL];
}

-(void)removeObserver:(NSObject *)observer
{
    [self removeObserver:observer forKeyPath:kKeyPath];
}

-(void)start
{
    _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(update:)];
    startTime = CACurrentMediaTime();
    [_link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

-(void)end
{
    [_link removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    _link = nil;
}

-(void)add
{
    self.currentLoadedRowid++;
}

/*-(void)stop
{
    if (_link.paused != paused) {
        
        if (_link.paused == YES) {
            startTime = CACurrentMediaTime();
        }
        
        [_link setPaused:paused];
    }
}*/

-(void)update:(CADisplayLink *)link
{
    _link = link;
    duration = [link timestamp] - startTime;
    
    if (duration > self.autoUpdateInterval.floatValue) {
        startTime = [link timestamp];
        [self add];
    }
}

-(void)pause
{
    [self setIsAutoUpdate:NO];
}

-(void)resume
{
    [self setIsAutoUpdate:YES];
}

-(void)setIsAutoUpdate:(BOOL)isAutoUpdate
{
    if (YES == isAutoUpdate) {
        startTime = CACurrentMediaTime();
        [_link setPaused:NO];
    } else {
        [_link setPaused:YES];
    }
    
    /*if (_link.paused != isAutoUpdate) {
        
        if (_link.paused == YES) {
            startTime = CACurrentMediaTime();
        }
        
        [_link setPaused:isAutoUpdate];
    }*/
}

-(void)dealloc
{
    for (NSObject *obj in _observers) {
        [self removeObserver:obj forKeyPath:kKeyPath];
    }
}

@end
