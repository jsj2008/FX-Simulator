//
//  LinkButton.m
//  FXSimulator
//
//  Created by yuu on 2016/01/27.
//
//

#import "LinkButton.h"

@implementation LinkButton

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self addTarget:self action:@selector(touched) forControlEvents:UIControlEventTouchUpInside];
}

- (void)touched
{
    NSURL *url = [NSURL URLWithString:self.url];
    [[UIApplication sharedApplication] openURL:url];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
