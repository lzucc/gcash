//
//  AccountDAO.h
//  Gnucash
//
//  Created by CAI on 14-7-30.
//  Copyright (c) 2014年 CC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccountDAO : NSObject
+ (instancetype)sharedAccDAO;

- (NSArray *) getRootAccList;
- (NSArray *) getAccListByParentGuid :(NSString *)parentGuid;
@end
