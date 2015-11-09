//
//  TradeViewController.m
//  ForexGame
//
//  Created  on 2014/06/05.
//  
//

#import "ChartViewController.h"

#import "Chart.h"
#import "Market.h"

@interface ChartViewController ()
@property (weak, nonatomic) IBOutlet UIView *visibleChartView;
@property (weak, nonatomic) IBOutlet UIScrollView *chartScrollView;

@end

@implementation ChartViewController {
    Chart *_chart;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [_chart chartScrollViewDidLoad];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_chart chartScrollViewDidScroll];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (IBAction)handleTapGesture:(UITapGestureRecognizer *)sender {
    if ([self.delegate respondsToSelector:@selector(chartViewTouched)]) {
        [self.delegate chartViewTouched];
    }
}

- (IBAction)handlePinchGesture:(UIPinchGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        [_chart scaleStart];
        [_chart scaleX:[sender scale]];
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        [_chart scaleX:[sender scale]];
    } else {
        [_chart scaleEnd];
    }
}

- (IBAction)handlePanGesture:(UIPanGestureRecognizer *)sender
{
    
}

- (IBAction)handleLongPressGesture:(UILongPressGestureRecognizer *) sender
{
    if (sender.state != UIGestureRecognizerStateEnded) {
        
        CGPoint pt = [sender locationInView:self.visibleChartView];
        
        ForexHistoryData *forexData = [_chart forexDataOfVisibleChartViewPoint:pt];
        
        if (!forexData) {
            return;
        }
        
        if ([self.delegate respondsToSelector:@selector(longPressedForexData:)]) {
            [self.delegate longPressedForexData:forexData];
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
    [_chart setChartScrollView:self.chartScrollView];
}

- (void)update:(Market *)market
{
    [_chart strokeCurrentChart:market];
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
