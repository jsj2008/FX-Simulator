//
//  SetStartBalanceViewController.m
//  FX Simulator
//
//  Created  on 2015/05/08.
//  
//

#import "SetStartBalanceViewController.h"

#import "SaveData.h"
#import "Money.h"

@interface SetStartBalanceViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

static const NSInteger kDefautStartBalanceValue = 1;

@implementation SetStartBalanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.textField.text = [self.saveData.startBalance toDisplayString];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.textField resignFirstResponder];
    
    NSInteger inputStartBalance = [[self.textField.text stringByReplacingOccurrencesOfString:@"," withString:@""] integerValue];
    
    if (0 < inputStartBalance) {
        self.saveData.startBalance = [[Money alloc] initWithAmount:inputStartBalance currency:nil];
    } else {
        self.saveData.startBalance = [[Money alloc] initWithAmount:kDefautStartBalanceValue currency:nil];
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
