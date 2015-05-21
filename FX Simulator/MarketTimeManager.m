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

static int defaultTime = 500;
static float  kDefaultUpdateTime = 1.0;
static NSString * const kKeyPath = @"time";

@interface MarketTimeManager ()

@property (nonatomic, readwrite) int time;

@end

@implementation MarketTimeManager {
    SaveData *saveData;
    ForexHistory *forexHistory;
    float startTime;
    float duration;
    CADisplayLink *_link;
}

-(id)init
{
    if (self = [super init]) {
        saveData = [SaveLoader load];
        forexHistory = [[ForexHistory alloc] initWithCurrencyPair:saveData.currencyPair timeScale:saveData.timeScale];
        [self loadTime];
        _isAutoUpdate = saveData.isAutoUpdate;
        
        self.autoUpdateInterval = saveData.autoUpdateInterval;
    }
    
    return self;
}

-(void)loadTime
{
    if (saveData.lastLoadedCloseTimestamp == 0) {
        _time = defaultTime;
    } else {
        ForexHistoryData *forexHistoryData = [forexHistory selectRowidLimitCloseTimestamp:saveData.lastLoadedCloseTimestamp];
        _time = forexHistoryData.close.timestamp.timestampValue;
    }
}

-(void)addObserver:(NSObject *)observer
{
    [self addObserver:observer forKeyPath:kKeyPath options:NSKeyValueObservingOptionNew context:NULL];
}

-(void)start
{
    _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(update:)];
    startTime = CACurrentMediaTime();
    [_link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    [self add];
}

-(void)add
{
    self.time++;
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

@end
