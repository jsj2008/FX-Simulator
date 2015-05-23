//
//  SetPositionSizeOfLotViewController.m
//  FX Simulator
//
//  Created  on 2015/05/12.
//  
//

#import "SetPositionSizeOfLotViewController.h"

#import "PositionSize.h"

@interface SetPositionSizeOfLotViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

static const NSInteger kDefautPositionSizeValue = 1;

@implementation SetPositionSizeOfLotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.textField.text = [self.delegate.positionSizeOfLot toDisplayString];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.textField resignFirstResponder];
    
    NSInteger inputPositionSize = [self.textField.text integerValue];
    
    if (0 < inputPositionSize) {
        self.delegate.positionSizeOfLot = [[PositionSize alloc] initWithSizeValue:inputPositionSize];
    } else {
        self.delegate.positionSizeOfLot = [[PositionSize alloc] initWithSizeValue:kDefautPositionSizeValue];
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
