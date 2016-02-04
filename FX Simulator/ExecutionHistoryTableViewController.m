//
//  OrderHistoryTableViewController.m
//  FX Simulator
//
//  Created  on 2014/09/18.
//  
//

#import "ExecutionHistoryTableViewController.h"

#import "ExecutionHistoryTableViewCell.h"
#import "ExecutionOrder.h"
#import "ExecutionOrderRelationChunk.h"
#import "Lot.h"
#import "Time.h"
#import "Money.h"
#import "PositionSize.h"
#import "PositionType.h"
#import "Rate.h"
#import "SaveData.h"

static const unsigned int displayMaxExecutionHistoryRecords = 100;

@interface ExecutionHistoryTableViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ExecutionHistoryTableViewController {
    Currency *_displayCurrency;
    NSArray *_executionHistoryRecords;
    PositionSize *_positionSizeOfLot;
    ExecutionOrderRelationChunk *_executionOrders;
}

- (void)loadSaveData:(SaveData *)saveData
{
    _displayCurrency = saveData.accountCurrency;
    _positionSizeOfLot = saveData.positionSizeOfLot;
    _executionOrders = saveData.executionOrders;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"ExecutionHistoryTableViewCell";

    ExecutionHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    ExecutionOrder *order = [_executionHistoryRecords objectAtIndex:indexPath.row];
    
    [order displayDataUsingBlock:^(NSString *currencyPair, NSString *positionType, NSString *rate, NSString *lot, NSString *orderId, NSString *closeTargetOrderId, NSString *profitAndLoss, NSString *ymdTime, NSString *hmsTime, UIColor *profitAndLossColor) {
        cell.displayOrderTypeValueLabel.text = positionType;
        cell.displayOrderRateValueLabel.text = rate;
        cell.displayOrderLotValueLabel.text = lot;
        cell.displayProfitAndLossValueLabel.text = profitAndLoss;
        cell.displayProfitAndLossValueLabel.textColor = profitAndLossColor;
        cell.displayOrderYMDTimeValueLabel.text = ymdTime;
        cell.displayOrderHMSTimeValueLabel.text = hmsTime;
    } sizeOfLot:_positionSizeOfLot displayCurrency:_displayCurrency];
    
    //[cell setDisplayData:order];
    
    return cell;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _executionHistoryRecords = [_executionOrders selectNewestFirstLimit:displayMaxExecutionHistoryRecords];
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source

/*- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    //return 0;
    
    return [_executionHistoryRecords count];
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
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
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
