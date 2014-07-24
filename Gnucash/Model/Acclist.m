//
//  NSAcclist.m
//  Gnucash
//
//  Created by CAI on 14-7-13.
//  Copyright (c) 2014年 CC. All rights reserved.
//

#import "Acclist.h"
#import <sqlite3.h>
#import "Account.h"

@interface Acclist ()

@property (strong, nonatomic) NSMutableArray *accList;
@property (strong, nonatomic) NSMutableArray *accNameList;

@end

@implementation Acclist

- (NSString *)dataFilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"gnucash.db"];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        //        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        //        NSArray *storedAccList = [defaults objectForKey:@"accList"];
        //        if (storedAccList) {
        //            self.accList = [storedAccList mutableCopy];
        //        } else {
        //            self.accList = [NSMutableArray array];
        //        }
        self.accList = [NSMutableArray array];
        sqlite3 *database;
        if (sqlite3_open([[self dataFilePath] UTF8String], &database)!= SQLITE_OK) {
            sqlite3_close(database);
            NSAssert(0, @"Failed to open database");
        }
        NSString *query = @"select t.guid,t.name,t.account_type,t.parent_guid,t.hidden,t.placeholder, t.description  from accounts t";
        
        sqlite3_stmt *statement;
        NSMutableArray *accListIn = [[NSMutableArray alloc] init];
        NSMutableArray *accNameListIn = [[NSMutableArray alloc] init];
        
        if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                // int row = sqlite3_column_int(statement, 0);
                char *guid=(char *)sqlite3_column_text(statement, 0);
                char *name=(char *)sqlite3_column_text(statement, 1);
                char *accType=(char *)sqlite3_column_text(statement, 2);
                char *parentGuid = (char *)sqlite3_column_text(statement, 3);
                
                Account *acc = [[Account alloc] init];
                if(guid!=NULL){
                    acc.guid = [[NSString alloc] initWithUTF8String:guid];
                }
                if(name!=NULL){
                    acc.name = [[NSString alloc] initWithUTF8String:name];
                }
                if(accType!=NULL){
                    acc.accType =[[NSString alloc] initWithUTF8String:accType];
                }
                if(parentGuid!=NULL){
                    acc.parentGuid = [[NSString alloc] initWithUTF8String:parentGuid];
                }
                acc.hidden = sqlite3_column_int(statement, 4);
                acc.placeHolder = sqlite3_column_int(statement, 5);
                
                char *desc = (char *)sqlite3_column_text(statement, 6);
                if(desc!=NULL){
                    acc.description = [[NSString alloc] initWithUTF8String:desc];
                }

                [accNameListIn addObject:acc.name];
                [accListIn addObject:acc];
            }
            self.accList=[accListIn mutableCopy];
            self.accNameList=[accNameListIn mutableCopy];
            sqlite3_finalize(statement);
        }
        sqlite3_close(database);
    }
    return self;
}

+ (instancetype)sharedAccList{
    static Acclist *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(& onceToken, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

//- (NSArray *)favorites;

- (void)addAccount:(id)item{
    [_accList insertObject:item atIndex:0];
    [self saveAccList];
}
- (void)removeAccount:(id)item{
    
}
- (void)moveItemAtIndex:(NSInteger)from toIndex:(NSInteger)to{
    
}

- (void)saveAccList {
    // Save to sqlite
    //    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //    [defaults setObject:self.accList forKey:@"accList"];
    //    [defaults synchronize];
    NSLog(@"Save to sqlite");
}

-(NSArray *)getRootAccNameList{
    NSMutableArray *rootNameList = [[NSMutableArray alloc] init];
    NSString *rootGuid=NULL;
    for (Account *acc in self.accList) {
        if ([acc.name caseInsensitiveCompare:@"Root Account"]==NSOrderedSame) {
            rootGuid=acc.guid;
            break;
        }
    }
    for (Account *acc in self.accList) {
        if (acc.parentGuid!=NULL && [acc.parentGuid caseInsensitiveCompare:rootGuid]==NSOrderedSame) {
            [rootNameList addObject:acc];
        }
    }
    return [rootNameList mutableCopy];
}
-(NSArray *)getAccNameListByParentGuid:(NSString *)parentGuid
{
    NSMutableArray *accNameList = [[NSMutableArray alloc] init];
    for (Account *acc in self.accList) {
        if (acc.parentGuid!=NULL && [acc.parentGuid caseInsensitiveCompare:parentGuid]==NSOrderedSame) {
            [accNameList addObject:acc];
        }
    }
    return [accNameList mutableCopy];
}
@end
