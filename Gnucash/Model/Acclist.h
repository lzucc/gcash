//
//  NSAcclist.h
//  Gnucash
//
//  Created by CAI on 14-7-13.
//  Copyright (c) 2014年 CC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Acclist : NSObject

+ (instancetype)sharedAccList;
- (NSArray *) accList;
- (NSArray *) accNameList;

- (void)addAccount:(id)item;
- (void)removeAccount:(id)item;
- (void)moveItemAtIndex:(NSInteger)from toIndex:(NSInteger)to;
- (NSArray *) getRootAccNameList;
- (NSArray *) getAccNameListByParentGuid :(NSString *)parentGuid;
@end
