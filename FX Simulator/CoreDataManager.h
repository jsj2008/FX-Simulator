//
//  CoreDataManager.h
//  FX Simulator
//
//  Created by yuu on 2015/07/23.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreDataManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

/**
 テスト時などに、CoreDataManagerをセットする。
 テストが終わったら、nilを入れる。
*/
+ (void)setCoreDataManager:(CoreDataManager *)coreDataManager;

+ (CoreDataManager *)sharedManager;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
