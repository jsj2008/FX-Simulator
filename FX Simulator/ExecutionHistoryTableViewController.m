//
//  OrderHistoryTableViewController.m
//  FX Simulator
//
//  Created  on 2014/09/18.
//  
//

#import "ExecutionHistoryTableViewController.h"

#import "ExecutionHistory.h"
#import "OrderType.h"
#import "Rate.h"
#import "MarketTime.h"
#import "PositionSize.h"
#import "Lot.h"
#import "Money.h"
#import "ExecutionHistoryRecord.h"
//#import "ExecutionHistoryHeaderView.h"
#import "ExecutionHistoryTableViewCell.h"

static const unsigned int displayMaxExecutionHistoryRecords = 100;
//static const float headerViewHeight = 50;

@interface ExecutionHistoryTableViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ExecutionHistoryTableViewController {
    ExecutionHistory *_executionHistory;
    //ExecutionHistoryRecord *_executionHistoryRecord;
    //UITableViewStyle _style;
    //UIView *mainView;
    //ExecutionHistoryHeaderView *headerView;
    NSArray *_executionHistoryRecords;
}

//@synthesize tradeHistoryDatabase = _tradeHistoryDatabase;
//@synthesize tradeHistoryDataRecords = _tradeHistoryDataRecords;
//@synthesize headerView = _headerView;

/*-(id)init
{
    self = [super init];
    if (self) {
        _tradeHistoryDatabase = [ExecutionHistoryFactory createExecutionHistory];
        _headerView = [ExecutionHistoryHeaderView new];
        //_style = UITableViewStylePlain;
    }
    
    return self;
}*/

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setInitData];
    }
    
    return self;
}

-(void)setInitData
{
    _executionHistory = [ExecutionHistory loadExecutionHistory];
}

/*-(void)loadView
{
    [super loadView];
    
    mainView = [UIView new];
    headerView = [ExecutionHistoryHeaderView new];

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, headerViewHeight, [[UIScreen mainScreen] applicationFrame].size.width, [[UIScreen mainScreen] applicationFrame].size.height - headerViewHeight - self.tabBarController.tabBar.frame.size.height) style:_style];
    
    [mainView addSubview:headerView];
    [mainView addSubview:_tableView];
    [self.view addSubview:mainView];
    
}*/

/*- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    _tableView.allowsSelection = NO;
    
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}*/

/*-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    mainView.backgroundColor = [UIColor blackColor];
    _tableView.backgroundColor = [UIColor blackColor];
    
    mainView.frame = CGRectMake(0, [UIApplication sharedApplication].statusBarFrame.size.height, [[UIScreen mainScreen] applicationFrame].size.width, [[UIScreen mainScreen] applicationFrame].size.height);
    headerView.frame = CGRectMake(0, 0, [[UIScreen mainScreen] applicationFrame].size.width, 50);
}*/

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"ExecutionHistoryTableViewCell";
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    ExecutionHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    ExecutionHistoryRecord *record = [_executionHistoryRecords objectAtIndex:indexPath.row];
    
    [cell setDisplayData:record];
    
    // セルが作成されていないか?
    //if (!cell) { // yes
        // セルを作成
        //cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        //cell = [[ExecutionHistoryTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        //cell.reuseIdentifier = @"a";
        //cell = [[ExecutionHistoryTableViewCell alloc] ini];
        //cell.frame = CGRectMake(0, 350, cellWidth, cellHeight);
        //cell.backgroundColor = [UIColor blackColor];
        //cell.textLabel.text = @"a";
        
        /*if (indexPath.row % 2 == 0) {
            cell.backgroundColor = [UIColor blueColor];
        } else {
            cell.backgroundColor = [UIColor blueColor];
        }*/
        
        
    //}
    
    // セルにテキストを設定
    //cell.textLabel.text = [dataSource objectAtIndex:indexPath.row];
    /*ExecutionHistoryRecord *record = [self.tradeHistoryDataRecords objectAtIndex:indexPath.row];
    cell.displayUsersOrderNumber = record.usersOrderNumber.stringValue;
    cell.displayTradeType = record.orderType.toDisplayString;
    cell.displayTradeRate = record.orderRate.stringValue;
    cell.displayTradeLot = [[record.positionSize toLot] toDisplayString];
    cell.displayCloseUsersOrderNumber = record.closeUsersOrderNumber.stringValue;
    cell.displayProfitAndLoss = [[record.profitAndLoss convertToCurrency:self.accountCurrency] toDisplayString];
    cell.displayTradeYMDTime = record.orderRate.timestamp.toDisplayYMDString;
    cell.displayTradeHMSTime = record.orderRate.timestamp.toDisplayHMSString;*/
    /*if( [obj conformsToProtocol:@protocol(ClosePositionOrderProtocol)] )
    {
        id<ClosePositionOrderProtocol> closeOrder = obj;
        NSString *s = [NSString stringWithFormat:@"%d", closeOrder.ratesID];
        cell.textLabel.text = s;
        
        NSLog(@"cell %@", s);
    } else if ([obj conformsToProtocol:@protocol(NewPositionOrderProtocol)]) {
        id<NewPositionOrderProtocol> closeOrder = obj;
        NSString *s = [NSString stringWithFormat:@"%d", closeOrder.ratesID];
        cell.textLabel.text = s;
    }*/

    return cell;
}

/*-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}*/

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _executionHistoryRecords = [_executionHistory selectLatestDataLimit:[NSNumber numberWithUnsignedInt:displayMaxExecutionHistoryRecords]];
    //_executionHistoryRecords = [[_executionHistoryRecords reverseObjectEnumerator] allObjects];
    
    [self.tableView reloadData];
}

-(void)updatedSaveData
{
    [self setInitData];
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
#warning Incomplete method implementation.
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
