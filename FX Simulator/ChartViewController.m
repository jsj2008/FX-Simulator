//
//  TradeViewController.m
//  ForexGame
//
//  Created  on 2014/06/05.
//  
//

#import "ChartViewController.h"

#import "ChartView.h"
#import "ChartViewData.h"
#import "ForexDataArray.h"
#import "Market.h"

@interface ChartViewController ()
@property (weak, nonatomic) IBOutlet ChartView *chartView;
@end

@implementation ChartViewController {
    //ChartView *_chartView;
    ChartViewData *_chartViewData;
}

/*-(id)init
{
    if (self = [super init]) {
        _chartViewData = [ChartViewData new];
    }
    
    return self;
}*/

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        _chartViewData = [ChartViewData new];
    }
    
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    //_chartView = [ChartView new];
    
}

/*- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)loadView
{
    [super loadView];
    
    chartView = [ChartView new];
    
    [self.view addSubview:chartView];
}*/

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //self.tlabel.text = @"bbb";
    
}

/*-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    chartView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    //chartView.backgroundColor = [UIColor blueColor];
    //chartView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    //[chartView setNeedsDisplay];
}*/

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"currentLoadedRowid"] && [object isKindOfClass:[Market class]]) {
        _chartViewData.chartDataArray = ((Market*)object).currentForexHistoryDataArray;
        self.chartView.chartDataArray.array = _chartViewData.chartDataArray;
        [self.chartView setNeedsDisplay];
    }
}

- (IBAction)panGesture:(id)sender {
    if ([self.delegate respondsToSelector:@selector(chartViewTouched)]) {
        [self.delegate chartViewTouched];
    }
}

-(void)updatedSaveData
{
    self.chartView.chartDataArray = nil;
    [self.chartView setNeedsDisplay];
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
