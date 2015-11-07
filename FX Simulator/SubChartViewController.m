//
//  SubChartViewController.m
//  FX Simulator
//
//  Created  on 2014/11/13.
//  
//

#import "SubChartViewController.h"

#import "ChartViewController.h"
#import "Chart.h"
#import "ChartChunk.h"
#import "Market.h"
#import "SubChartDataViewController.h"
#import "TimeFrame.h"
#import "Rate.h"
#import "SaveData.h"
#import "SimulationManager.h"
#import "ForexDataChunk.h"
#import "ForexDataChunkStore.h"
#import "ForexHistoryData.h"
#import "CurrencyPair.h"

@interface SubChartViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;
@end

@implementation SubChartViewController {
    ChartViewController *_chartViewController;
    ForexDataChunkStore *_chunkStore;
    Market *_market;
    ChartChunk *_subChartChunk;
    SubChartDataViewController *_subChartDataViewController;
    NSArray *_charts;
}

- (void)loadSaveData:(SaveData *)saveData
{
    _subChartChunk = saveData.subChartChunk;
}

- (void)loadMarket:(Market *)market
{
    _market = market;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ChartViewControllerSeg"]) {
        _chartViewController = segue.destinationViewController;
        _chartViewController.delegate = self;
    } else if ([segue.identifier isEqualToString:@"SubChartDataViewControllerSeg"]) {
        _subChartDataViewController = segue.destinationViewController;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setSegment];
    
    //[self setInit];
    
    //_market = [SimulationManager sharedSimulationManager].market;
    
    [self strokeChartView];
}

- (void)longPressedForexData:(ForexHistoryData *)data
{
    [_subChartDataViewController displayForexHistoryData:data];
}

- (void)longPressedEnd
{
    [_subChartDataViewController hiddenForexHistoryData];
}

/*- (void)setInit
{
    [self setSegment];
}*/

-(void)setSegment
{
    //ChartChunk *subChartChunk = [SaveLoader load].subChartChunk;
    
    for (int i = 0; i < self.segment.numberOfSegments; i++) {
        Chart *subChart = [_subChartChunk getChartFromChartIndex:i];
        
        [self.segment setTitle:[subChart.timeFrame toDisplayString] forSegmentAtIndex:i];
        
        if (subChart.isDisplay) {
            self.segment.selectedSegmentIndex = subChart.chartIndex;
        }
    }
}

- (IBAction)panGesture:(UIPanGestureRecognizer*)sender {
    /*if (sender.state != UIGestureRecognizerStateEnded) {
        
        CGPoint pt = [sender locationInView:self.subChartView];
        
        for (Candle *candle in self.subChartView.candles) {
            CGRect candleZone = candle.rect;
            candleZone.origin.y = 0;
            candleZone.size.height = self.subChartView.frame.size.height;
            if (CGRectContainsPoint(candleZone,pt)) {
                ForexHistoryData *forexHistoryData = candle.forexHistoryData;
                [_subChartDataViewController displayForexHistoryData:forexHistoryData];
            }
        }
        
    } else {
        
        [_subChartDataViewController hiddenForexHistoryData];
        
    }*/
}

- (IBAction)segmentValueChanged:(id)sender {
    
    //ChartChunk *subChartChunk = [SaveLoader load].subChartChunk;
    
    Chart *newDisplayChart = [_subChartChunk getChartFromChartIndex:self.segment.selectedSegmentIndex];
    
    _subChartChunk.displayChart = newDisplayChart;
    
    Chart *displayChart = _subChartChunk.displayChart;
    
    _chunkStore = [[ForexDataChunkStore alloc] initWithCurrencyPair:displayChart.currencyPair timeScale:displayChart.timeFrame getMaxLimit:500];
    
    [self strokeChartView];
}

- (void)strokeChartView
{
    Chart *displayChart = _subChartChunk.displayChart;
    [_chartViewController setChart:displayChart];
    [_chartViewController update:_market];
}

/*-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint pt = [[touches anyObject] locationInView:subChartView];
    
    for (Candle *candle in subChartView.candles) {
        if (CGRectContainsPoint(candle.rect,pt)) {
            ForexHistoryData *forexHistoryData = candle.forexHistoryData;
            [subChartDataView setStartTime:forexHistoryData.displayOpenTimestamp closeTime:forexHistoryData.displayCloseTimestamp];
            subChartDataView.open = forexHistoryData.open.stringValue;
            subChartDataView.high = forexHistoryData.high.stringValue;
            subChartDataView.low = forexHistoryData.low.stringValue;
            subChartDataView.close = forexHistoryData.close.stringValue;
            
            [subChartDataView displayData];
        }
    }
    
}*/

/*-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [subChartDataView hiddenData];
}*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
