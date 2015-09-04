//
//  MainViewController.h
//  BulletPoint
//
//  Created by Chris Stott on 12-07-01.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainCell;

@interface MainViewController : UIViewController
- (void)addList:(NSString*)listName;
- (void)deleteList:(MainCell*)cell;
- (void)refresh;
- (void)hideDeleteButtonsExcluding:(MainCell*)cell;
- (void)endRenaming;
- (void)rename:(NSString*)listID to:(NSString*)to;
@end
