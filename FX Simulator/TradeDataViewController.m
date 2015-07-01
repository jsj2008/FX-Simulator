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
@property (nonatomic, readonly) TradeDataViewData *tradeDataViewData;
@end

@implementation TradeDataViewController {
    //float selfViewY;
    //float keyboardHigh;
    //TradeDataViewData *tradeDataViewData;
    //TradeDataView *tradeDataView;
}

/*-(id)init
{
    if (self = [super init]) {
        tradeDataViewData = [TradeDataViewData new];
    }
    
    return self;
}*/

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        _tradeDataViewData = [TradeDataViewData new];
    }
    
    return self;
}

/*-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        _InputLotField.inputAccessoryView = [TestView new];
    }
    
    return self;
}*/

/*- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}*/

-(void)loadView
{
    [super loadView];
    
    //tradeDataView = [TradeDataView new];
    
    //self.InputLotField.inputAccessoryView = [TestView new];
    
    //[self.view addSubview:tradeDataView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.tradeLotSettingButton setTitle:[self.tradeDataViewData.tradeLot toDisplayString] forState:self.tradeLotSettingButton.state];
    
    self.currentSettingLabel.text = self.tradeDataViewData.displayCurrentSetting;
    
    /*tradeDataView.tradeLotInputField.delegate = self;
    
    tradeDataView.tradeLotInputField.text = tradeDataViewData.tradeLotInputFieldValue;
    
    tradeDataView.autoUpdateSettingSwitch.on = tradeDataViewData.isAutoUpdate;
    
    [tradeDataView.autoUpdateSettingSwitch addTarget:self
                                              action:@selector(switchValueChanged:)
                                    forControlEvents:UIControlEventValueChanged];*/
    
    [self didOrder];
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    /*NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
    
    [nc addObserver:self
           selector:@selector(willShowKeyboard:)
               name:UIKeyboardWillShowNotification
             object:nil];*/
}

/*-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    selfViewY = self.view.frame.origin.y;
    
    float openPositionViewWidthSpace = 0;
    float openPositionViewBottomSpace = 0;
    
    tradeDataView.frame = CGRectMake(openPositionViewWidthSpace, 0, self.view.frame.size.width - openPositionViewWidthSpace*2, self.view.frame.size.height - openPositionViewBottomSpace);
}*/


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
    if ([keyPath isEqualToString:@"currentLoadedRowid"] && [object isKindOfClass:[Market class]]) {
        Market *market = (Market*)object;
        [self.tradeDataViewData updateForexHistoryData:market.currentForexHistoryData];
        self.profitAndLossLabel.text = self.tradeDataViewData.displayProfitAndLoss;
        self.profitAndLossLabel.textColor = self.tradeDataViewData.displayProfitAndLossColor;
        
        self.openPositionMarketValueLabel.text = self.tradeDataViewData.displayOpenPositionMarketValue;
        self.equityLabel.text = self.tradeDataViewData.displayEquity;
        self.equityLabel.textColor = self.tradeDataViewData.displayEquityColor;
    }
}

-(void)didOrder
{
    [self.tradeDataViewData didOrder];
    
    self.orderTypeLabel.text = self.tradeDataViewData.displayOrderType;
    self.orderTypeLabel.textColor = self.tradeDataViewData.displayOrderTypeColor;
    self.totalOpenLotLabel.text = self.tradeDataViewData.displayTotalLot;
    self.averageRateLabel.text = self.tradeDataViewData.displayAverageRate;
    
    self.profitAndLossLabel.text = self.tradeDataViewData.displayProfitAndLoss;
    self.profitAndLossLabel.textColor = self.tradeDataViewData.displayProfitAndLossColor;
    self.openPositionMarketValueLabel.text = self.tradeDataViewData.displayOpenPositionMarketValue;
    self.equityLabel.text = self.tradeDataViewData.displayEquity;
    self.equityLabel.textColor = self.tradeDataViewData.displayEquityColor;
    
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
        controller.defaultInputTradeLot = self.tradeDataViewData.tradeLot;
        
            //controller.isFirstAccess = NO;
        //}
    }
}

- (IBAction)tradeDataViewReturnActionForSegue:(UIStoryboardSegue *)segue
{
    InputTradeLotViewController *controller = segue.sourceViewController;
    
    self.tradeDataViewData.tradeLot = controller.inputTradeLot;
    
    [self.tradeLotSettingButton setTitle:[self.tradeDataViewData.tradeLot toDisplayString] forState:self.tradeLotSettingButton.state];
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
