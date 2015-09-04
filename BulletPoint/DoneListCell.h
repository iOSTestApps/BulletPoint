//
//  DoneListCell.h
//  BulletPoint
//
//  Created by Chris Stott on 12-07-02.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListViewController.h"

@interface DoneListCell : UITableViewCell
@property (nonatomic,strong) IBOutlet UILabel* itemLabel;
@property (nonatomic,strong) ListViewController* parent;

- (IBAction)unchecked;
- (void) animatedFade;
- (void) animatedUnfade;
- (void) fade;
- (void) unfade;
@end
