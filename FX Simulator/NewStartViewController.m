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

- (void)loadSaveData:(SaveData *)saveData market:(Market *)market
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
        rootViewController.currencyPair = _saveData.currencyPair;
        rootViewController.timeFrame = _saveData.timeFrame;
        rootViewController.startTime = _saveData.startTime;
        rootViewController.accountCurrency = _saveData.accountCurrency;
        rootViewController.spread = _saveData.spread;
        rootViewController.startBalance = _saveData.startBalance;
        rootViewController.positionSizeOfLot = _saveData.positionSizeOfLot;
    }
}

- (IBAction)newStartButtonPushed:(id)sender {
    
    
}

- (IBAction)unwindFromCancelButton:(UIStoryboardSegue *)segue
{
    
}

- (IBAction)unwindFromDoneButton:(UIStoryboardSegue *)segue
{
    SetSaveDataTableViewController *controller = segue.sourceViewController;
        
    SaveData *newSave = [SaveData createNewSaveDataFromMaterial:controller];
    [newSave saveWithCompletion:^{
        ;
    } error:^{
        [newSave delete];
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
