//
//  PositionViewController.m
//  ForexGame
//
//  Created  on 2014/06/06.
//  
//

#import "TradeDataViewController.h"

#import "Account.h"
#import "CurrencyPair.h"
#import "Lot.h"
#import "Money.h"
#import "InputTradeLotViewController.h"
#import "Market.h"
#import "Result.h"
#import "PositionSize.h"
#import "SaveData.h"
#import "TimeFrame.h"

@interface TradeDataViewController ()
@property (weak, nonatomic) IBOutlet UILabel *orderTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalOpenLotLabel;
@property (weak, nonatomic) IBOutlet UILabel *averageRateLabel;
@property (weak, nonatomic) IBOutlet UILabel *profitAndLossLabel;
@property (weak, nonatomic) IBOutlet UILabel *openPositionMarketValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *equityLabel;
@property (weak, nonatomic) IBOutlet UIButton *tradeLotSettingButton;
@property (weak, nonatomic) IBOutlet UISwitch *autoUpdateSettingSwitch;
@property (weak, nonatomic) IBOutlet UILabel *currentSettingLabel;
@end

@implementation TradeDataViewController {
    Account *_account;
    CurrencyPair *_currencyPair;
    SaveData *_saveData;
    Market *_market;
    PositionSize *_positionSizeOfLot;
    TimeFrame *_timeFrame;
}

/*- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
 {
 self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
 if (self) {
 // Custom initialization
 }
 return self;
}*/

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"InputTradeLotViewControllerSegue"]) {
        InputTradeLotViewController *controller = segue.destinationViewController;
        [controller setDefaultTradePositionSize:_saveData.tradePositionSize];
        controller.positionSizeOfLot = _positionSizeOfLot;
    }
}

- (void)loadSaveData:(SaveData *)saveData
{
    _saveData = saveData;
    _account = saveData.account;
    _positionSizeOfLot = _saveData.positionSizeOfLot;
    _currencyPair = saveData.currencyPair;
    _timeFrame = saveData.timeFrame;
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

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self setTradeLotView];
    
    self.currentSettingLabel.text = [NSString stringWithFormat:@"%@ %@", [_currencyPair toDisplayString], [_timeFrame toDisplayString]];
    
    [self setTradeDataView];
    
    if ([self.delegate respondsToSelector:@selector(isAutoUpdate)]) {
        self.autoUpdateSettingSwitch.on = self.delegate.isAutoUpdate;
    }
}

- (void)didOrder:(Result *)result
{
    [result success:^{
        [self setTradeDataView];
    } failure:nil];
}

- (void)update
{
    [_account displayDataUsingBlock:^(NSString *equityStringValue, NSString *profitAndLossStringValue, NSString *orderTypeStringValue, NSString *averageRateStringValue, NSString *totalPositionSizeStringValue, UIColor *equityColor, UIColor *profitAndLossColor) {
        self.equityLabel.text = equityStringValue;
        self.equityLabel.textColor = equityColor;
        self.profitAndLossLabel.text = profitAndLossStringValue;
        self.profitAndLossLabel.textColor = profitAndLossColor;
    } positionSizeOfLot:_positionSizeOfLot];
}

- (IBAction)tradeDataViewReturnActionForSegue:(UIStoryboardSegue *)segue
{
    InputTradeLotViewController *controller = segue.sourceViewController;
    
    _saveData.tradePositionSize = controller.tradePositionSize;
    
    [self setTradeLotView];
}

- (IBAction)autoUpdateSettingSwitchChanged:(id)sender {
    if ([self.delegate respondsToSelector:@selector(autoUpdateSettingSwitchChanged:)]) {
        [self.delegate autoUpdateSettingSwitchChanged:self.autoUpdateSettingSwitch.on];
    }
}

- (void)setTradeDataView
{
    [_account displayDataUsingBlock:^(NSString *equityStringValue, NSString *profitAndLossStringValue, NSString *positionTypeStringValue, NSString *averageRateStringValue, NSString *totalLotStringValue, UIColor *equityStringColor, UIColor *profitAndLossStringColor) {
        self.equityLabel.text = equityStringValue;
        self.equityLabel.textColor = equityStringColor;
        self.profitAndLossLabel.text = profitAndLossStringValue;
        self.profitAndLossLabel.textColor = profitAndLossStringColor;
        self.orderTypeLabel.text = positionTypeStringValue;
        self.totalOpenLotLabel.text = totalLotStringValue;
        self.averageRateLabel.text = averageRateStringValue;
        self.equityLabel.text = equityStringValue;
        self.equityLabel.textColor = equityStringColor;
    } positionSizeOfLot:_positionSizeOfLot];
}

- (void)setTradeLotView
{
    Lot *tradeLot = [_saveData.tradePositionSize toLotFromPositionSizeOfLot:_positionSizeOfLot];
    
    [self.tradeLotSettingButton setTitle:tradeLot.toDisplayString forState:self.tradeLotSettingButton.state];
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
