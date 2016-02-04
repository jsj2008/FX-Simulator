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
#import "OpenPositionRelationChunk.h"
#import "OpenPositionTableViewCell.h"
#import "SaveData.h"
#import "SaveLoader.h"
#import "SimulationManager.h"

static const unsigned int displayMaxOpenPositionDataRecords = 100;

@interface OpenPositionTableViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation OpenPositionTableViewController {
    Currency *_displayCurrency;
    CurrencyPair *_currencyPair;
    Market *_market;
    NSArray *_openPositionDataRecords;
    PositionSize *_positionSizeOfLot;
    OpenPositionRelationChunk *_openPositions;
}

- (void)loadSaveData:(SaveData *)saveData
{
    _currencyPair = saveData.currencyPair;
    _displayCurrency = saveData.accountCurrency;
    _positionSizeOfLot = saveData.positionSizeOfLot;
    _openPositions = saveData.openPositions;
}

- (void)loadMarket:(Market *)market
{
    _market = market;
}

/*- (void)setInitData
{
    //SimulationManager *simulationManager = [SimulationManager sharedSimulationManager];
    //_market = simulationManager.market;
    SaveData *saveData = [SaveLoader load];
    _currencyPair = saveData.currencyPair;
    _displayCurrency = saveData.accountCurrency;
    _positionSizeOfLot = saveData.positionSizeOfLot;
}*/

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _openPositionDataRecords = [_openPositions selectNewestFirstLimit:displayMaxOpenPositionDataRecords currencyPair:_currencyPair];
    
    [self.tableView reloadData];
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"OpenPositionTableViewCell";
    
    OpenPositionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    OpenPosition *openPosition = [_openPositionDataRecords objectAtIndex:indexPath.row];
    
    [openPosition displayDataUsingBlock:^(NSString *currencyPair, NSString *positionType, NSString *rate, NSString *lot, NSString *orderId, NSString *profitAndLoss, NSString *ymdTime, NSString *hmsTime, UIColor *profitAndLossColor) {
        cell.displayOrderTypeValueLabel.text = positionType;
        cell.displayOrderRateValueLabel.text = rate;
        cell.displayOrderLotValueLabel.text = lot;
        cell.displayProfitAndLossValueLabel.text = profitAndLoss;
        cell.displayProfitAndLossValueLabel.textColor = profitAndLossColor;
        cell.displayOrderYMDTimeValueLabel.text = ymdTime;
        cell.displayOrderHMSTimeValueLabel.text = hmsTime;
    } market:_market sizeOfLot:_positionSizeOfLot displayCurrency:_displayCurrency];
    
    //[cell setDisplayData:record currentMarket:_market];
    
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
    // Return the number of rows in the section.
    
    return [_openPositionDataRecords count];
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
