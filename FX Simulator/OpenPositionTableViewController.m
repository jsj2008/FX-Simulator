//
//  PortfolioViewController.m
//  FX Simulator
//
//  Created  on 2014/10/30.
//  
//

#import "OpenPositionTableViewController.h"

/*#import "ForexHistoryData.h"
#import "OrderType.h"
#import "Rate.h"
#import "PositionSize.h"
#import "Lot.h"
#import "FXTimestamp.h"
#import "Currency.h"
#import "Money.h"*/
#import "Account.h"
#import "Currency.h"
#import "ForexHistoryData.h"
#import "Market.h"
#import "OpenPosition.h"
#import "OpenPositionRecord.h"
//#import "OpenPositionHeaderView.h"
#import "OpenPositionTableViewCell.h"
#import "SaveData.h"
#import "SaveLoader.h"
#import "SimulationManager.h"

static const unsigned int displayMaxOpenPositionDataRecords = 100;

@interface OpenPositionTableViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation OpenPositionTableViewController {
    //Currency *_accountCurrency;
    Rate *_currentRate;
    Market *_market;
    NSArray *_openPositionDataRecords;
    OpenPosition *_openPosition;
}

//@synthesize tradeHistoryDatabase = _tradeHistoryDatabase;
//@synthesize headerView = _headerView;

/*-(id)init
{
    self = [super init];
    if (self) {
        _market = [MarketManager sharedMarket];
        _openPosition = [OpenPositionFactory createOpenPosition];
        //_headerView = [OpenPositionHeaderView new];
        //_style = UITableViewStylePlain;
    }
    
    return self;
}*/

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        //SaveData *saveData = [SaveLoader load];
        //_accountCurrency = saveData.accountCurrency;
        [self setInitData];
    }
    
    return self;
}

-(void)setInitData
{
    SimulationManager *simulationManager = [SimulationManager sharedSimulationManager];
    _market = simulationManager.market;
    _openPosition = simulationManager.account.openPosition;
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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _openPositionDataRecords = [_openPosition selectLatestDataLimit:[NSNumber numberWithUnsignedInt:displayMaxOpenPositionDataRecords]];
    
    [self.tableView reloadData];
    
    _currentRate = _market.currentRate;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"OpenPositionTableViewCell";
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    OpenPositionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    OpenPositionRecord *record = [_openPositionDataRecords objectAtIndex:indexPath.row];
    
    [cell setDisplayData:record currentRate:_currentRate];
    
    // セルが作成されていないか?
   /*if (!cell) { // yes
        // セルを作成
        //cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell = [[OpenPositionTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        //cell.reuseIdentifier = @"a";
        //cell = [[ExecutionHistoryTableViewCell alloc] ini];
        //cell.frame = CGRectMake(0, 350, cellWidth, cellHeight);
        //cell.backgroundColor = [UIColor blackColor];
        //cell.textLabel.text = @"a";
        
        
    }*/
    
    //cell.testLabel.text = @"test";
    
    // セルにテキストを設定
    //cell.textLabel.text = [dataSource objectAtIndex:indexPath.row];
    /*OpenPositionRecord *record = [_openPositionDataRecords objectAtIndex:indexPath.row];
    cell.displayUsersOrderNumber = record.usersOrderNumber.stringValue;
    cell.displayTradeType = record.orderType.toDisplayString;
    cell.displayTradeRate = record.orderRate.stringValue;
    cell.displayTradeLot = [[record.positionSize toLot] toDisplayString];
    //cell.displayCloseUsersOrderNumber = record.closeUsersOrderNumber.stringValue;
    cell.displayProfitAndLoss = [[record profitAndLossForRate:_currentRate] toDisplayString];
    cell.displayTradeYMDTime = record.orderRate.timestamp.toDisplayYMDString;
    cell.displayTradeHMSTime = record.orderRate.timestamp.toDisplayHMSString;*/
    
    return cell;
}

/*-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}*/

/*- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    //return 0;
    
    return [_openPositionDataRecords count];
    //return 10;
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
