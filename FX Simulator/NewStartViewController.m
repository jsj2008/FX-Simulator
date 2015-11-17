//
//  NewStartViewController.m
//  FX Simulator
//
//  Created  on 2015/04/26.
//  
//

#import "NewStartViewController.h"

#import "CoreDataManager.h"
#import "Currency.h"
#import "CurrencyPair.h"
#import "CheckmarkViewController.h"
#import "Time.h"
#import "Money.h"
#import "PositionSize.h"
#import "SetSaveDataTableViewController.h"
#import "Setting.h"
#import "Spread.h"
#import "TimeFrame.h"
#import "SaveData.h"
#import "SaveDataForm.h"
#import "SimulationManager.h"

@implementation NewStartViewController {
    SimulationManager *_simulationManager;
    NSHashTable *_delegates;
    SaveData *_saveData;
}

- (void)loadSimulationManager:(SimulationManager *)simulationManager
{
    _simulationManager = simulationManager;
}

- (void)loadSaveData:(SaveData *)saveData
{
    _saveData = saveData;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"SetSaveDataTableViewControllerSegue"]) {
        NSArray *viewControllers = ((UINavigationController *)segue.destinationViewController).viewControllers;
        SetSaveDataTableViewController *rootViewController = viewControllers.firstObject;
        SaveDataForm *saveDataForm = rootViewController.saveDataForm;
        saveDataForm.currencyPair = _saveData.currencyPair;
        saveDataForm.timeFrame = _saveData.timeFrame;
        saveDataForm.startTime = _saveData.startTime;
        saveDataForm.accountCurrency = _saveData.accountCurrency;
        saveDataForm.spread = _saveData.spread;
        saveDataForm.startBalance = _saveData.startBalance;
        saveDataForm.positionSizeOfLot = _saveData.positionSizeOfLot;
    }
}

- (IBAction)newStartButtonPushed:(id)sender {
    
    
}

- (IBAction)unwindFromCancelButton:(UIStoryboardSegue *)segue
{
    
}

- (IBAction)unwindFromDoneButton:(UIStoryboardSegue *)segue
{
    [_saveData delete];
    
    SetSaveDataTableViewController *controller = segue.sourceViewController;
    
    SaveData *newSaveData = [controller.saveDataForm createSaveData];
    
    [newSaveData saveWithCompletion:^{
        [_simulationManager startSimulationForSaveData:newSaveData];
    } error:^{
        [newSaveData delete];
    }];
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
