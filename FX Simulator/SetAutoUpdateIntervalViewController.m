//
//  SetAutoUpdateIntervalViewController.m
//  FX Simulator
//
//  Created  on 2015/05/16.
//  
//

#import "SetAutoUpdateIntervalViewController.h"

#import "ConfigViewController.h"

@interface SetAutoUpdateIntervalViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;
@end

static float kDefaultAutoUpdateInterval = 1.0;

@implementation SetAutoUpdateIntervalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.textField.text = @(self.delegate.autoUpdateIntervalSeconds).stringValue;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.textField resignFirstResponder];
    
    float inputInterval = [self.textField.text floatValue];
    
    if (0 < inputInterval) {
        self.delegate.autoUpdateIntervalSeconds = inputInterval;
    } else {
        self.delegate.autoUpdateIntervalSeconds = kDefaultAutoUpdateInterval;
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.textField resignFirstResponder];
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
