//
//  AccTableViewCell.h
//  Gnucash
//
//  Created by CAI on 14-7-30.
//  Copyright (c) 2014年 CC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *accNameLabel;
- (IBAction)checkDetails:(id)sender;
@end
