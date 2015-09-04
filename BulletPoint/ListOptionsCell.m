//
//  ListOptionsCell.m
//  BulletPoint
//
//  Created by Chris Stott on 12-07-09.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ListOptionsCell.h"

@interface ListOptionsCell ()
- (IBAction)addReminder;
@end

@implementation ListOptionsCell

@synthesize parent = _parent;

- (IBAction)addReminder {
	[self.parent addReminder];
}
@end
