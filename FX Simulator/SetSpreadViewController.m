//
//  SetSpreadViewController.m
//  FX Simulator
//
//  Created  on 2015/05/08.
//  
//

#import "SetSpreadViewController.h"

#import "SaveData.h"
#import "Spread.h"

@interface SetSpreadViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

static const NSInteger kDefautSpreadValue = 1;

@implementation SetSpreadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.textField.text = [self.saveData.spread toDisplayString];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.textField resignFirstResponder];
    
    NSInteger inputSpread = [self.textField.text integerValue];
    
    if (0 < inputSpread) {
        self.saveData.spread = [[Spread alloc] initWithPips:inputSpread currencyPair:nil];
    } else {
        self.saveData.spread = [[Spread alloc] initWithPips:kDefautSpreadValue currencyPair:nil];
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
