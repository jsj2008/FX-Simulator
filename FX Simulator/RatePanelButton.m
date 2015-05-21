//
//  RatePanelButton.m
//  FX Simulator
//
//  Created  on 2015/03/09.
//  
//

#import "RatePanelButton.h"

@implementation RatePanelButton

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    /*self.titleLabel.numberOfLines = 0;
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.titleLabel.minimumScaleFactor = 0.1;
    self.titleLabel.lineBreakMode = NSLineBreakByClipping;*/
    //[self sizeToFit];
    //[self.titleLabel sizeToFit];
    
    self.layer.borderWidth = 2.0;
    self.layer.borderColor = self.currentTitleColor.CGColor;
    self.layer.cornerRadius = 5.0;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
