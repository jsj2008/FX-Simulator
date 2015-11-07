//
//  ConfigViewController.m
//  FX Simulator
//
//  Created  on 2014/10/30.
//  
//

#import "ConfigViewController.h"

#import "SaveData.h"
#import "SetAutoUpdateIntervalViewController.h"
#import "SimulationManager.h"

@interface ConfigViewController ()
@property (weak, nonatomic) IBOutlet UIButton *setAutoUpdateIntervalButton;
@end

@implementation ConfigViewController {
    SimulationManager *_simulationManager;
}

- (void)loadSimulationManager:(SimulationManager *)simulationManager
{
    _simulationManager = simulationManager;
}

- (void)loadSaveData:(SaveData *)saveData
{
    _autoUpdateIntervalSeconds = saveData.autoUpdateIntervalSeconds;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"SetAutoUpdateIntervalViewControllerSegue"]) {
        SetAutoUpdateIntervalViewController *controller = segue.destinationViewController;
        controller.delegate = self;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.setAutoUpdateIntervalButton setTitle:@(self.autoUpdateIntervalSeconds).stringValue forState:self.setAutoUpdateIntervalButton.state];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [_simulationManager setAutoUpdateIntervalSeconds:self.autoUpdateIntervalSeconds];
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
