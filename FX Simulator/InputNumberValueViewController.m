//
//  InputNumberValueViewController.m
//  FXSimulator
//
//  Created by yuu on 2015/09/16.
//
//

#import "InputNumberValueViewController.h"

@interface InputNumberValueViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;
@end

@implementation InputNumberValueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.textField.text = self.defaultNumberValue.stringValue;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    
    NSNumber *normalizedNumber = [self normalizeNumber:[formatter numberFromString:self.textField.text]];
    
    if (self.setInputNumberValue && normalizedNumber) {
        self.setInputNumberValue(normalizedNumber);
    }
    
    [self.textField resignFirstResponder];
}

- (NSNumber *)normalizeNumber:(NSNumber *)number
{
    if (!number) {
        return nil;
    }
    
    NSComparisonResult result1 = [self.minNumberValue compare:number];
    
    if (result1 == NSOrderedDescending) {
        return self.minNumberValue;
    }
    
    NSComparisonResult result2 = [self.maxNumberValue compare:number];
    
    if (result2 == NSOrderedAscending) {
        return self.maxNumberValue;
    }
    
    return number;
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
