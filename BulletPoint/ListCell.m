//
//  ListCell.m
//  BulletPoint
//
//  Created by Chris Stott on 12-07-01.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ListCell.h"
#import "AppDelegate.h"

@interface ListCell () <UITextFieldDelegate>
@property (nonatomic,strong) IBOutlet UIButton* checkButton;
@property (nonatomic,strong) IBOutlet UITextField* textField;
@property (nonatomic,strong) UIButton* endButton;
@property (nonatomic,strong) UITapGestureRecognizer* tapRecogniser;
@property (nonatomic,strong) IBOutlet UIImageView* doneOverlay;
@end

@implementation ListCell

@synthesize itemLabel = _itemLabel;
@synthesize checkButton = _checkButton;
@synthesize parent = _parent;
@synthesize textField = _textField;
@synthesize endButton = _endButton;
@synthesize tapRecogniser = _tapRecogniser;
@synthesize doneOverlay = _doneOverlay;
@synthesize gestureView = _gestureView;

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

- (void)clean {
	CGRect frame = self.doneOverlay.frame;
	frame = CGRectMake(frame.origin.x, frame.origin.y, 0, frame.size.height);
	self.doneOverlay.frame = frame;
	self.itemLabel.alpha = 1.0;		
}

- (IBAction)checked {
	[UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5]; 
	CGRect frame = self.doneOverlay.frame;
	frame = CGRectMake(frame.origin.x, frame.origin.y, 282, frame.size.height);
	self.doneOverlay.frame = frame;
	self.itemLabel.alpha = 0.3;	
    [UIView commitAnimations];
	
	[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(doCheck) userInfo:nil repeats:NO];
}

- (void)doCheck {
	[self.parent checkRow:self.itemLabel.text];
}

- (void)willTransitionToState:(UITableViewCellStateMask)state {
	
    if ([self.checkButton superview])
    {
        [self.checkButton removeFromSuperview];
    }
    else
    {
        [self addSubview:self.checkButton];
    }
	[super willTransitionToState:state];
}

- (void) rename {
	self.textField.hidden = NO;
	self.itemLabel.hidden = YES;
	self.textField.text = self.itemLabel.text;
	[self.textField becomeFirstResponder];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
	UIButton* endButton = [UIButton buttonWithType:UIButtonTypeCustom];
	endButton.frame = CGRectMake(0, 0, 320, 44+20);
	[endButton addTarget:self action:@selector(endRename) forControlEvents:UIControlEventTouchUpInside];
	[[AppDelegate instance].navigationController.view addSubview:endButton];
	self.endButton = endButton;
}

- (void) endRename {
	[self.parent endRenaming];
}

- (void) cancelRename {
	self.textField.hidden = YES;
	self.itemLabel.hidden = NO;	
	[self.textField resignFirstResponder];
	[self.endButton removeFromSuperview];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[self.parent rename:self.itemLabel.text to:textField.text];
	self.itemLabel.text = textField.text;
	[self.parent endRenaming];
	return YES;
}

- (void) animatedFade {
	[UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5]; 
	[self fade];
    [UIView commitAnimations];
}

- (void) animatedUnfade {
	[self removeGestureRecognizer:self.tapRecogniser];	
	[UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];  
	[self unfade];
    [UIView commitAnimations];
}

- (void) fade {
	self.itemLabel.alpha = 0.1;
}

- (void) unfade {
	self.itemLabel.alpha = 1.0;
}

@end
