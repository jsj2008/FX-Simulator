//
//  TradeViewController.m
//  ForexGame
//
//  Created  on 2014/06/05.
//  
//

#import "RatePanelViewController.h"

#import "RatePanelButton.h"
#import "Market.h"
#import "Order.h"
#import "OrderManager.h"
#import "OrderResult.h"
#import "PositionType.h"
#import "Rate.h"
#import "Rates.h"
#import "SaveData.h"
#import "Market.h"

@interface RatePanelViewController ()
@property (weak, nonatomic) IBOutlet UILabel *rateValueLabel;
@end

@implementation RatePanelViewController {
    NSUInteger _saveSlot;
    CurrencyPair *_currencyPair;
    Market *_market;
    OrderManager *_orderManager;
    SaveData *_saveData;
}

/*- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}*/

- (void)loadSaveData:(SaveData *)saveData
{
    _saveData = saveData;
    _saveSlot = saveData.slotNumber;
    _currencyPair = _saveData.currencyPair;
}

- (void)loadOrderManager:(OrderManager *)orderManager
{
    _orderManager = orderManager;
}

- (void)loadMarket:(Market *)market
{
    _market = market;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)update
{
    self.rateValueLabel.text = [self getDisplayCurrentBidRate];
}

- (void)order:(PositionType *)orderType
{
    Order *order = [[Order alloc] initWithSaveSlot:_saveSlot CurrencyPair:_currencyPair positionType:orderType rate:[self getCurrentRateForOrderType:orderType] positionSize:_saveData.tradePositionSize];
    
    [_orderManager order:order];
}

- (NSString *)getDisplayCurrentBidRate
{
    return [_market getCurrentRatesOfCurrencyPair:_currencyPair].bidRate.toDisplayString;
}

- (NSString *)getDisplayCurrentAskRate
{
    return [_market getCurrentRatesOfCurrencyPair:_currencyPair].askRate.toDisplayString;
}

- (Rate *)getCurrentRateForOrderType:(PositionType *)orderType
{
    if (orderType.isShort) {
        // return Bid Rate
        return [_market getCurrentRatesOfCurrencyPair:_currencyPair].bidRate;
    } else if (orderType.isLong) {
        // return Ask Rate
        return [_market getCurrentRatesOfCurrencyPair:_currencyPair].askRate;
    }
    
    return nil;
}

- (IBAction)sellButtonTouched:(id)sender {
    PositionType *orderType = [[PositionType alloc] initWithShort];
    [self order:orderType];
}

- (IBAction)buyButtonTouched:(id)sender {
    PositionType *orderType = [[PositionType alloc] initWithLong];
    [self order:orderType];
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
