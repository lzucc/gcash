//
//  AccountDAO.m
//  Gnucash
//
//  Created by CAI on 14-7-30.
//  Copyright (c) 2014年 CC. All rights reserved.
//

#import "AccountDAO.h"
#import "Account.h"
#import <sqlite3.h>

@interface AccountDAO ()

@property (strong, nonatomic) NSString *dbFilePath;

@end

@implementation AccountDAO
+ (instancetype)sharedAccDAO{
    static AccountDAO *sharedAccDAO = nil;
    static dispatch_once_t onceToken;
    dispatch_once(& onceToken, ^{
        sharedAccDAO = [[self alloc] init];
    });
    return sharedAccDAO;
}

- (NSString *)dataFilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"gnucash.db"];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.dbFilePath= [self dataFilePath];
    }
    return self;
}

-(NSArray *)getAccListBySQL:(NSString *)sqlStr{
    sqlite3 *database;
    if (sqlite3_open([[self dataFilePath] UTF8String], &database)!= SQLITE_OK) {
        sqlite3_close(database);
        NSAssert(0, @"Failed to open database");
    }
//    NSString *query = @"select t.guid,t.name,t.account_type,t.parent_guid,t.hidden,t.placeholder, t.description  from accounts t ";
//    
//    if ([sqlWhereStr length]>3) {
//        query=[query stringByAppendingString:sqlWhereStr];
//    }
    
    sqlite3_stmt *statement;
    NSMutableArray *accListIn = [[NSMutableArray alloc] init];
    if (sqlite3_prepare_v2(database, [sqlStr UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
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
            NSString *whereStr =@"";
            if(parentGuid!=NULL){
                NSString *whereStr = [@"where parent_guid='" stringByAppendingString:acc.parentGuid];
                whereStr = [whereStr stringByAppendingString:@"'"];
               
            }
             acc.subAccNum = [self getAccCountBySQL:whereStr];
            [accListIn addObject:acc];
        }
        sqlite3_finalize(statement);
    }
    sqlite3_close(database);
    return [accListIn mutableCopy];
}

-(NSInteger)getAccCountBySQL:(NSString *)sqlWhereStr{
    sqlite3 *database;
    if (sqlite3_open([[self dataFilePath] UTF8String], &database)!= SQLITE_OK) {
        sqlite3_close(database);
        NSAssert(0, @"Failed to open database");
    }
    NSString *query = @"select count(*) from accounts ";
    
    if ([sqlWhereStr length]>1) {
        query=[query stringByAppendingString:sqlWhereStr];
    }
    
    sqlite3_stmt *statement;
    NSInteger count = 0;
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            count=(NSInteger)sqlite3_column_text(statement, 0);
        }
        sqlite3_finalize(statement);
    }
    sqlite3_close(database);
    return count;
}

-(NSArray *)getRootAccList{
    NSString *sql = @"select t1.guid,t1.name,t1.account_type,t1.parent_guid,t1.hidden,t1.placeholder, t1.description from accounts t1, accounts t2 where t1.parent_guid=t2.guid and t2.name='Root Account'";
    return [self getAccListBySQL:sql];
}

-(NSArray *)getAccListByParentGuid:(NSString *)parentGuid{
    
    NSString *query = @"select t.guid,t.name,t.account_type,t.parent_guid,t.hidden,t.placeholder, t.description  from accounts t where t.parent_guid='";
    query = [[query stringByAppendingString:parentGuid] stringByAppendingString:@"'"];
    
    return [self getAccListBySQL:query];
}

@end
