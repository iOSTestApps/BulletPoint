//
//  Model.h
//  BulletPoint
//
//  Created by Chris Stott on 12-07-05.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Model : NSObject
- (int)numberOfLists;
- (NSString*)listNameForIndex:(int)index;
- (NSDictionary*)listForIndex:(int)index;
- (int)listCountForIndex:(int)index;
- (int)doneCountForIndex:(int)index;
- (NSString*)nextItemForIndex:(int)index;
- (void)addList:(NSString*)listName;
- (void)deleteList:(int)listIndex;
- (void)moveListFrom:(int)sourceIndex to:(int)destIndex;
- (NSString*)itemForList:(int)listIndex atIndex:(int)itemIndex;
- (NSString*)doneItemForList:(int)listIndex atIndex:(int)itemIndex;
- (int)checkItemForList:(int)listIndex atIndex:(NSString*)title; // TODO: use index
- (int)uncheckItemForList:(int)listIndex atIndex:(NSString*)title; // TODO: use index
- (void)addItem:(NSString*)title toList:(int)index;
- (int)renameItemOnList:(int)listIndex atIndex:(NSString*)itemID to:(NSString*)to; // TODO: use index
- (int)deleteItemOnList:(int)listIndex atIndex:(NSString*)itemID; // TODO: use index
- (void)moveItemOnList:(int)listIndex from:(int)sourceIndex to:(int)destIndex;
- (int)renameList:(NSString*)listID to:(NSString*)to;
- (void)setReminderForList:(int)listIndex type:(NSString*)type hour:(NSString*)hour minute:(NSString*)minute period:(NSString*)period;
@end
