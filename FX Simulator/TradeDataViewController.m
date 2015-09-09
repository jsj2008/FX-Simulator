//
//  PositionViewController.m
//  ForexGame
//
//  Created  on 2014/06/06.
//  
//

#import "TradeDataViewController.h"

#import "Lot.h"
#import "TradeDataViewData.h"
#import "InputTradeLotViewController.h"
#import "Market.h"
#import "PositionSize.h"
#import "SaveData.h"
#import "SaveLoader.h"

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
    PositionSize *_positionSizeOfLot;
    TradeDataViewData *_tradeDataViewData;
}

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
        _positionSizeOfLot = [SaveLoader load].positionSizeOfLot;
        _tradeDataViewData = [TradeDataViewData new];
        _tradeDataViewData.positionSizeOfLot = _positionSizeOfLot;
    }
    
    return self;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"InputTradeLotViewControllerSegue"]) {
        InputTradeLotViewController *controller = segue.destinationViewController;
        controller.defaultInputTradeLot = _tradeDataViewData.tradeLot;
        controller.positionSizeOfLot = _positionSizeOfLot;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.tradeLotSettingButton setTitle:[_tradeDataViewData.tradeLot toDisplayString] forState:self.tradeLotSettingButton.state];
    
    self.currentSettingLabel.text = _tradeDataViewData.displayCurrentSetting;
    
    [self didOrder];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{    
    if ([keyPath isEqualToString:@"currentTime"] && [object isKindOfClass:[Market class]]) {
        self.profitAndLossLabel.text = _tradeDataViewData.displayProfitAndLoss;
        self.profitAndLossLabel.textColor = _tradeDataViewData.displayProfitAndLossColor;
        self.openPositionMarketValueLabel.text = @"";
        self.equityLabel.text = _tradeDataViewData.displayEquity;
        self.equityLabel.textColor = _tradeDataViewData.displayEquityColor;
    }
}

- (void)didOrder
{    
    self.orderTypeLabel.text = _tradeDataViewData.displayOrderType;
    self.orderTypeLabel.textColor = _tradeDataViewData.displayOrderTypeColor;
    self.totalOpenLotLabel.text = _tradeDataViewData.displayTotalLot;
    self.averageRateLabel.text = _tradeDataViewData.displayAverageRate;
    
    self.profitAndLossLabel.text = _tradeDataViewData.displayProfitAndLoss;
    self.profitAndLossLabel.textColor = _tradeDataViewData.displayProfitAndLossColor;
    self.openPositionMarketValueLabel.text = @"";
    self.equityLabel.text = _tradeDataViewData.displayEquity;
    self.equityLabel.textColor = _tradeDataViewData.displayEquityColor;
}

- (IBAction)tradeDataViewReturnActionForSegue:(UIStoryboardSegue *)segue
{
    InputTradeLotViewController *controller = segue.sourceViewController;
    
    _tradeDataViewData.tradeLot = controller.inputTradeLot;
    
    [self.tradeLotSettingButton setTitle:[_tradeDataViewData.tradeLot toDisplayString] forState:self.tradeLotSettingButton.state];
}

- (IBAction)autoUpdateSettingSwitchChanged:(id)sender {
    if ([self.delegate respondsToSelector:@selector(autoUpdateSettingSwitchChanged:)]) {
        [self.delegate autoUpdateSettingSwitchChanged:self.autoUpdateSettingSwitch.on];
    }
}

- (IBAction)dataLinkButtonTouched:(id)sender {
    NSString *urlString = @"http://www.forexite.com";
    NSURL *url = [NSURL URLWithString:urlString];
    [[UIApplication sharedApplication] openURL:url];
}

-(void)updatedSaveData
{
    _tradeDataViewData = [TradeDataViewData new];
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
