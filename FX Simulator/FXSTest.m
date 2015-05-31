//
//  FXSTest.m
//  FX Simulator
//
//  Created  on 2015/05/30.
//  
//

#import "FXSTest.h"

@implementation FXSTest
+(BOOL)inTest
{
    BOOL inTests = (NSClassFromString(@"XCTest") != nil);
    
    return inTests;
}
@end
