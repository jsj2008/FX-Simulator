//
//  CandleChart.m
//  FX Simulator
//
//  Created by yuu on 2015/07/05.
//
//

#import "Candle.h"

#import "CoreDataManager.h"
#import "Coordinate.h"
#import "CoordinateRange.h"
#import "SimpleCandle.h"
#import "CandleSource.h"
#import "CandlesFactory.h"
#import "ForexDataChunk.h"
#import "ForexHistoryData.h"

@implementation Candle {
    CandleSource *_source;
    NSArray *_candles;
    CGSize _imageSize;
    CGSize _displaySize;
}

+ (instancetype)createTemporaryDefaultCandle
{
    UIColor *upColor = [UIColor colorWithRed:35.0/255.0 green:170.0/255.0 blue:15.0/255.0 alpha:1.0];
    UIColor *downColor = [UIColor colorWithRed:200.0/255.0 green:35.0/255.0 blue:60.0/255.0 alpha:1.0];
    
    NSManagedObjectContext *context = [CoreDataManager sharedManager].managedObjectContext;
    
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:NSStringFromClass([CandleSource class]) inManagedObjectContext:context];
    CandleSource *source = [[CandleSource alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:nil];
    
    Candle *candle = [[Candle alloc] initWithCandleSource:source];
    candle.displayOrder = 0;
    candle.upColor = upColor;
    candle.upLineColor = upColor;
    candle.downColor = downColor;
    candle.downLineColor = downColor;
    
    return candle;
}

- (instancetype)initWithIndicatorSource:(IndicatorSource *)source
{
    return nil;
}

- (instancetype)initWithCandleSource:(CandleSource *)source
{
    if (self = [super initWithIndicatorSource:source]) {
        _source = source;
    }
    
    return self;
}

- (void)strokeIndicatorFromForexDataChunk:(ForexDataChunk *)chunk displayDataCount:(NSInteger)count imageSize:(CGSize)imageSize displaySize:(CGSize)displaySize
{
    if (!chunk) {
        return;
    }
    
    _imageSize = imageSize;
    _displaySize = displaySize;
    
    _candles = [CandlesFactory createCandlesFromForexHistoryDataChunk:chunk displayForexDataCount:count chartSize:_imageSize upColor:self.upColor upLineColor:self.upLineColor downColor:self.downColor downLineColor:self.downLineColor];
    
    for (SimpleCandle *candle in _candles) {
        [candle stroke];
    }
}

- (ForexDataChunk *)chunkRangeStartX:(float)startX endX:(float)endX
{
    startX = [self imageSizeXFromDisplaySizeX:startX];
    endX = [self imageSizeXFromDisplaySizeX:endX];
    
    NSMutableArray *rangeForexDataArray = [NSMutableArray array];
    
    for (SimpleCandle *candle in _candles) {
        float x = candle.areaRect.origin.x;
        if (startX <= (x + candle.areaRect.size.width) && x <= endX) {
            [rangeForexDataArray addObject:candle.forexHistoryData];
        }
    }
    
    return [[ForexDataChunk alloc] initWithForexDataArray:rangeForexDataArray];
}

- (ForexHistoryData *)forexDataOfPoint:(CGPoint)point
{
    float pointXOfImage = [self imageSizeXFromDisplaySizeX:point.x];
    
    for (SimpleCandle *candle in _candles) {
        float x = candle.areaRect.origin.x;
        float endX = candle.areaRect.origin.x + candle.areaRect.size.width;
        
        if (x <= pointXOfImage && pointXOfImage <= endX) {
            return candle.forexHistoryData;
        }
    }
    
    return nil;
}

- (ForexHistoryData *)leftEndForexData
{
    return ((SimpleCandle *)_candles.lastObject).forexHistoryData;
}

- (ForexHistoryData *)rightEndForexData
{
    return ((SimpleCandle *)_candles.firstObject).forexHistoryData;
}

- (SimpleCandle *)candleOfForexData:(ForexHistoryData *)forexData
{
    for (SimpleCandle *candle in _candles) {
        if ([forexData isEqualToForexData:candle.forexHistoryData]) {
            return candle;
        }
    }

    return nil;
}

- (CoordinateRange *)chartAreaOfForexData:(ForexHistoryData *)forexData
{
    SimpleCandle *candle = [self candleOfForexData:forexData];
    
    if (candle) {
        float begin = candle.areaRect.origin.x;
        float end = candle.areaRect.origin.x + candle.areaRect.size.width;
        
        begin = [self displaySizeXFromImageSizeX:begin];
        end = [self displaySizeXFromImageSizeX:end];
        
        return [[CoordinateRange alloc] initWithBegin:[[Coordinate alloc] initWithCoordinateValue:begin] end:[[Coordinate alloc] initWithCoordinateValue:end]];
    } else {
        return nil;
    }
}

/*- (float)zoneStartXOfForexDataFromLeftEnd:(NSUInteger)index
{
    SimpleCandle *candle = _candles[_candles.count - index];
    
    return candle.rect.origin.x;
}*/

- (ForexHistoryData *)forexDataFromLeftEnd:(NSUInteger)index
{
    SimpleCandle *candle = _candles[_candles.count - index];
    
    return candle.forexHistoryData;
}

- (Coordinate *)leftEndForexDataX
{
    float x = ((SimpleCandle *)_candles.lastObject).areaRect.origin.x;
    
    x = [self displaySizeXFromImageSizeX:x];
    
    return [[Coordinate alloc] initWithCoordinateValue:x];
}

- (Coordinate *)rightEndForexDataX
{
    SimpleCandle *rightEndCandle = _candles.firstObject;
    
    float x = rightEndCandle.areaRect.origin.x + rightEndCandle.areaRect.size.width;
    
    x = [self displaySizeXFromImageSizeX:x];
    
    return [[Coordinate alloc] initWithCoordinateValue:x];
}

- (float)displaySizeXFromImageSizeX:(float)imageSizeX
{
    float scaleX = 1;
    
    if (!CGSizeEqualToSize(_imageSize, _displaySize)) {
        scaleX = _displaySize.width / _imageSize.width;
    }
    
    return imageSizeX * scaleX;
}

- (float)imageSizeXFromDisplaySizeX:(float)displaySizeX
{
    float scaleX = 1;
    
    if (!CGSizeEqualToSize(_imageSize, _displaySize)) {
        scaleX = _imageSize.width / _displaySize.width;
    }
    
    return displaySizeX * scaleX;
}

#pragma mark - getter,setter

- (UIColor *)downColor
{
    return _source.downColor;
}

- (void)setDownColor:(UIColor *)downColor
{
    _source.downColor = downColor;
}

- (UIColor *)downLineColor
{
    return _source.downLineColor;
}

- (void)setDownLineColor:(UIColor *)downLineColor
{
    _source.downLineColor = downLineColor;
}

- (UIColor *)upColor
{
    return _source.upColor;
}

- (void)setUpColor:(UIColor *)upColor
{
    _source.upColor = upColor;
}

- (UIColor *)upLineColor
{
    return _source.upLineColor;
}

- (void)setUpLineColor:(UIColor *)upLineColor
{
    _source.upLineColor = upLineColor;
}

@end
