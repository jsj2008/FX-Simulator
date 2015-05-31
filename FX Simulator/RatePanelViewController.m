//
//  TradeViewController.m
//  ForexGame
//
//  Created  on 2014/06/05.
//  
//

#import "RatePanelViewController.h"

#import "RatePanelButton.h"
#import "UsersOrder.h"
#import "OrderType.h"
#import "OrderManagerFactory.h"
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
    __weak id<RatePanelViewControllerDelegate> _delegate; //!?
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

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        orderManager = [OrderManagerFactory createOrderManager];
        ratePanelViewData = [RatePanelViewData new];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"currentLoadedRowid"] && [object isKindOfClass:[Market class]]) {
        
        [ratePanelViewData updateCurrentMarket:(Market*)object];
    
        self.rateValueLabel.text = [ratePanelViewData getDisplayCurrentBidRate];
        
        /*[self.BidRatePanelButton setTitle:[ratePanelViewData getDisplayCurrentBidRate] forState:UIControlStateNormal];
        [self.AskRatePanelButton setTitle:[ratePanelViewData getDisplayCurrentAskRate] forState:UIControlStateNormal];*/
    }
}

/// Order執行
-(void)order:(OrderType *)orderType
{
    NSError *anError = nil;
    
    UsersOrder *usersOrder = [UsersOrder createFromCurrencyPair:ratePanelViewData.currencyPair  orderType:orderType  positionSize:ratePanelViewData.currentPositionSize rate:[ratePanelViewData getCurrentRateForOrderType:orderType] orderSpread:ratePanelViewData.spread];
    
    [orderManager execute:usersOrder error:&anError];
    
    if ([_delegate respondsToSelector:@selector(didOrder)]) {
        [_delegate didOrder];
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

/*- (IBAction)bidRateButtonTouched:(id)sender {
    OrderType *orderType = [[OrderType alloc] initWithShort];
    [self order:orderType];
}

- (IBAction)askRateButtonTouched:(id)sender {
    OrderType *orderType = [[OrderType alloc] initWithLong];
    [self order:orderType];
}*/

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
