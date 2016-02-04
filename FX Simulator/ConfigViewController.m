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
#import "Setting.h"
#import "SimulationManager.h"

@interface ConfigViewController ()
@property (weak, nonatomic) IBOutlet UILabel *autoUpdateIntervalLabel;
@property (weak, nonatomic) IBOutlet UITableViewCell *autoUpdateIntervalViewCell;

@end

@implementation ConfigViewController {
    SimulationManager *_simulationManager;
}

- (void)loadSaveData:(SaveData *)saveData
{
    
}

- (void)loadSimulationManager:(SimulationManager *)simulationManager
{
    _simulationManager = simulationManager;
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
    
    self.autoUpdateIntervalLabel.text = @(_simulationManager.autoUpdateIntervalSeconds).stringValue;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.autoUpdateIntervalViewCell.backgroundColor = [Setting baseColor];
}

- (float)autoUpdateIntervalSeconds
{
    return _simulationManager.autoUpdateIntervalSeconds;
}

- (void)setAutoUpdateIntervalSeconds:(float)autoUpdateIntervalSeconds
{
    _simulationManager.autoUpdateIntervalSeconds = autoUpdateIntervalSeconds;
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
