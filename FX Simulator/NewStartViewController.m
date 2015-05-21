//
//  NewStartViewController.m
//  FX Simulator
//
//  Created  on 2015/04/26.
//  
//

#import "NewStartViewController.h"

#import "Currency.h"
#import "CurrencyPair.h"
#import "MarketTime.h"
#import "Money.h"
#import "PositionSize.h"
#import "Spread.h"
#import "MarketTimeScale.h"
#import "SaveData.h"
#import "SaveLoader.h"
#import "SetNewStartDataViewController.h"


@interface NewStartViewController ()
@property (weak, nonatomic) IBOutlet UIButton *setCurrencyPairButton;
@property (weak, nonatomic) IBOutlet UIButton *setTimeScaleButton;
@property (weak, nonatomic) IBOutlet UIButton *setStartTimeButton;
@property (weak, nonatomic) IBOutlet UIButton *setSpreadButton;
@property (weak, nonatomic) IBOutlet UIButton *setAccountCurrencyButton;
@property (weak, nonatomic) IBOutlet UIButton *setStartBalanceButton;
@property (weak, nonatomic) IBOutlet UIButton *setPositionSizeOfLotButton;

@end

@implementation NewStartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    SaveData *saveData = [SaveLoader load];
    
    self.currencyPair = saveData.currencyPair;
    self.startTime = saveData.startTime;
    self.timeScale = saveData.timeScale;
    self.spread = saveData.spread;
    self.accountCurrency = saveData.accountCurrency;
    self.startBalance = saveData.startBalance;
    self.positionSizeOfLot = saveData.positionSizeOfLot;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.setCurrencyPairButton setTitle:[self.currencyPair toDisplayString] forState:self.setCurrencyPairButton.state];
    [self.setTimeScaleButton setTitle:[self.timeScale toDisplayString] forState:self.setTimeScaleButton.state];
    [self.setStartTimeButton setTitle:[self.startTime toDisplayYMDString] forState:self.setStartTimeButton.state];
    [self.setSpreadButton setTitle:[self.spread toDisplayString] forState:self.setSpreadButton.state];
    [self.setAccountCurrencyButton setTitle:[self.accountCurrency toDisplayString] forState:self.setAccountCurrencyButton.state];
    [self.setStartBalanceButton setTitle:[self.startBalance toDisplayString] forState:self.setStartBalanceButton.state];
    [self.setPositionSizeOfLotButton setTitle:[self.positionSizeOfLot toDisplayString] forState:self.setPositionSizeOfLotButton.state];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"SetCurrencyPairViewControllerSegue"] || [segue.identifier isEqualToString:@"SetTimeScaleViewControllerSegue"] || [segue.identifier isEqualToString:@"SetStartTimeViewControllerSegue"] || [segue.identifier isEqualToString:@"SetSpreadViewControllerSegue"] || [segue.identifier isEqualToString:@"SetAccountCurrencyViewControllerSegue"] || [segue.identifier isEqualToString:@"SetStartBalanceViewControllerSegue"] || [segue.identifier isEqualToString:@"SetPositionSizeOfLotViewControllerSegue"]) {
        SetNewStartDataViewController *controller = segue.destinationViewController;
        controller.delegate = self;
    }
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
