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
#import "SaveData.h"
#import "SaveDataForm.h"
#import "SetStartTimeViewController.h"
#import "Setting.h"
#import "Spread.h"
#import "Time.h"
#import "TimeFrame.h"
#import "TimeFrameChunk.h"

@interface SetSaveDataTableViewController ()
@property (weak, nonatomic) IBOutlet UILabel *currencyPairLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeFrameLabel;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *spreadLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountCurrencyLabel;
@property (weak, nonatomic) IBOutlet UILabel *startBalanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *positionSizeOfLotLabel;
@end

@implementation SetSaveDataTableViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        _saveDataForm = [SaveDataForm new];
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
        controller.title = NSLocalizedString(@"Currency Pair", nil);
        controller.dataList = currencyPairList;
        controller.dataStringValueList = currencyPairStringValueList;
        controller.defaultData = self.saveDataForm.currencyPair;
        controller.setData = ^(id selectData){
            if ([selectData isMemberOfClass:[CurrencyPair class]]) {
                self.saveDataForm.currencyPair = selectData;
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
        controller.title = NSLocalizedString(@"Time Frame", nil);
        controller.dataList = timeFrameList;
        controller.dataStringValueList = timeFrameStringValueList;
        controller.defaultData = self.saveDataForm.timeFrame;
        controller.setData = ^(id selectData){
            if ([selectData isMemberOfClass:[TimeFrame class]]) {
                self.saveDataForm.timeFrame = selectData;
            }
        };
    } else if ([segue.identifier isEqualToString:@"SetAccountCurrencySegue"]) {
        CheckmarkViewController *controller = segue.destinationViewController;
        NSArray *accountCurrencyList = [Setting accountCurrencyList];
        NSMutableArray *accountCurrencyStringValueList = [NSMutableArray array];
        [accountCurrencyList enumerateObjectsUsingBlock:^(Currency *currency, NSUInteger idx, BOOL *stop) {
            [accountCurrencyStringValueList addObject:currency.toDisplayString];
        }];
        controller.title = NSLocalizedString(@"Account Currency", nil);
        controller.dataList = accountCurrencyList;
        controller.dataStringValueList = accountCurrencyStringValueList;
        controller.defaultData = self.saveDataForm.accountCurrency;
        controller.setData = ^(id selectData){
            if ([selectData isMemberOfClass:[Currency class]]) {
                self.saveDataForm.accountCurrency = selectData;
            }
        };
    } else if ([segue.identifier isEqualToString:@"SetSpreadSegue"]) {
        InputNumberValueViewController *controller = segue.destinationViewController;
        controller.isDecimal = YES;
        controller.title = NSLocalizedString(@"Spread", nil);
        controller.defaultNumberValue = self.saveDataForm.spread.spreadValueObj;
        controller.setInputNumberValue = ^(NSNumber *inputNumberValue){
            self.saveDataForm.spread = [[Spread alloc] initWithNumber:inputNumberValue currencyPair:[CurrencyPair allCurrencyPair]];
        };
    } else if ([segue.identifier isEqualToString:@"SetStartBalanceSegue"]) {
        InputNumberValueViewController *controller = segue.destinationViewController;
        controller.title = NSLocalizedString(@"Start Balance", nil);
        controller.defaultNumberValue = self.saveDataForm.startBalance.toMoneyValueObj;
        controller.setInputNumberValue = ^(NSNumber *inputNumberValue){
                self.saveDataForm.startBalance = [[Money alloc] initWithNumber:inputNumberValue currency:[Currency allCurrency]];
        };
    } else if ([segue.identifier isEqualToString:@"SetPositionSizeOfLotSegue"]) {
        CheckmarkViewController *controller = segue.destinationViewController;
        NSArray *positionSizeOfLotList = [Setting positionSizeOfLotList];
        NSMutableArray *PositionSizeOfLotStringValueList = [NSMutableArray array];
        [positionSizeOfLotList enumerateObjectsUsingBlock:^(PositionSize *obj, NSUInteger idx, BOOL *stop) {
            [PositionSizeOfLotStringValueList addObject:obj.toDisplayString];
        }];
        controller.title = @"1 Lot =";
        controller.dataList = positionSizeOfLotList;
        controller.dataStringValueList = PositionSizeOfLotStringValueList;
        controller.defaultData = self.saveDataForm.positionSizeOfLot;
        controller.setData = ^(id selectData){
            if ([selectData isMemberOfClass:[PositionSize class]]) {
                self.saveDataForm.positionSizeOfLot = selectData;
            }
        };
    } else if ([segue.identifier isEqualToString:@"SetStartTimeSegue"]) {
        SetStartTimeViewController *controller = segue.destinationViewController;
        controller.title = NSLocalizedString(@"Start Time", nil);
        controller.defaultStartTime = self.saveDataForm.startTime;
        controller.setStartTime = ^(Time *startTime){
            self.saveDataForm.startTime = startTime;
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
    
    self.currencyPairLabel.text = [self.saveDataForm.currencyPair toDisplayString];
    self.timeFrameLabel.text = [self.saveDataForm.timeFrame toDisplayString];
    self.startTimeLabel.text = [self.saveDataForm.startTime toDisplayYMDString];
    self.spreadLabel.text = [self.saveDataForm.spread toDisplayString];
    self.accountCurrencyLabel.text = [self.saveDataForm.accountCurrency toDisplayString];
    self.startBalanceLabel.text = [self.saveDataForm.startBalance toDisplayString];
    self.positionSizeOfLotLabel.text = [self.saveDataForm.positionSizeOfLot toDisplayString];
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
