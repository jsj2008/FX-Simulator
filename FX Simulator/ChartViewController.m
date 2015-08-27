//
//  TradeViewController.m
//  ForexGame
//
//  Created  on 2014/06/05.
//  
//

#import "ChartViewController.h"

#import "Chart.h"
#import "ChartView.h"
#import "ChartViewData.h"
#import "ForexDataChunk.h"
#import "ForexDataChunkStore.h"
#import "Indicator.h"
#import "Market.h"

@interface ChartViewController ()
@property (weak, nonatomic) IBOutlet ChartView *chartView;
@end

static const NSUInteger kMaxDisplayForexDataCount = 100;
static const NSUInteger kMinDisplayForexDataCount = 40;

@implementation ChartViewController {
    Chart *_chart;
    ForexDataChunk *_chunk;
    ForexDataChunk *_displayedForexDataChunk;
    ForexDataChunkStore *_store;
    NSUInteger _displayForexDataCount;
    float _updateDistance;
    float _previousX;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)panGesture:(id)sender {
    if ([self.delegate respondsToSelector:@selector(chartViewTouched)]) {
        [self.delegate chartViewTouched];
    }
}

- (IBAction)handlePanGesture:(UIPanGestureRecognizer *)sender
{
    if (_chunk == nil || _store == nil) {
        return;
    }
    
    CGPoint location = [sender translationInView:self.chartView];
    CGPoint velocity = [sender velocityInView:self.chartView];
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        _previousX = location.x;
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        float distanceX = location.x - _previousX;
        
        if ([self updateChartForMoveDistance:distanceX]) {
            _previousX = location.x;
        }
        
    }

}

- (BOOL)updateChartForMoveDistance:(float)distance
{
    if (distance < 0) {
        [self nextChart];
            
        return YES;
    } else if (0 < distance) {
        [self previousChart];
            
        return YES;
    }
    
    return NO;
}

- (void)previousChart
{
    /*ForexHistoryData *newCurrentData = [_displayedForexDataChunk getForexDataFromCurrent:1];
    if (newCurrentData == nil) {
        return;
    }
    _displayedForexDataChunk = [_store getChunkFromBaseData:newCurrentData limit:[ChartViewController requireForexDataCountForChart]];
    [self updateChartFor:_displayedForexDataChunk];*/
}

- (void)nextChart
{
    /*_displayedForexDataChunk = [_store getChunkFromNextDataOf:_displayedForexDataChunk.current limit:[ChartViewController requireForexDataCountForChart]];
    [self updateChartFor:_displayedForexDataChunk];*/
}


- (IBAction)handleLongPressGesture:(UILongPressGestureRecognizer *) sender
{
    if (sender.state != UIGestureRecognizerStateEnded) {
        
        CGPoint pt = [sender locationInView:self.chartView];
        
        _displayForexDataCount = 40;
        
        ForexHistoryData *data = [self.chartView.chart getForexDataFromTouchPoint:pt displayCount:_displayForexDataCount viewSize:self.chartView.frame.size];
        
        if (data == nil) {
            return;
        }
        
        if ([self.delegate respondsToSelector:@selector(longPressedForexData:)]) {
            [self.delegate longPressedForexData:data];
        }
        
    } else {
        
        if ([self.delegate respondsToSelector:@selector(longPressedEnd)]) {
            [self.delegate longPressedEnd];
        }
        
    }
}

- (void)setChart:(Chart *)chart
{
    _chart = chart;
    self.chartView.chart = _chart;
    [_chart setChartView:self.chartView];
    _store = [[ForexDataChunkStore alloc] initWithCurrencyPair:_chart.currencyPair timeScale:_chart.timeFrame getMaxLimit:[[self class] requireForexDataCountForChart]];
}

- (void)updateChartForTime:(MarketTime *)time
{
    ForexDataChunk *chunk = [_store getChunkFromBaseTime:time limit:[[self class] requireForexDataCountForChart]];
    [_chart setForexDataChunk:chunk];
    [self.chartView setNeedsDisplay];
    _displayedForexDataChunk = _chunk;
}

-(void)updatedSaveData
{
    self.chartView.chart = nil;
    [self.chartView setNeedsDisplay];
}

+ (NSUInteger)requireForexDataCountForChart
{
    return kMaxDisplayForexDataCount + [Indicator maxIndicatorPeriod] - 1;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
