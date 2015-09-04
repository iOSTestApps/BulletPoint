//
//  Model.m
//  BulletPoint
//
//  Created by Chris Stott on 12-07-05.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Model.h"
#import "AppDelegate.h"

@interface Model ()
@property (strong, nonatomic) NSMutableDictionary* database;
@end

@implementation Model

@synthesize database = _database;

- (id)init {
	self = [super init];
	
	if (self) {
		NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
		NSString* path = [documentsPath stringByAppendingPathComponent:@"database.json"];
		BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:path];
		
		if (!fileExists) {
			path = [[NSBundle mainBundle] pathForResource:@"default" ofType:@"json"];		
		}
		
		NSData* content = [NSData dataWithContentsOfFile:path];
		
		self.database = [NSJSONSerialization JSONObjectWithData:content options:NSJSONReadingMutableContainers error:nil];
	}
	return self;
	
}

- (void)save {
	NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString* path = [documentsPath stringByAppendingPathComponent:@"database.json"];
	
	NSData* content = [NSJSONSerialization dataWithJSONObject:self.database options:NSJSONWritingPrettyPrinted error:nil];
	[content writeToFile:path atomically:YES];
	[self setupNotifications];
}

- (long)numberOfLists {
	NSArray* lists = [self.database objectForKey:@"lists"];
	return lists.count;
}

- (NSString*)listNameForIndex:(long)index {
	NSLog(@"listNameForIndex:%ld",index);
	NSArray* lists = [self.database objectForKey:@"lists"];
	NSDictionary* list = [lists objectAtIndex:index];
	
	return [list valueForKey:@"title"];
}

- (NSDictionary*)listForIndex:(long)index {
	NSLog(@"listForIndex:%ld",index);
	NSArray* lists = [self.database objectForKey:@"lists"];
	NSDictionary* list = [lists objectAtIndex:index];
	
	return list;
}

- (NSString*)nextItemForIndex:(long)index {
	NSLog(@"nextItemForIndex:%ld",index);
	NSArray* lists = [self.database objectForKey:@"lists"];
	NSDictionary* list = [lists objectAtIndex:index];
	NSArray* items = [list valueForKey:@"items"];
	
	return [items objectAtIndex:0];	
}

- (long)listCountForIndex:(long)index {
	NSLog(@"listCountForIndex:%ld",index);
	NSArray* lists = [self.database objectForKey:@"lists"];
	NSDictionary* list = [lists objectAtIndex:index];
	NSArray* items = [list valueForKey:@"items"];
	
	return  items.count;
}

- (long)doneCountForIndex:(long)index {
	NSLog(@"doneCountForIndex:%ld",index);	
	NSArray* lists = [self.database objectForKey:@"lists"];
	NSDictionary* list = [lists objectAtIndex:index];
	NSArray* items = [list valueForKey:@"done_items"];
	
	return  items.count;
}

- (void)addList:(NSString *)listName {
	NSMutableDictionary* newList = [[NSMutableDictionary alloc] init];
	[newList setObject:listName forKey:@"title"];
	[newList setObject:[NSMutableArray array] forKey:@"items"];
	[newList setObject:[NSMutableArray array] forKey:@"done_items"];	
	
	NSMutableArray* lists = [self.database objectForKey:@"lists"];
	[lists insertObject:newList atIndex:0];
	
	[self save];
}

- (void)deleteList:(long)listIndex {
	NSLog(@"deleteList:%ld",listIndex);
	NSMutableArray* lists = [self.database objectForKey:@"lists"];
	[self save];		
	[lists removeObjectAtIndex:listIndex];	
	[self save];	
}

- (void)moveListFrom:(long)sourceIndex to:(long)destIndex {
	NSMutableArray* lists = [self.database objectForKey:@"lists"];	
	id list = [lists objectAtIndex:sourceIndex];
	[lists removeObjectAtIndex:sourceIndex];
	[lists insertObject:list atIndex:destIndex];
	NSLog(@"%ld->%ld",sourceIndex,destIndex);
	[self save];

}

- (NSString*)itemForList:(long)listIndex atIndex:(long)itemIndex {
	NSArray* lists = [self.database objectForKey:@"lists"];
	NSDictionary* list = [lists objectAtIndex:listIndex];
	NSArray* items = [list valueForKey:@"items"];
	return [items objectAtIndex:itemIndex];
}

- (NSString*)doneItemForList:(long)listIndex atIndex:(long)itemIndex {
	NSArray* lists = [self.database objectForKey:@"lists"];
	NSDictionary* list = [lists objectAtIndex:listIndex];
	NSArray* items = [list valueForKey:@"done_items"];
	return [items objectAtIndex:itemIndex];
}

- (long)checkItemForList:(long)listIndex atIndex:(NSString*)title {
	NSArray* lists = [self.database objectForKey:@"lists"];
	NSDictionary* list = [lists objectAtIndex:listIndex];
	NSMutableArray* items = [list valueForKey:@"items"];
	NSMutableArray* doneItems = [list valueForKey:@"done_items"];	
	if (!doneItems || doneItems.count==0) {
		doneItems = [NSMutableArray array];
		[list setValue:doneItems forKey:@"done_items"];
	}
	long index = [items indexOfObject:title];
	[items removeObjectAtIndex:index];
	[doneItems insertObject:title atIndex:0];
	[self save];	
	return index;
}

- (long)uncheckItemForList:(long)listIndex atIndex:(NSString*)title {
	NSArray* lists = [self.database objectForKey:@"lists"];
	NSDictionary* list = [lists objectAtIndex:listIndex];
	NSMutableArray* items = [list valueForKey:@"items"];
	NSMutableArray* doneItems = [list valueForKey:@"done_items"];	
	long index = [doneItems indexOfObject:title];
	[doneItems removeObjectAtIndex:index];
	[items insertObject:title atIndex:0];
	[self save];	
	return index;
}

- (void)addItem:(NSString *)title toList:(long)index {
	NSArray* lists = [self.database objectForKey:@"lists"];
	NSDictionary* list = [lists objectAtIndex:index];
	NSMutableArray* items = [list valueForKey:@"items"];
	[items insertObject:title atIndex:0];
	[self save];	
}

- (long)renameItemOnList:(long)listIndex atIndex:(NSString *)itemID to:(NSString *)to {
	
	NSArray* lists = [self.database objectForKey:@"lists"];
	NSDictionary* list = [lists objectAtIndex:listIndex];
	NSMutableArray* items = [list valueForKey:@"items"];
	long index = [items indexOfObject:itemID];
	[items replaceObjectAtIndex:index withObject:to];
	[self save];	
	return index;
}

- (long)deleteItemOnList:(long)listIndex atIndex:(NSString*)itemID {
	NSArray* lists = [self.database objectForKey:@"lists"];
	NSDictionary* list = [lists objectAtIndex:listIndex];
	NSMutableArray* items = [list valueForKey:@"items"];
	long index = [items indexOfObject:itemID];
	[items removeObjectAtIndex:index];
	[self save];	
	return index;
	
}

- (void)moveItemOnList:(long)listIndex from:(long)sourceIndex to:(long)destIndex {
	NSMutableArray* lists = [self.database objectForKey:@"lists"];
	NSDictionary* list = [lists objectAtIndex:listIndex];
	NSMutableArray* items = [list valueForKey:@"items"];	
	NSLog(@"count before = %ld",(unsigned long)items.count);
	id item = [items objectAtIndex:sourceIndex];
	[items removeObjectAtIndex:sourceIndex];
	[items insertObject:item atIndex:destIndex];
	NSLog(@"count after = %ld",(unsigned long)items.count);
	NSLog(@"%ld->%ld",sourceIndex,destIndex);
	[self save];
}

- (int)renameList:(NSString*)listID to:(NSString*)to {
	NSMutableArray* lists = [self.database objectForKey:@"lists"];
	int i;
	for (i=0; i < lists.count; i++) {
		NSMutableDictionary* list = [lists objectAtIndex:i];
		if ([listID isEqualToString:[list objectForKey:@"title"]]) {
			[list setObject:to forKey:@"title"];
			[self save];
			break;
		}
	}
	return i;	
}

- (void)setupNotifications {
	[[UIApplication sharedApplication] cancelAllLocalNotifications];
	
	NSMutableArray* lists = [self.database objectForKey:@"lists"];
	
	for (int i=0; i < lists.count; i++) {
		NSDictionary* list = [lists objectAtIndex:i];

		if ([[list objectForKey:@"reminder_type"] isEqualToString:@"daily"]) {
			
			NSArray* items = [list objectForKey:@"items"];
			
			if (items.count > 0) {
				UILocalNotification* notification = [[UILocalNotification alloc] init];
				notification.alertBody = [NSString stringWithFormat:@"%@ - %@",[list objectForKey:@"title"],[items objectAtIndex:0]];
				
				NSCalendar *gregorian = [NSCalendar autoupdatingCurrentCalendar];
				
				NSDate* now = [NSDate date];			
				NSDateComponents *comps = [gregorian components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSWeekCalendarUnit|NSDayCalendarUnit) fromDate:now];
				int hour = [[list objectForKey:@"reminder_hour"] intValue];
				if ([[list objectForKey:@"reminder_period"] isEqualToString:@"PM"]) {
					hour += 12;
				}
				[comps setHour:hour];
				[comps setMinute:[[list objectForKey:@"reminder_minute"] intValue]];
				[comps setSecond:0];	
				
				NSDate* date = [gregorian dateFromComponents:comps];
				
				notification.fireDate = date;
				notification.repeatInterval = NSDayCalendarUnit;
				notification.soundName = UILocalNotificationDefaultSoundName;
				
				[[UIApplication sharedApplication] scheduleLocalNotification:notification];				
			}
		}


	}
	
	
}

- (void)setReminderForList:(long)listIndex type:(NSString*)type hour:(NSString*)hour minute:(NSString*)minute period:(NSString*)period {
	NSMutableArray* lists = [self.database objectForKey:@"lists"];
	NSMutableDictionary* list = [lists objectAtIndex:listIndex];
	
	[list setObject:type forKey:@"reminder_type"];
	[list setObject:hour forKey:@"reminder_hour"];	
	[list setObject:minute forKey:@"reminder_minute"];		
	[list setObject:period forKey:@"reminder_period"];			

	[self save];
}

@end
