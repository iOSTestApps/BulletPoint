//
//  AddListCell.h
//  BulletPoint
//
//  Created by Chris Stott on 12-07-02.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"

@interface AddListCell : UITableViewCell
@property(nonatomic,strong) MainViewController* parent;
@property(nonatomic,strong) IBOutlet UITextField* textField;
@end
