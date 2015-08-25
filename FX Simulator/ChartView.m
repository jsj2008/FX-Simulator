//
//  Chart.m
//  ForexGame
//
//  Created  on 2014/04/03.
//  
//

#import "ChartView.h"

#import "Chart.h"


@implementation ChartView {
    
}

/*-(id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        self.backgroundColor = [UIColor colorWithRed:197/255.0 green:197/255.0 blue:200/255.0 alpha:0.0];
    }
    return self;
}*/

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        
    }
    
    return self;
}

-(void)drawRect:(CGRect)rect
{
    [self.chart stroke];
}

@end
