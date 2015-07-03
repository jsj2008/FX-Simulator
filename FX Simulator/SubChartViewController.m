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
#import "ForexHistoryData.h"
#import "CandlesFactory.h"
#import "Candle.h"

@interface SubChartViewController ()
@property (weak, nonatomic) IBOutlet SubChartView *subChartView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;
@end

@implementation SubChartViewController {
    //SubChartView *subChartView;
    //SubChartDataView *subChartDataView;
    SubChartDataViewController *_subChartDataViewController;
    //UISegmentedControl *_segment;
    SubChartViewData *_subChartViewData;
    NSArray *_items;
}

/*-(id)init
{
    if (self = [super init]) {
        //subChartDataView = [SubChartDataView new];
        subChartViewData = [SubChartViewData new];
        items = subChartViewData.items;
    }
    
    return self;
}*/

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setInitData];
    }
    
    return self;
}

/*-(void)loadView
{
    [super loadView];
    
    //subChartView = [SubChartView new];
    
    //self.segment = [[UISegmentedControl alloc] initWithItems:items];
    
    //[self.view addSubview:subChartView];
    //[self.view addSubview:_segment];
    //[self.view addSubview:subChartDataView];
}*/

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"SubChartDataViewControllerSeg"]) {
        _subChartDataViewController = segue.destinationViewController;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //self.segment.selectedSegmentIndex = 0;
    /*[self.segment addTarget:self
                 action:@selector(segmentValueChanged:)
       forControlEvents:UIControlEventValueChanged];*/
    
    //self.segment = [[UISegmentedControl alloc] initWithItems:items];
    
    
    /*CGRect mainScreenRect = [[UIScreen mainScreen] applicationFrame];
    float statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    float adViewHeight = 49.0;
    float uiTabBarHeight = 49.0;
    
    float chartViewY = statusBarHeight;
    float chartViewWidth = mainScreenRect.size.width;
    float chartViewHeight = (mainScreenRect.size.height - adViewHeight - uiTabBarHeight)*1.6/2.6;
    
    self.view.frame = CGRectMake(0, 0, mainScreenRect.size.width, statusBarHeight + mainScreenRect.size.height - uiTabBarHeight);
    NSLog(@"%f", self.view.frame.size.height);
    subChartView.frame = CGRectMake(0, chartViewY, chartViewWidth, chartViewHeight);*/
}

-(void)setItems:(NSArray*)items forSegment:(UISegmentedControl*)segment
{
    for (int i = 0; i < segment.numberOfSegments; i++) {
        [segment setTitle:[items objectAtIndex:i] forSegmentAtIndex:i];
    }
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    /*CGRect mainScreenRect = [[UIScreen mainScreen] applicationFrame];
    float statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    float adViewHeight = 49.0;
    float uiTabBarHeight = 49.0;
    
    
    float chartViewY = statusBarHeight;
    float chartViewWidth = mainScreenRect.size.width;
    float chartViewHeight = (mainScreenRect.size.height - adViewHeight - uiTabBarHeight)*1.6/2.6;
    
    self.view.frame = CGRectMake(0, 0, mainScreenRect.size.width, statusBarHeight + mainScreenRect.size.height - uiTabBarHeight);
    
    subChartView.frame = CGRectMake(0, chartViewY, chartViewWidth, chartViewHeight);*/
    
    
    /*_segment.frame = CGRectMake(0, 0, 250, 30);
    _segment.center = CGPointMake([[UIScreen mainScreen] bounds].size.width / 2, subChartView.frame.origin.y + subChartView.frame.size.height + _segment.frame.size.height + 30);
    _segment.selectedSegmentIndex = 0;
    [_segment addTarget:self
                action:@selector(segmentValueChanged:)
      forControlEvents:UIControlEventValueChanged];
    
    
    float subChartDataViewSideSpace = 15;
    float subChartDataViewBottomSpace = 15;
    float subChartDataViewX = subChartDataViewSideSpace;
    float subChartDataViewY = _segment.center.y + _segment.frame.size.height;
    float subChartDataViewWidth = self.view.frame.size.width - subChartDataViewSideSpace * 2;
    float subChartDataViewHeight = self.view.frame.size.height - subChartDataViewY - subChartDataViewBottomSpace;
    
    subChartDataView.frame = CGRectMake(subChartDataViewX, subChartDataViewY, subChartDataViewWidth, subChartDataViewHeight);*/
    
    
    
    NSArray *forexTimeScaleDataArray = [_subChartViewData getChartDataArray];
    
    self.subChartView.candles = [CandlesFactory createCandlesFromForexHistoryDataArray:forexTimeScaleDataArray chartViewWidth:self.subChartView.frame.size.width chartViewHeight:self.subChartView.frame.size.height];
    
    [self.subChartView setNeedsDisplay];
}

- (IBAction)panGesture:(UIPanGestureRecognizer*)sender {
    if (sender.state != UIGestureRecognizerStateEnded) {
        
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
        
    }
}

- (IBAction)segmentValueChanged:(id)sender {
    MarketTimeScale *timeScale = [_subChartViewData toTimeScalefFromSegmentIndex:self.segment.selectedSegmentIndex];
    
    NSArray *forexTimeScaleDataArray = [_subChartViewData getChartDataArrayWithTimeScale:timeScale];
    
    self.subChartView.candles = [CandlesFactory createCandlesFromForexHistoryDataArray:forexTimeScaleDataArray chartViewWidth:self.subChartView.frame.size.width chartViewHeight:self.subChartView.frame.size.height];
    
    [self.subChartView setNeedsDisplay];
}

/*-(void)segmentValueChanged:(id)sender
{
    //UISegmentedControl *segment = (UISegmentedControl *)sender;
    
    MarketTimeScale *timeScale = [_subChartViewData toTimeScalefFromSegmentIndex:self.segment.selectedSegmentIndex];
    
    NSArray *forexTimeScaleDataArray = [_subChartViewData getChartDataArrayWithTimeScale:timeScale];
    
    self.subChartView.candles = [CandlesFactory createCandlesFromForexHistoryDataArray:forexTimeScaleDataArray chartViewWidth:self.subChartView.frame.size.width chartViewHeight:self.subChartView.frame.size.height];
    
    [self.subChartView setNeedsDisplay];
}*/

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setItems:_items forSegment:self.segment];
    
    /*CGRect mainScreenRect = [[UIScreen mainScreen] applicationFrame];
    float statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    float adViewHeight = 49.0;
    float uiTabBarHeight = 49.0;
    
    float chartViewY = statusBarHeight;
    float chartViewWidth = mainScreenRect.size.width;
    float chartViewHeight = (mainScreenRect.size.height - adViewHeight - uiTabBarHeight)*1.6/2.6;*/
    
    //self.view.frame = CGRectMake(0, 0, mainScreenRect.size.width, statusBarHeight + mainScreenRect.size.height - uiTabBarHeight);
    /*subChartView.frame = CGRectMake(0, chartViewY, chartViewWidth, chartViewHeight);
    
    
    
    NSArray *forexTimeScaleDataArray = [subChartViewData getChartDataArray];
    
    subChartView.candles = [CandlesFactory createCandlesFromForexHistoryDataArray:forexTimeScaleDataArray chartViewWidth:subChartView.frame.size.width chartViewHeight:subChartView.frame.size.height];
    
    [subChartView setNeedsDisplay];*/
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

-(void)setInitData
{
    _subChartViewData = [SubChartViewData new];
    _items = _subChartViewData.items;
}

-(void)updatedSaveData
{
    [self setInitData];
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
