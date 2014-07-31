//
//  SubAccListTableViewController.m
//  Gnucash
//
//  Created by CAI on 14-7-12.
//  Copyright (c) 2014年 CC. All rights reserved.
//

#import "SubAccListTableViewController.h"
#import "AccountDAO.h"
#import "Account.h"
#import "AccTableViewCell.h"

@interface SubAccListTableViewController ()
@property (strong, nonatomic) AccountDAO  *accDAO;
@end

static NSString *CellTableIdentifier = @"accCellID";

@implementation SubAccListTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.accDAO = [AccountDAO sharedAccDAO];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    NSInteger cnt = 0;
    if (_parentGuid!=NULL && self.accDAO!=NULL) {
        cnt=[[self.accDAO getAccListByParentGuid:_parentGuid] count];
    }
    return cnt;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AccTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    Account *cellAcc = (Account *)[self.accDAO getAccListByParentGuid:_parentGuid][indexPath.row];
    NSString *accNameStr = cellAcc.name;
    //    cell.textLabel.text = accNameStr;
    cell.accNameLabel.text=accNameStr;
    if (cellAcc.subAccNum<=0) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
       // cell.
    }
    return cell;
}

//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    Account *cellAcc = (Account *)[self.accDAO getAccListByParentGuid:_parentGuid][indexPath.row];
//    if (cellAcc.subAccNum<=0) {
//        return;
//    }
//}
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
     Account *acc = [self.accDAO getAccListByParentGuid:_parentGuid][indexPath.row];
     listSubAcc.parentGuid = acc.guid;
     listSubAcc.navigationItem.title = acc.name;
 }


@end
