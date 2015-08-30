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
    TradeDataViewData *_tradeDataViewData;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        _tradeDataViewData = [TradeDataViewData new];
    }
    
    return self;
}

/*- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}*/

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.tradeLotSettingButton setTitle:[_tradeDataViewData.tradeLot toDisplayString] forState:self.tradeLotSettingButton.state];
    
    self.currentSettingLabel.text = _tradeDataViewData.displayCurrentSetting;
    
    [self didOrder];
}

-(void)update
{
    /*NSMutableArray *array = openPositionData.allPositions;
    
    openPositionView.totalLot = [NSNumber numberWithUnsignedLongLong:openPositionData.totalLot];
    
    for (OpenPositionRecord *record in array) {
        NSLog(@"ratesID %d orderRate %f", record.ratesId, record.orderRate);
    }*/
    
    //[openPositionView update];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{    
    if ([keyPath isEqualToString:@"currentTime"] && [object isKindOfClass:[Market class]]) {
        /*self.profitAndLossLabel.text = _tradeDataViewData.displayProfitAndLoss;
        self.profitAndLossLabel.textColor = _tradeDataViewData.displayProfitAndLossColor;
        self.openPositionMarketValueLabel.text = @"";
        self.equityLabel.text = _tradeDataViewData.displayEquity;
        self.equityLabel.textColor = _tradeDataViewData.displayEquityColor;*/
    }
}

-(void)didOrder
{
    [_tradeDataViewData didOrder];
    
    self.orderTypeLabel.text = _tradeDataViewData.displayOrderType;
    self.orderTypeLabel.textColor = _tradeDataViewData.displayOrderTypeColor;
    self.totalOpenLotLabel.text = _tradeDataViewData.displayTotalLot;
    self.averageRateLabel.text = _tradeDataViewData.displayAverageRate;
    
    self.profitAndLossLabel.text = _tradeDataViewData.displayProfitAndLoss;
    self.profitAndLossLabel.textColor = _tradeDataViewData.displayProfitAndLossColor;
    self.openPositionMarketValueLabel.text = @"";
    self.equityLabel.text = _tradeDataViewData.displayEquity;
    self.equityLabel.textColor = _tradeDataViewData.displayEquityColor;
    
    /*tradeDataView.displayAverageRate = tradeDataViewData.displayAverageRate;
    tradeDataView.displayOrderType = tradeDataViewData.displayOrderType;
    tradeDataView.displayOrderTypeColor = tradeDataViewData.displayOrderTypeColor;
    tradeDataView.displayTotalLot = tradeDataViewData.displayTotalLot;
    
    tradeDataView.displayProfitAndLoss = tradeDataViewData.displayProfitAndLoss;
    tradeDataView.displayProfitAndLossColor = tradeDataViewData.displayProfitAndLossColor;
    tradeDataView.displayOpenPositionMarketValue = tradeDataViewData.displayOpenPositionMarketValue;
    tradeDataView.displayEquity = tradeDataViewData.displayEquity;
    tradeDataView.displayEquityColor = tradeDataViewData.displayEquityColor;*/
}

/*-(BOOL)textFieldShouldBeginEditing:
(UITextField*)textField
{
    //self.view.transform = CGAffineTransformMakeTranslation(0, 300);
    //openPositionView.frame = CGRectMake(openPositionView.frame.origin.x, -100, openPositionView.frame.size.width, openPositionView.frame.size.height);
    //self.view.frame = CGRectMake(self.view.frame.origin.x, selfViewY - keyboardHigh, self.view.frame.size.width, self.view.frame.size.height);
    
    return YES;
}*/

// Return がタップされたとき
/*-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //openPositionView.frame = CGRectMake(openPositionView.frame.origin.x, 0, openPositionView.frame.size.width, openPositionView.frame.size.height);
    self.view.frame = CGRectMake(self.view.frame.origin.x, selfViewY, self.view.frame.size.width, self.view.frame.size.height);
    
    [textField resignFirstResponder];
    
    return YES;
}*/

/*-(void)textFieldDidEndEditing:(UITextField*)textField
{
    tradeDataViewData.tradeLotInputFieldValue = textField.text;
}*/

/*-(void)switchValueChanged:(id)sender
{
    UISwitch *sw = sender;
    
    tradeDataViewData.isAutoUpdate = sw.on;
    
    if ([_delegate respondsToSelector:@selector(autoUpdateSettingSwitchChanged:)]) {
        [_delegate autoUpdateSettingSwitchChanged:tradeDataViewData.isAutoUpdate];
    }
}*/

// Lot 入力のキーボードが立ち上がっているときに、タッチされたらキーボードをしまう
/*-(void)tradeViewTouchesBegan
{
    if ([tradeDataView.tradeLotInputField isFirstResponder]) {
        [tradeDataView.tradeLotInputField resignFirstResponder];
        self.view.frame = CGRectMake(self.view.frame.origin.x, selfViewY, self.view.frame.size.width, self.view.frame.size.height);
        //openPositionView.frame = CGRectMake(openPositionView.frame.origin.x, 0, openPositionView.frame.size.width, openPositionView.frame.size.height);
    }
}*/

// Lot 入力のためのキーボード
/*-(void)willShowKeyboard:(NSNotification*)notification
{
    CGRect keyboard;
    keyboard = [[notification.userInfo
                 objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardHigh = keyboard.size.height;
    
    CGRect mainScreenRect = [[UIScreen mainScreen] bounds];
    float newSelfViewY = mainScreenRect.size.height - keyboardHigh - tradeDataView.tradeLotInputField.frame.size.height - 15;
    
    self.view.frame = CGRectMake(self.view.frame.origin.x, newSelfViewY, self.view.frame.size.width, self.view.frame.size.height);
}*/

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"InputTradeLotViewControllerSegue"]) {
        InputTradeLotViewController *controller = segue.destinationViewController;
        //if (controller.isFirstAccess) {
        controller.defaultInputTradeLot = _tradeDataViewData.tradeLot;
        
            //controller.isFirstAccess = NO;
        //}
    }
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
