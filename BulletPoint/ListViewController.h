//
//  ListViewController.h
//  BulletPoint
//
//  Created by Chris Stott on 12-07-01.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"

@interface ListViewController : UIViewController

@property (nonatomic,strong) NSString* listTitle;
@property (nonatomic,assign) long listIndex;
@property (nonatomic,strong) MainViewController* parent;

- (void)checkRow:(NSString*)title;
- (void)uncheckRow:(NSString*)title;
- (id)initWithIndex:(long)index;
- (void)addItem:(NSString*)title;
- (void)considerOpeningKeyboard;
- (void)rename:(NSString*)itemID to:(NSString*)to;
- (void)endRenaming;
- (void)addReminder;
@end
