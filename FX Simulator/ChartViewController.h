//
//  TradeViewController.h
//  ForexGame
//
//  Created  on 2014/06/05.
//  
//

#import <UIKit/UIKit.h>
//#import "DataSourcettt.h"

//@class ForexHistoricalDataResultSet;
//@class ChartView;

@protocol ChartViewControllerDelegate <NSObject>
-(void)chartViewTouched;
@end

@interface ChartViewController : UIViewController
-(void)updatedSaveData;
@property (nonatomic, readwrite) NSArray *defaultForexHistoryDataArray;
@property (nonatomic, assign) id<ChartViewControllerDelegate> delegate;
//@property (weak, nonatomic) IBOutlet ChartView *chartView;
//@property (weak, nonatomic) IBOutlet UILabel *tlabel;
//-(void)updateChart:(NSArray*)chartDataArray;
//-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context;
//-(void)update;
//@property DataSourcettt *source;
//@property NSArray *forexHistoryDataArray;
@end
