//
//  FirstViewController.m
//  Gnucash
//
//  Created by cc on 14-7-7.
//  Copyright (c) 2014年 CC. All rights reserved.
//

#import "FirstViewController.h"
#import <sqlite3.h>

@interface FirstViewController ()
@property (weak, nonatomic) IBOutlet UILabel *accountName;

@end

@implementation FirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.accountName.text=@"Account Name";
    
    sqlite3 *database;
    if (sqlite3_open([[self dataFilePath] UTF8String], &database)!= SQLITE_OK) {
        sqlite3_close(database);
        NSAssert(0, @"Failed to open database");
    }
    
    // Useful C trivia: If two inline strings are separated by nothing
    // but whitespace (including line breaks), they are concatenated into
    // a single string:
    //    NSString *createSQL = @"CREATE TABLE IF NOT EXISTS FIELDS "
    //    "(ROW INTEGER PRIMARY KEY, FIELD_DATA TEXT);";
    //    char *errorMsg;
    //    if (sqlite3_exec (database, [createSQL UTF8String],
    //                      NULL, NULL, &errorMsg) != SQLITE_OK) {
    //        sqlite3_close(database);
    //        NSAssert(0, @"Error creating table: %s", errorMsg);
    //    }
    NSString *query = @"select name from accounts where parent_guid is null";
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        NSString *fieldValue = @"";
        while (sqlite3_step(statement) == SQLITE_ROW) {
            // int row = sqlite3_column_int(statement, 0);
            char *rowData = (char *)sqlite3_column_text(statement, 0);
            
            fieldValue = [fieldValue stringByAppendingString:[[NSString alloc] initWithUTF8String:rowData]];
            self.accountName.text = fieldValue;
        }
        sqlite3_finalize(statement);
    }
    sqlite3_close(database);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)dataFilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"gnucash.db"];
}
@end
