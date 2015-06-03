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
#import "SaveDataFileStorage.h"
#import "SaveDataStorageFactory.h"
#import "Spread.h"
#import "MarketTimeScale.h"
#import "SaveData.h"
#import "SaveLoader.h"
#import "SetNewStartDataViewController.h"
#import "SimulationManager.h"


@interface NewStartViewController ()
@property (weak, nonatomic) IBOutlet UIButton *setCurrencyPairButton;
@property (weak, nonatomic) IBOutlet UIButton *setTimeScaleButton;
@property (weak, nonatomic) IBOutlet UIButton *setStartTimeButton;
@property (weak, nonatomic) IBOutlet UIButton *setSpreadButton;
@property (weak, nonatomic) IBOutlet UIButton *setAccountCurrencyButton;
@property (weak, nonatomic) IBOutlet UIButton *setStartBalanceButton;
@property (weak, nonatomic) IBOutlet UIButton *setPositionSizeOfLotButton;

@end

@implementation NewStartViewController {
    SaveData *_newSaveData;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        _newSaveData = [SaveData new];
        _newSaveData.slotNumber = 1;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    SaveData *saveData = [SaveLoader load];
    
    _newSaveData.currencyPair = saveData.currencyPair;
    _newSaveData.startTime = saveData.startTime;
    _newSaveData.timeScale = saveData.timeScale;
    _newSaveData.spread = saveData.spread;
    _newSaveData.accountCurrency = saveData.accountCurrency;
    _newSaveData.startBalance = saveData.startBalance;
    _newSaveData.positionSizeOfLot = saveData.positionSizeOfLot;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.setCurrencyPairButton setTitle:[_newSaveData.currencyPair toDisplayString] forState:self.setCurrencyPairButton.state];
    [self.setTimeScaleButton setTitle:[_newSaveData.timeScale toDisplayString] forState:self.setTimeScaleButton.state];
    [self.setStartTimeButton setTitle:[_newSaveData.startTime toDisplayYMDString] forState:self.setStartTimeButton.state];
    [self.setSpreadButton setTitle:[_newSaveData.spread toDisplayString] forState:self.setSpreadButton.state];
    [self.setAccountCurrencyButton setTitle:[_newSaveData.accountCurrency toDisplayString] forState:self.setAccountCurrencyButton.state];
    [self.setStartBalanceButton setTitle:[_newSaveData.startBalance toDisplayString] forState:self.setStartBalanceButton.state];
    [self.setPositionSizeOfLotButton setTitle:[_newSaveData.positionSizeOfLot toDisplayString] forState:self.setPositionSizeOfLotButton.state];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"SetCurrencyPairViewControllerSegue"] || [segue.identifier isEqualToString:@"SetTimeScaleViewControllerSegue"] || [segue.identifier isEqualToString:@"SetStartTimeViewControllerSegue"] || [segue.identifier isEqualToString:@"SetSpreadViewControllerSegue"] || [segue.identifier isEqualToString:@"SetAccountCurrencyViewControllerSegue"] || [segue.identifier isEqualToString:@"SetStartBalanceViewControllerSegue"] || [segue.identifier isEqualToString:@"SetPositionSizeOfLotViewControllerSegue"]) {
        SetNewStartDataViewController *controller = segue.destinationViewController;
        controller.saveData = _newSaveData;
    }
}

- (IBAction)newStartButtonPushed:(id)sender {
    id<SaveDataStorage> storage = [SaveDataStorageFactory createSaveDataStorage];
    
    [storage newSave:_newSaveData];
    
    [SaveLoader reloadSaveData];
    
    SimulationManager *simulationManager = [SimulationManager sharedSimulationManager];
    [simulationManager restartSimulation];
    
    [self.delegate updatedSaveData];
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
