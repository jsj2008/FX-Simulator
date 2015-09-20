//
//  SetSaveDataTableViewController.m
//  FXSimulator
//
//  Created by yuu on 2015/09/14.
//
//

#import "SetSaveDataTableViewController.h"

#import "CheckmarkViewController.h"
#import "Currency.h"
#import "CurrencyPair.h"
#import "InputNumberValueViewController.h"
#import "Money.h"
#import "PositionSize.h"
#import "SetStartTimeViewController.h"
#import "Setting.h"
#import "Spread.h"
#import "Time.h"
#import "TimeFrame.h"
#import "TimeFrameChunk.h"

@interface SetSaveDataTableViewController ()
@property (weak, nonatomic) IBOutlet UIButton *setCurrencyPairButton;
@property (weak, nonatomic) IBOutlet UIButton *setTimeScaleButton;
@property (weak, nonatomic) IBOutlet UIButton *setStartTimeButton;
@property (weak, nonatomic) IBOutlet UIButton *setSpreadButton;
@property (weak, nonatomic) IBOutlet UIButton *setAccountCurrencyButton;
@property (weak, nonatomic) IBOutlet UIButton *setStartBalanceButton;
@property (weak, nonatomic) IBOutlet UIButton *setPositionSizeOfLotButton;
@end

@implementation SetSaveDataTableViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        _slotNumber = 1;
    }
    
    return self;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"SetCurrencyPairSegue"]) {
        CheckmarkViewController *controller = segue.destinationViewController;
        NSArray *currencyPairList = [Setting currencyPairList];
        NSMutableArray *currencyPairStringValueList = [NSMutableArray array];
        [currencyPairList enumerateObjectsUsingBlock:^(CurrencyPair *obj, NSUInteger idx, BOOL *stop) {
            [currencyPairStringValueList addObject:obj.toDisplayString];
        }];
        controller.title = @"Currency Pair";
        controller.dataList = currencyPairList;
        controller.dataStringValueList = currencyPairStringValueList;
        controller.defaultData = self.currencyPair;
        controller.setData = ^(id selectData){
            if ([selectData isMemberOfClass:[CurrencyPair class]]) {
                self.currencyPair = selectData;
            }
        };
    } else if ([segue.identifier isEqualToString:@"SetTimeFrameSegue"]) {
        CheckmarkViewController *controller = segue.destinationViewController;
        TimeFrameChunk *timeFrameChunk = [Setting timeFrameList];
        NSMutableArray *timeFrameList = [NSMutableArray array];
        [timeFrameChunk enumerateTimeFrames:^(TimeFrame *timeFrame) {
            [timeFrameList addObject:timeFrame];
        }];
        NSMutableArray *timeFrameStringValueList = [NSMutableArray array];
        [timeFrameChunk enumerateTimeFrames:^(TimeFrame *timeFrame) {
            [timeFrameStringValueList addObject:timeFrame.toDisplayString];
        }];
        controller.title = @"Time Frame";
        controller.dataList = timeFrameList;
        controller.dataStringValueList = timeFrameStringValueList;
        controller.defaultData = self.timeFrame;
        controller.setData = ^(id selectData){
            if ([selectData isMemberOfClass:[TimeFrame class]]) {
                self.timeFrame = selectData;
            }
        };
    } else if ([segue.identifier isEqualToString:@"SetAccountCurrencySegue"]) {
        CheckmarkViewController *controller = segue.destinationViewController;
        NSArray *accountCurrencyList = [Setting accountCurrencyList];
        NSMutableArray *accountCurrencyStringValueList = [NSMutableArray array];
        [accountCurrencyList enumerateObjectsUsingBlock:^(Currency *currency, NSUInteger idx, BOOL *stop) {
            [accountCurrencyStringValueList addObject:currency.toDisplayString];
        }];
        controller.title = @"Account Currency";
        controller.dataList = accountCurrencyList;
        controller.dataStringValueList = accountCurrencyStringValueList;
        controller.defaultData = self.accountCurrency;
        controller.setData = ^(id selectData){
            if ([selectData isMemberOfClass:[Currency class]]) {
                self.accountCurrency = selectData;
            }
        };
    } else if ([segue.identifier isEqualToString:@"SetSpreadSegue"]) {
        InputNumberValueViewController *controller = segue.destinationViewController;
        controller.title = @"Spread";
        controller.defaultNumberValue = self.spread.spreadValueObj;
        controller.minNumberValue = @0.1;
        controller.maxNumberValue = @999;
        controller.setInputNumberValue = ^(NSNumber *inputNumberValue){
            self.spread = [[Spread alloc] initWithNumber:inputNumberValue currencyPair:nil];
        };
    } else if ([segue.identifier isEqualToString:@"SetStartBalanceSegue"]) {
        InputNumberValueViewController *controller = segue.destinationViewController;
        controller.title = @"Start Balance";
        controller.defaultNumberValue = self.startBalance.toMoneyValueObj;
        controller.minNumberValue = @1;
        controller.maxNumberValue = @999999999999;
        controller.setInputNumberValue = ^(NSNumber *inputNumberValue){
                self.startBalance = [[Money alloc] initWithNumber:inputNumberValue currency:nil];
        };
    } else if ([segue.identifier isEqualToString:@"SetPositionSizeOfLotSegue"]) {
        InputNumberValueViewController *controller = segue.destinationViewController;
        controller.title = @"Position Size Of Lot";
        controller.defaultNumberValue = self.positionSizeOfLot.sizeValueObj;
        controller.minNumberValue = @1;
        controller.maxNumberValue = @1000000;
        controller.setInputNumberValue = ^(NSNumber *inputNumberValue){
            self.positionSizeOfLot = [[PositionSize alloc] initWithNumber:inputNumberValue];
        };
    } else if ([segue.identifier isEqualToString:@"SetStartTimeSegue"]) {
        SetStartTimeViewController *controller = segue.destinationViewController;
        controller.title = @"Start Time";
        controller.defaultStartTime = self.startTime;
        controller.setStartTime = ^(Time *startTime){
            self.startTime = startTime;
        };
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.setCurrencyPairButton setTitle:[self.currencyPair toDisplayString] forState:self.setCurrencyPairButton.state];
    [self.setTimeScaleButton setTitle:[self.timeFrame toDisplayString] forState:self.setTimeScaleButton.state];
    [self.setStartTimeButton setTitle:[self.startTime toDisplayYMDString] forState:self.setStartTimeButton.state];
    [self.setSpreadButton setTitle:[self.spread toDisplayString] forState:self.setSpreadButton.state];
    [self.setAccountCurrencyButton setTitle:[self.accountCurrency toDisplayString] forState:self.setAccountCurrencyButton.state];
    [self.setStartBalanceButton setTitle:[self.startBalance toDisplayString] forState:self.setStartBalanceButton.state];
    [self.setPositionSizeOfLotButton setTitle:[self.positionSizeOfLot toDisplayString] forState:self.setPositionSizeOfLotButton.state];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

/*- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}*/

/*- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}*/

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
