//
//  AccTableViewCell.m
//  Gnucash
//
//  Created by CAI on 14-7-30.
//  Copyright (c) 2014年 CC. All rights reserved.
//

#import "AccTableViewCell.h"

@implementation AccTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)checkDetails:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Account Details" message:@"You pressed detail button" delegate:nil cancelButtonTitle:@"Yes" otherButtonTitles:nil
                          ];
    [alert show];
}
@end
