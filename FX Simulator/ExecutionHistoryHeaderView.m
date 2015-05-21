//
//  OrderHistoryHeaderView.m
//  FX Simulator
//
//  Created  on 2014/09/19.
//  
//

#import "ExecutionHistoryHeaderView.h"

@implementation ExecutionHistoryHeaderView {
    UILabel *orderNumberLabel;
    UILabel *orderTypeLabel;
    //UILabel *orderType2Label;
    UILabel *closeOrderNumberLabel;
    UILabel *profitAndLossLabel;
    UILabel *orderRateLabel;
    UILabel *orderLotLabel;
    UILabel *orderTimeLabel;
    //UILabel *closeOrderNumber;
    NSArray *labelList;
}

-(id)init
{
    if (self = [super init]) {
        orderNumberLabel = [UILabel new];
        orderTypeLabel = [UILabel new];
        //orderType2Label = [UILabel new];
        closeOrderNumberLabel = [UILabel new];
        profitAndLossLabel = [UILabel new];
        orderRateLabel = [UILabel new];
        orderLotLabel = [UILabel new];
        orderTimeLabel = [UILabel new];
        //closeOrderNumber = [UILabel new];
        
        
        orderNumberLabel.textAlignment = NSTextAlignmentCenter;
        orderNumberLabel.text = @"No.";
        
        orderTypeLabel.textAlignment = NSTextAlignmentCenter;
        orderTypeLabel.text = @"注文";
        
        //orderType2Label.textAlignment = NSTextAlignmentCenter;
        //orderType2Label.text = @"種類";
        
        closeOrderNumberLabel.textAlignment = NSTextAlignmentCenter;
        closeOrderNumberLabel.text = @"決済";
        
        profitAndLossLabel.textAlignment = NSTextAlignmentCenter;
        profitAndLossLabel.text = @"損益";
        
        orderRateLabel.textAlignment = NSTextAlignmentCenter;
        orderRateLabel.text = @"レート";
        
        orderLotLabel.textAlignment = NSTextAlignmentCenter;
        orderLotLabel.text = @"Lot";
        
        orderTimeLabel.textAlignment = NSTextAlignmentCenter;
        orderTimeLabel.text = @"時間";
        
        //closeOrderNumber.textAlignment = NSTextAlignmentCenter;
        //closeOrderNumber.text = @"決済対象";
        
        labelList = @[orderNumberLabel, orderTypeLabel, orderRateLabel, orderLotLabel, closeOrderNumberLabel, profitAndLossLabel, orderTimeLabel];
        
        [self addSubview:orderNumberLabel];
        [self addSubview:orderTypeLabel];
        [self addSubview:closeOrderNumberLabel];
        [self addSubview:profitAndLossLabel];
        [self addSubview:orderRateLabel];
        [self addSubview:orderLotLabel];
        [self addSubview:orderTimeLabel];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    float labelMarginLeft = 5;
    float labelWidth = self.frame.size.width / 4 - labelMarginLeft;
    float miniLabelWidth = labelWidth / 2;
    float bigLabelWidth = labelWidth + miniLabelWidth / 2;
    float bigLabelHeight = self.frame.size.height;
    float smallLabelHeight = bigLabelHeight / 2;
    
    /*float labelWidth = [[UIScreen mainScreen] applicationFrame].size.width / 4;
    float bigLabelHeight = self.frame.size.height;
    float smallLabelHeight = bigLabelHeight / 2;*/
    
    /*orderNumberLabel.frame = CGRectMake(0, 0, labelWidth, smallLabelHeight);
    orderTypeLabel.frame = CGRectMake(0, smallLabelHeight, labelWidth, smallLabelHeight);
    
    orderRateLabel.frame = CGRectMake(labelWidth*1, 0, labelWidth, smallLabelHeight);
    orderLotLabel.frame = CGRectMake(labelWidth*1, smallLabelHeight, labelWidth, smallLabelHeight);
    
    closeOrderNumberLabel.frame = CGRectMake(labelWidth*2, 0, labelWidth, smallLabelHeight);
    profitAndLossLabel.frame = CGRectMake(labelWidth*2, smallLabelHeight, labelWidth, smallLabelHeight);
    
    orderTimeLabel.frame = CGRectMake(labelWidth*3, 0, labelWidth, bigLabelHeight);*/
    
    
    //orderNumberLabel.backgroundColor = [UIColor blueColor];
    orderNumberLabel.frame = CGRectMake(labelMarginLeft, 0, miniLabelWidth, smallLabelHeight);
    orderTypeLabel.frame = CGRectMake(labelMarginLeft, smallLabelHeight, miniLabelWidth, smallLabelHeight);
    orderRateLabel.frame = CGRectMake(labelMarginLeft*2 + miniLabelWidth, 0, bigLabelWidth, smallLabelHeight);
    orderLotLabel.frame = CGRectMake(labelMarginLeft*2 + miniLabelWidth, smallLabelHeight, bigLabelWidth, smallLabelHeight);
    closeOrderNumberLabel.frame = CGRectMake(labelMarginLeft*3 + miniLabelWidth + bigLabelWidth, 0, bigLabelWidth, smallLabelHeight);
    profitAndLossLabel.frame = CGRectMake(labelMarginLeft*3 + miniLabelWidth + bigLabelWidth, smallLabelHeight, bigLabelWidth, smallLabelHeight);
    orderTimeLabel.frame = CGRectMake(labelMarginLeft*4 + miniLabelWidth + bigLabelWidth*2, 0, labelWidth, bigLabelHeight);
    //tradeYMDTimeLabel.frame = CGRectMake(labelMarginLeft*4 + miniLabelWidth + bigLabelWidth*2, 0, labelWidth, labelHeight);
    //tradeHMSTimeLabel.frame = CGRectMake(labelMarginLeft*4 + miniLabelWidth + bigLabelWidth*2, labelHeight, labelWidth, labelHeight);
    
    
    [labelList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UILabel *label = obj;
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor whiteColor];
    }];
    
    //closeOrderNumber.frame = CGRectMake(labelWidth*5, 0, labelWidth, bigLabelHeight);
    
    /*orderNumberLabel.layer.borderColor = [UIColor blackColor].CGColor;
    orderNumberLabel.layer.borderWidth = 1.0;
    
    orderTypeLabel.layer.borderColor = [UIColor blackColor].CGColor;
    orderTypeLabel.layer.borderWidth = 1.0;
    
    orderType2Label.layer.borderColor = [UIColor blackColor].CGColor;
    orderType2Label.layer.borderWidth = 1.0;
    
    closeOrderNumberLabel.layer.borderColor = [UIColor blackColor].CGColor;
    closeOrderNumberLabel.layer.borderWidth = 1.0;
    
    orderRateLabel.layer.borderColor = [UIColor blackColor].CGColor;
    orderRateLabel.layer.borderWidth = 1.0;
    
    orderLotLabel.layer.borderColor = [UIColor blackColor].CGColor;
    orderLotLabel.layer.borderWidth = 1.0;
    
    orderTimeLabel.layer.borderColor = [UIColor blackColor].CGColor;
    orderTimeLabel.layer.borderWidth = 1.0;*/
    
    //[self addSubview:closeOrderNumber];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    float lineWidth = 1.0;
    
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1);
    [[UIColor blackColor] setFill];
    
    UIRectFill(CGRectMake(0, self.frame.size.height / 2, self.frame.size.width, lineWidth));
    
    CGContextStrokePath(context);
}*/


@end
