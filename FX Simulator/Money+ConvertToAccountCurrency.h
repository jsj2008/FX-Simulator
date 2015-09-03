//
//  Money+Money_ConvertToAccountCurrency.h
//  FX Simulator
//
//  Created  on 2015/04/15.
//  
//

#import "Money.h"

@interface Money (ConvertToAccountCurrency)
- (Money *)convertToAccountCurrency;
@end
