//
//  SubChartDataViewController.m
//  FX Simulator
//
//  Created  on 2015/04/03.
//  
//

#import "SubChartDataViewController.h"

#import "ForexHistoryData.h"
#import "Rate.h"

@interface SubChartDataViewController ()
@property (weak, nonatomic) IBOutlet UIView *subChartDataView;
@property (weak, nonatomic) IBOutlet UILabel *startTimeValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *openValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *highValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *lowValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *closeValueLabel;
@end

@implementation SubChartDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)displayForexHistoryData:(ForexHistoryData *)forexHistoryData
{
    self.subChartDataView.hidden = NO;
    self.startTimeValueLabel.text = [forexHistoryData displayOpenTimestamp];
    self.endTimeValueLabel.text = [forexHistoryData displayCloseTimestamp];
    self.openValueLabel.text = [forexHistoryData.open toDisplayString];
    self.highValueLabel.text = [forexHistoryData.high toDisplayString];
    self.lowValueLabel.text = [forexHistoryData.low toDisplayString];
    self.closeValueLabel.text = [forexHistoryData.close toDisplayString];
}

- (void)hiddenForexHistoryData
{
    self.subChartDataView.hidden = YES;
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
