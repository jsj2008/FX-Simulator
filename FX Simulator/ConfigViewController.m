//
//  ConfigViewController.m
//  FX Simulator
//
//  Created  on 2014/10/30.
//  
//

#import "ConfigViewController.h"

#import "Market.h"
#import "SaveData.h"
#import "SaveLoader.h"
#import "SetAutoUpdateIntervalViewController.h"
#import "SimulationManager.h"

@interface ConfigViewController ()
@property (weak, nonatomic) IBOutlet UIButton *setAutoUpdateIntervalButton;

@end

@implementation ConfigViewController {
    Market *_market;
    SaveData *_saveData;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setInitData];
    }
    
    return self;
}

-(void)setInitData
{
    _market = [SimulationManager sharedSimulationManager].market;
    
    _saveData = [SaveLoader load];
    self.autoUpdateInterval = _saveData.autoUpdateInterval;
}

/*-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}*/

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //_saveData = [SaveLoader load];
    //self.autoUpdateInterval = _saveData.autoUpdateInterval;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.setAutoUpdateIntervalButton setTitle:self.autoUpdateInterval.stringValue forState:self.setAutoUpdateIntervalButton.state];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"SetAutoUpdateIntervalViewControllerSegue"]) {
        SetAutoUpdateIntervalViewController *controller = segue.destinationViewController;
        controller.delegate = self;
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    _saveData.autoUpdateInterval = self.autoUpdateInterval;
    _market.autoUpdateInterval = _saveData.autoUpdateInterval;
}

-(void)updatedSaveData
{
    [self setInitData];
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
