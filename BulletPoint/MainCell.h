//
//  MainCell.h
//  BulletPoint
//
//  Created by Chris Stott on 12-07-01.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"

@interface MainCell : UITableViewCell
@property (nonatomic,strong) IBOutlet UILabel* nameLabel;
@property (nonatomic,strong) IBOutlet UILabel* detailLabel;
@property (nonatomic,strong) IBOutlet UILabel* countLabel;
@property (nonatomic,strong) MainViewController* parent;
@property (nonatomic,assign) bool pendingDelete;

- (void)hideDeleteButton;
- (void)startMoving;
- (void)endMoving;

- (void) rename;
- (void) fade;
- (void) unFade;
- (void) cancelRename;

- (void) refresh;
@end
