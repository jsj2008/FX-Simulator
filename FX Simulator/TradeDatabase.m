//
//  TradeDatabase.m
//  FX Simulator
//
//  Created  on 2014/07/17.
//  
//

#import "TradeDatabase.h"
#import "FMDatabase.h"

static NSString* const dbFileName = @"tradedb.sqlite3";

@implementation TradeDatabase

+(FMDatabase*)dbConnect
{
    NSString *dbPath;
    
    BOOL ret;
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    //NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    dbPath = [documentsDirectory stringByAppendingPathComponent:dbFileName];
    ret = [fm fileExistsAtPath:dbPath];
    
    NSError *error;
    
    if(!ret){
        NSString *bundleDbPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:dbFileName];
        BOOL result = [fm copyItemAtPath:bundleDbPath toPath:dbPath error:&error];
        //[fm createFileAtPath:dbPath contents:nil attributes:nil];
        
        if (result) {
            NSLog(@"ファイルのコピーに成功：%@ → %@", bundleDbPath, dbPath);
        } else {
            NSLog(@"ファイルのコピーに失敗：%@", error.description);
        }
    }
    
    return [FMDatabase databaseWithPath:dbPath];
}

/*-(id)init
{
    if (self = [super init]) {
        BOOL ret;
        NSFileManager *fm = [NSFileManager defaultManager];
        NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        dbPath = [documentsDirectory stringByAppendingPathComponent:dbFileName];
        ret = [fm fileExistsAtPath:dbPath];
        
        if(!ret){
            [fm createFileAtPath:dbPath contents:nil attributes:nil];
        }

    }
    
    return  self;
}*/

@end
