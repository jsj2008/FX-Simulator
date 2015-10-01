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
@end

@implementation ChartViewController {
    Chart *_chart;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.visibleChartView.layer.masksToBounds = YES;
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
    CGPoint location = [sender translationInView:self.visibleChartView];
    
    [_chart translate:location.x];
    
    [sender setTranslation:CGPointZero inView:self.visibleChartView];
}

- (IBAction)handleLongPressGesture:(UILongPressGestureRecognizer *) sender
{
    /*if (sender.state != UIGestureRecognizerStateEnded) {
        
        CGPoint pt = [sender locationInView:self.visibleChartView];
        
        _displayForexDataCount = 40;
        
        ForexHistoryData *data = [self.visibleChartView.chart getForexDataFromTouchPoint:pt displayCount:_displayForexDataCount viewSize:self.visibleChartView.frame.size];
        
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
        
    }*/
}

- (void)setChart:(Chart *)chart
{
    for (UIView *subView in [self.visibleChartView subviews]) {
        [subView removeFromSuperview];
    }
    
    _chart = chart;
    [_chart setVisibleChartView:self.visibleChartView];
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
