//
//  Chart.h
//  ForexGame
//
//  Created  on 2014/04/03.
//  
//

//#import <Foundation/Foundation.h>
@import UIKit;
//@import Foundation;
//#import "DataSourcettt.h"
//@class ForexHistoricalDataResultSet;

@class ForexDataArray;

@interface ChartView : UIView
//-(id)initWithFrame:(CGRect)frame;
//-(void)update:(CurrencyDatabaseResultSet*)_resultsSet;
//-(void)updateChart:(NSArray*)chartDataArray;
@property (nonatomic) ForexDataArray *chartDataArray;
//-(void)update;
//-(void)updateTime:(int)time;
//-(void)drawRect:(CGRect)rect;
//@property NSArray *forexHistoryDataArray;
//@property DataSourcettt *source;
@end

/*@interface Candle : NSObject;
-(id)initWithData:(CurrencyDatabaseResultSet*)_resultSet width:(float)width height:(float)height;
-(void)set:(CGContextRef)context;
@end*/
