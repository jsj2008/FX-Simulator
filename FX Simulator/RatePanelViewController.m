//
//  TradeViewController.m
//  ForexGame
//
//  Created  on 2014/06/05.
//  
//

#import "RatePanelViewController.h"

#import "RatePanelButton.h"
#import "Order.h"
#import "PositionType.h"
#import "RatePanelViewData.h"
#import "Market.h"

@interface RatePanelViewController ()
@property (weak, nonatomic) IBOutlet UILabel *rateValueLabel;
@property (weak, nonatomic) IBOutlet RatePanelButton *BidRatePanelButton;
@property (weak, nonatomic) IBOutlet RatePanelButton *AskRatePanelButton;
@end

@implementation RatePanelViewController {
    RatePanelViewData *ratePanelViewData;
}

@synthesize delegate = _delegate;

/*- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}*/

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setInitData];
    }
    
    return self;
}

- (void)setInitData
{
    ratePanelViewData = [RatePanelViewData new];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"currentTime"] && [object isKindOfClass:[Market class]]) {
        
        [ratePanelViewData updateCurrentMarket:(Market*)object];
    
        self.rateValueLabel.text = [ratePanelViewData getDisplayCurrentBidRate];
    }
}

/// Order執行
- (void)order:(PositionType *)orderType
{
    Order *order = [[Order alloc] initWithCurrencyPair:ratePanelViewData.currencyPair positionType:orderType rate:[ratePanelViewData getCurrentRateForOrderType:orderType] positionSize:ratePanelViewData.currentPositionSize];
    
    order.alertTargetController = self;
    
    [order execute];
    
    if ([self.delegate respondsToSelector:@selector(didOrder)]) {
        [self.delegate didOrder];
    }
}

- (IBAction)sellButtonTouched:(id)sender {
    PositionType *orderType = [[PositionType alloc] initWithShort];
    [self order:orderType];
}

- (IBAction)buyButtonTouched:(id)sender {
    PositionType *orderType = [[PositionType alloc] initWithLong];
    [self order:orderType];
}

- (void)updatedSaveData
{
    [self setInitData];
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
