//
//  Model.h
//  BulletPoint
//
//  Created by Chris Stott on 12-07-05.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Model : NSObject
- (long)numberOfLists;
- (NSString*)listNameForIndex:(long)index;
- (NSDictionary*)listForIndex:(long)index;
- (long)listCountForIndex:(long)index;
- (long)doneCountForIndex:(long)index;
- (NSString*)nextItemForIndex:(long)index;
- (void)addList:(NSString*)listName;
- (void)deleteList:(long)listIndex;
- (void)moveListFrom:(long)sourceIndex to:(long)destIndex;
- (NSString*)itemForList:(long)listIndex atIndex:(long)itemIndex;
- (NSString*)doneItemForList:(long)listIndex atIndex:(long)itemIndex;
- (long)checkItemForList:(long)listIndex atIndex:(NSString*)title; // TODO: use index
- (long)uncheckItemForList:(long)listIndex atIndex:(NSString*)title; // TODO: use index
- (void)addItem:(NSString*)title toList:(long)index;
- (long)renameItemOnList:(long)listIndex atIndex:(NSString*)itemID to:(NSString*)to; // TODO: use index
- (long)deleteItemOnList:(long)listIndex atIndex:(NSString*)itemID; // TODO: use index
- (void)moveItemOnList:(long)listIndex from:(long)sourceIndex to:(long)destIndex;
- (int)renameList:(NSString*)listID to:(NSString*)to;
- (void)setReminderForList:(long)listIndex type:(NSString*)type hour:(NSString*)hour minute:(NSString*)minute period:(NSString*)period;
@end
