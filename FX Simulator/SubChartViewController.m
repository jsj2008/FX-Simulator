//
//  SubChartViewController.m
//  FX Simulator
//
//  Created  on 2014/11/13.
//  
//

#import "SubChartViewController.h"

#import "SubChartDataViewController.h"
#import "MarketTimeScale.h"
#import "SubChartView.h"
#import "SubChartViewData.h"
#import "Rate.h"
#import "ForexDataChunk.h"
#import "ForexDataChunkStore.h"
#import "ForexHistoryData.h"


@interface SubChartViewController ()
@property (weak, nonatomic) IBOutlet SubChartView *subChartView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;
@end

@implementation SubChartViewController {
    ForexDataChunkStore *_chunkStore;
    SubChartDataViewController *_subChartDataViewController;
    SubChartViewData *_subChartViewData;
    NSArray *_items;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setInitData];
    }
    
    return self;
}

-(void)setInitData
{
    _subChartViewData = [SubChartViewData new];
    _items = _subChartViewData.items;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"SubChartDataViewControllerSeg"]) {
        _subChartDataViewController = segue.destinationViewController;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.segment.selectedSegmentIndex = _subChartViewData.selectedSegmentIndex;
    
    ForexDataChunk *chunk = [_subChartViewData getCurrentChunk];
    _chunkStore = [[ForexDataChunkStore alloc] initWithCurrencyPair:chunk.current.currencyPair timeScale:self.selectedTimeScale getMaxLimit:500];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setItems:_items forSegment:self.segment];
    
    [self strokeChartView];
}

-(void)setItems:(NSArray*)items forSegment:(UISegmentedControl*)segment
{
    for (int i = 0; i < segment.numberOfSegments; i++) {
        [segment setTitle:[items objectAtIndex:i] forSegmentAtIndex:i];
    }
}

/*-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];*/
    
    /*NSArray *forexTimeScaleDataArray = [_subChartViewData getChartDataArray];
    
    self.subChartView.candles = [CandlesFactory createCandlesFromForexHistoryDataArray:forexTimeScaleDataArray chartViewWidth:self.subChartView.frame.size.width chartViewHeight:self.subChartView.frame.size.height];
    
    [self.subChartView setNeedsDisplay];*/
//}

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
    
    _subChartViewData.selectedSegmentIndex = self.segment.selectedSegmentIndex;
    
    ForexDataChunk *chunk = [_subChartViewData getCurrentChunk];
    
    _chunkStore = [[ForexDataChunkStore alloc] initWithCurrencyPair:chunk.current.currencyPair timeScale:self.selectedTimeScale getMaxLimit:500];
    
    [self strokeChartView];
}

- (void)strokeChartView
{
    ForexDataChunk *chunk = [_subChartViewData getCurrentChunk];
    
    self.subChartView.chunk = [_chunkStore getChunkFromBaseData:chunk.current limit:500];
    
    [self.subChartView setNeedsDisplay];
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

-(void)updatedSaveData
{
    [self setInitData];
}

- (MarketTimeScale *)selectedTimeScale
{
    return _subChartViewData.selectedTimeScale;
}

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
