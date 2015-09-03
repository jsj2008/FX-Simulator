//
//  PortfolioViewController.m
//  FX Simulator
//
//  Created  on 2014/10/30.
//  
//

#import "OpenPositionTableViewController.h"

#import "Account.h"
#import "Currency.h"
#import "CurrencyPair.h"
#import "ForexHistoryData.h"
#import "Market.h"
#import "OpenPosition.h"
#import "OpenPositionTableViewCell.h"
#import "SaveData.h"
#import "SaveLoader.h"
#import "SimulationManager.h"

static const unsigned int displayMaxOpenPositionDataRecords = 100;

@interface OpenPositionTableViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation OpenPositionTableViewController {
    CurrencyPair *_currencyPair;
    Market *_market;
    NSArray *_openPositionDataRecords;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setInitData];
    }
    
    return self;
}

- (void)setInitData
{
    SimulationManager *simulationManager = [SimulationManager sharedSimulationManager];
    _market = simulationManager.market;
    _currencyPair = [SaveLoader load].currencyPair;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _openPositionDataRecords = [OpenPosition selectNewestFirstLimit:displayMaxOpenPositionDataRecords currencyPair:_currencyPair];
    
    [self.tableView reloadData];
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"OpenPositionTableViewCell";
    
    OpenPositionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    OpenPosition *record = [_openPositionDataRecords objectAtIndex:indexPath.row];
    
    [cell setDisplayData:record currentMarket:_market];
    
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
    
    return [_openPositionDataRecords count];
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
