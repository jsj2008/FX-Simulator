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
#import "OrderType.h"
#import "OrderManager.h"
#import "RatePanelViewData.h"
#import "Market.h"

@interface RatePanelViewController ()
@property (weak, nonatomic) IBOutlet UILabel *rateValueLabel;
@property (weak, nonatomic) IBOutlet RatePanelButton *BidRatePanelButton;
@property (weak, nonatomic) IBOutlet RatePanelButton *AskRatePanelButton;
@end

@implementation RatePanelViewController {
    OrderManager *orderManager;
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
    orderManager = [OrderManager createOrderManager];
    orderManager.alertTarget = self;
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
- (void)order:(OrderType *)orderType
{
    Order *order = [[Order alloc] initWithOrderHistoryId:-1 CurrencyPair:ratePanelViewData.currencyPair orderType:orderType orderRate:[ratePanelViewData getCurrentRateForOrderType:orderType] positionSize:ratePanelViewData.currentPositionSize orderSpread:ratePanelViewData.spread];

    BOOL result = [orderManager execute:order];
    
    if (result) {
        if ([_delegate respondsToSelector:@selector(didOrder)]) {
            [_delegate didOrder];
        }
    }
}

- (IBAction)sellButtonTouched:(id)sender {
    OrderType *orderType = [[OrderType alloc] initWithShort];
    [self order:orderType];
}

- (IBAction)buyButtonTouched:(id)sender {
    OrderType *orderType = [[OrderType alloc] initWithLong];
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
