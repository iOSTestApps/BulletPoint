//
//  DoneListCell.m
//  BulletPoint
//
//  Created by Chris Stott on 12-07-02.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DoneListCell.h"

@interface DoneListCell ()
@property (nonatomic,strong) IBOutlet UIImageView* overlayView;

@end

@implementation DoneListCell


@synthesize itemLabel = _itemLabel;
@synthesize parent = _parent;
@synthesize overlayView = _overlayView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
	
    // Configure the view for the selected state
}

- (IBAction)unchecked {
	[self.parent uncheckRow:self.itemLabel.text];
}

- (void) animatedFade {
	[UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5]; 
	[self fade];
    [UIView commitAnimations];
}

- (void) animatedUnfade {
	[UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];  
	[self unfade];
    [UIView commitAnimations];
}

- (void) fade {
	self.itemLabel.alpha = 0.1;
	self.overlayView.alpha = 0.1;
}

- (void) unfade {
	self.itemLabel.alpha = 1.0;
	self.overlayView.alpha = 1.0;
}

- (void)prepareForReuse {
	[super prepareForReuse];
	self.itemLabel.alpha = 1.0;
	self.overlayView.alpha = 1.0;	
}

@end
