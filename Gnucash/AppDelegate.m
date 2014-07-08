//
//  AppDelegate.m
//  Gnucash
//
//  Created by cc on 14-7-7.
//  Copyright (c) 2014年 CC. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL) initializeDb {
    NSLog (@"initializeDB");
    // look to see if DB is in known location (~/Documents/$DATABASE_FILE_NAME)
    //START:code.DatabaseShoppingList.findDocumentsDirectory
    NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentFolderPath = [searchPaths objectAtIndex: 0];
    
    //查看文件目录
    NSLog(@"%@",documentFolderPath);
    NSString *dbFilePath = [documentFolderPath stringByAppendingPathComponent:@"gnucash.db"];
    //END:code.DatabaseShoppingList.findDocumentsDirectory

    //START:code.DatabaseShoppingList.copyDatabaseFileToDocuments
    if (! [[NSFileManager defaultManager] fileExistsAtPath: dbFilePath]) {
        // didn't find db, need to copy
        NSString *backupDbPath = [[NSBundle mainBundle] pathForResource:@"gnucash" ofType:@"db"];
        if (backupDbPath == nil) {
            // couldn't find backup db to copy, bail
            return NO;
        } else {
            BOOL copiedBackupDb = [[NSFileManager defaultManager] copyItemAtPath:backupDbPath toPath:dbFilePath error:nil];
            if (! copiedBackupDb) {
                // copying backup db failed, bail
                return NO;
            }
        }
    }
    return YES;
    //END:code.DatabaseShoppingList.copyDatabaseFileToDocuments
    NSLog (@"bottom of initializeDb");
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    // copy the database from the bundle if necessary
    if (! [self initializeDb]) {
        // TODO: alert the user!
        NSLog (@"couldn't init db");
        return NO;
    }
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
