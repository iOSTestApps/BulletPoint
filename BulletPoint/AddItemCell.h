//
//  AddItemCell.h
//  BulletPoint
//
//  Created by Chris Stott on 12-07-01.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListViewController.h"

@interface AddItemCell : UITableViewCell
@property(nonatomic,strong) ListViewController* parent;
@property(nonatomic,strong) IBOutlet UITextField* textField;
@end
