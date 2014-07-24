//
//  Account.h
//  Gnucash
//
//  Created by CAI on 14-7-12.
//  Copyright (c) 2014年 CC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Account : NSObject
@property NSString *guid;
@property NSString *name;
@property NSString *accType;
@property NSString *parentGuid;
@property NSString *commondity_guid;
@property NSString *description;
@property NSInteger placeHolder;
@property NSInteger hidden;

@end
