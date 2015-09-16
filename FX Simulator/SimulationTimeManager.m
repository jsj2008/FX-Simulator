//
//  MarketTime.m
//  FX Simulator
//
//  Created  on 2014/11/19.
//  
//

#import "SimulationTimeManager.h"

#import <QuartzCore/QuartzCore.h>

static NSString * const kKeyPath = @"currentLoadedRowid";

@interface SimulationTimeManager ()
@property (nonatomic, readwrite) int currentLoadedRowid;
@end

@implementation SimulationTimeManager {
    BOOL _isAutoUpdate;
    NSMutableArray *_observers;
    float _autoUpdateIntervalSeconds;
    float startTime;
    float duration;
    CADisplayLink *_link;
}

- (instancetype)initWithAutoUpdateIntervalSeconds:(float)autoUpdateIntervalSeconds isAutoUpdate:(BOOL)isAutoUpdate
{
    if (self = [super init]) {
        _autoUpdateIntervalSeconds = autoUpdateIntervalSeconds;
        _currentLoadedRowid = 0;
        _isAutoUpdate = isAutoUpdate;
        _observers = [NSMutableArray array];
    }
    
    return self;
}

- (void)addObserver:(NSObject *)observer
{
    [_observers addObject:observer];
    
    [self addObserver:observer forKeyPath:kKeyPath options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)removeObserver:(NSObject *)observer
{
    [self removeObserver:observer forKeyPath:kKeyPath];
}

- (void)setAutoUpdateIntervalSeconds:(float)autoUpdateIntervalSeconds
{
    _autoUpdateIntervalSeconds = autoUpdateIntervalSeconds;
}

- (void)setIsAutoUpdate:(BOOL)isAutoUpdate
{
    _isAutoUpdate = isAutoUpdate;
}

- (void)start
{
    _isStart = YES;
    _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(update:)];
    startTime = CACurrentMediaTime();
    [_link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)end
{
    [_link removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    _link = nil;
}

- (void)add
{
    self.currentLoadedRowid++;
}

- (void)update:(CADisplayLink *)link
{
    if (!_isAutoUpdate) {
        return;
    }
    
    _link = link;
    duration = [link timestamp] - startTime;
    
    if (duration > _autoUpdateIntervalSeconds) {
        startTime = [link timestamp];
        [self add];
    }
}

- (void)pause
{
    [_link setPaused:YES];
}

- (void)resume
{
    startTime = CACurrentMediaTime();
    [_link setPaused:NO];
}

/*- (void)setIsAutoUpdate:(BOOL)isAutoUpdate
{
    if (YES == isAutoUpdate) {
        startTime = CACurrentMediaTime();
        [_link setPaused:NO];
    } else {
        [_link setPaused:YES];
    }
}*/

- (void)dealloc
{
    for (NSObject *obj in _observers) {
        [self removeObserver:obj forKeyPath:kKeyPath];
    }
}

@end
