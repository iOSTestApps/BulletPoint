//
//  ReminderViewController.h
//  BulletPoint
//
//  Created by Chris Stott on 12-07-13.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReminderViewController : UIViewController
@property (nonatomic,assign) bool reminder;
@property (nonatomic,assign) int listIndex;

- (id)initWithListIndex:(int)listIndex;
@end
