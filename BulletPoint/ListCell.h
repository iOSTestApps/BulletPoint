//
//  ListCell.h
//  BulletPoint
//
//  Created by Chris Stott on 12-07-01.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListViewController.h"

@interface ListCell : UITableViewCell
@property (nonatomic,strong) IBOutlet UILabel* itemLabel;
@property (nonatomic,strong) ListViewController* parent;
@property (nonatomic,strong) IBOutlet UIView* gestureView;

- (void) rename;
- (void) animatedFade;
- (void) animatedUnfade;
- (void) fade;
- (void) unfade;
- (void) cancelRename;
- (void) clean;
- (IBAction)checked;
@end
