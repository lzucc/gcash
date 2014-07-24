//
//  AccListTableViewController.m
//  Gnucash
//
//  Created by cc on 14-7-8.
//  Copyright (c) 2014年 CC. All rights reserved.
//

#import "AccListTableViewController.h"
#import <sqlite3.h>
#import "Acclist.h"
#import "Account.h"
#import "SubAccListTableViewController.h"

@interface AccListTableViewController ()
@property (strong, nonatomic) NSMutableArray *accNames;
@property (strong, nonatomic) Acclist  *accList;
@end

@implementation AccListTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (NSString *)dataFilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"gnucash.db"];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.accList = [Acclist sharedAccList];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //    sqlite3 *database;
    //    if (sqlite3_open([[self dataFilePath] UTF8String], &database)!= SQLITE_OK) {
    //        sqlite3_close(database);
    //        NSAssert(0, @"Failed to open database");
    //    }
    //
    //    // Useful C trivia: If two inline strings are separated by nothing
    //    // but whitespace (including line breaks), they are concatenated into
    //    // a single string:
    //    //    NSString *createSQL = @"CREATE TABLE IF NOT EXISTS FIELDS "
    //    //    "(ROW INTEGER PRIMARY KEY, FIELD_DATA TEXT);";
    //    //    char *errorMsg;
    //    //    if (sqlite3_exec (database, [createSQL UTF8String],
    //    //                      NULL, NULL, &errorMsg) != SQLITE_OK) {
    //    //        sqlite3_close(database);
    //    //        NSAssert(0, @"Error creating table: %s", errorMsg);
    //    //    }
    //    //    NSString *query = @"select name from accounts where parent_guid is null";
    //    NSString *query = @"select t1.name from accounts t1, accounts t2"
    //    " where t1.parent_guid=t2.guid and t2.name='Root Account'";
    //
    //    sqlite3_stmt *statement;
    //
    //    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
    //        NSMutableArray *accList = [[NSMutableArray alloc] init];
    //        while (sqlite3_step(statement) == SQLITE_ROW) {
    //            // int row = sqlite3_column_int(statement, 0);
    //            char *rowData = (char *)sqlite3_column_text(statement, 0);
    //
    //            NSString *fieldValue = [[NSString alloc] initWithUTF8String:rowData];
    //            [accList addObject:fieldValue];
    //        }
    //        self.accNames=accList;
    //        sqlite3_finalize(statement);
    //    }
    //    sqlite3_close(database);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSInteger count = [self.accList.getRootAccNameList count];
    //    return [self.accList.accList count];
    return count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"accIdentifier" forIndexPath:indexPath];
    
    // Configure the cell...
    //NSString *accNameStr = ((Account *)self.accList.accList[indexPath.row]).name;
    Account *acc = ((Account *)self.accList.getRootAccNameList[indexPath.row]);
    cell.textLabel.text = acc.name;
    cell.detailTextLabel.text = acc.description;
    return cell;
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    SubAccListTableViewController *listSubAcc = segue.destinationViewController;
    Account *acc = self.accList.getRootAccNameList[indexPath.row];
    listSubAcc.parentGuid = acc.guid;
    listSubAcc.navigationItem.title = acc.name;
}


@end
