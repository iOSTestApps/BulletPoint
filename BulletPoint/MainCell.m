//
//  MainCell.m
//  BulletPoint
//
//  Created by Chris Stott on 12-07-01.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MainCell.h"
#import "AppDelegate.h"

@interface MainCell () <UITextFieldDelegate>
@property(nonatomic,strong) UISwipeGestureRecognizer* gestureRecognizer;
@property(nonatomic,strong) IBOutlet UIView* countView;
@property(nonatomic,strong) IBOutlet UIView* deleteView;
@property(nonatomic,strong) IBOutlet UIView* animationView;
@property(nonatomic,assign) UIViewAnimationTransition nextAnimation;
@property (nonatomic,strong) IBOutlet UITextField* textField;
@property (nonatomic,strong) UIButton* endButton;
@property (nonatomic,strong) UITapGestureRecognizer* tapRecogniser;
@end

@implementation MainCell

@synthesize nameLabel = _nameLabel;
@synthesize detailLabel = _detailLabel;
@synthesize countLabel = _countLabel;
@synthesize gestureRecognizer = _gestureRecognizer;
@synthesize countView = _countView;
@synthesize deleteView = _deleteView;
@synthesize animationView = _animationView;
@synthesize parent = _parent;
@synthesize nextAnimation = _nextAnimation;
@synthesize textField = _textField;
@synthesize endButton = _endButton;
@synthesize tapRecogniser = _tapRecogniser;
@synthesize pendingDelete = _pendingDelete;

- (void)awakeFromNib {
	UISwipeGestureRecognizer* gr = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipedLeft)];
	gr.direction = UISwipeGestureRecognizerDirectionLeft;
	[self addGestureRecognizer:gr];
	
	UISwipeGestureRecognizer* gr2 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipedRight)];
	gr2.direction = UISwipeGestureRecognizerDirectionRight;
	[self addGestureRecognizer:gr2];	
	[self.deleteView removeFromSuperview];	
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)swipedLeft {
	[self swiped:UIViewAnimationTransitionFlipFromRight];	
}

- (void)swipedRight {
	[self swiped:UIViewAnimationTransitionFlipFromLeft];
}

- (void)swiped:(UIViewAnimationTransition)transition {
    if ([self.countView superview])
    {
		[self.parent hideDeleteButtonsExcluding:self];
	}
	
	[UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];  
	if (transition == UIViewAnimationTransitionFlipFromLeft) {
		self.nextAnimation = UIViewAnimationTransitionFlipFromRight;
	}
	else {
		self.nextAnimation = UIViewAnimationTransitionFlipFromLeft;
	}
    [UIView setAnimationTransition:transition forView:self.animationView cache:YES];
	
    if ([self.countView superview])
    {
        [self.countView removeFromSuperview];
        [self.animationView addSubview:self.deleteView];
        //[self.animationView sendSubviewToBack:self.countView];
    }
    else
    {
        [self.deleteView removeFromSuperview];
        [self.animationView addSubview:self.countView];
        //[self.animationView sendSubviewToBack:self.deleteView];
    }
	
    [UIView commitAnimations];
}

- (void)hideDeleteButton {
    if (![self.countView superview])
    {
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.5];  
		[UIView setAnimationTransition:self.nextAnimation forView:self.animationView cache:YES];
        [self.deleteView removeFromSuperview];
        [self.animationView addSubview:self.countView];
		[UIView commitAnimations];		
    }
}

- (void)startMoving {
    if ([self.countView superview])
    {
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.5];  
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.animationView cache:YES];		
        [self.countView removeFromSuperview];
		[UIView commitAnimations];		
	}
}

- (void)endMoving {
	NSLog(@"endMoving - %@",self.nameLabel.text);
    if (![self.countView superview])
    {
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.5];  
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.animationView cache:YES];
		
        [self.animationView addSubview:self.countView];
		[UIView commitAnimations];			
    }
}

- (IBAction)delete {
	NSLog(@"Delete button pressed");
	self.pendingDelete = YES;
	[self swiped:self.nextAnimation];
	[NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(doDelete) userInfo:nil repeats:NO];
}

- (void)doDelete {
	[self.parent deleteList:self];
}

- (void)willTransitionToState:(UITableViewCellStateMask)state {
	NSLog(@"wtts %d",state);
	
	//[self swiped:nil];
	//[self updateForMove];
	[super willTransitionToState:state];
}

- (void) rename {
	self.textField.hidden = NO;
	self.nameLabel.hidden = YES;
	self.textField.text = self.nameLabel.text;
	[self.textField becomeFirstResponder];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
	UIButton* endButton = [UIButton buttonWithType:UIButtonTypeCustom];
	endButton.frame = CGRectMake(0, 0, 320, 44+20);
	[endButton addTarget:self action:@selector(endRename) forControlEvents:UIControlEventTouchUpInside];
	[[AppDelegate instance].navigationController.view addSubview:endButton];
/*	[UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5]; 
	self.detailLabel.alpha = 0.1;
	self.animationView.alpha = 0.1;
    [UIView commitAnimations];
 */
	self.endButton = endButton;
}

- (void) endRename {
	[self.parent endRenaming];
}

- (void) cancelRename {
	[UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5]; 
	self.detailLabel.alpha = 1.0;
	self.animationView.alpha = 1.0;
    [UIView commitAnimations];	
	self.textField.hidden = YES;
	self.nameLabel.hidden = NO;	
	[self.textField resignFirstResponder];
	[self.endButton removeFromSuperview];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[self.parent rename:self.nameLabel.text to:textField.text];
	self.nameLabel.text = textField.text;
	[UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5]; 
	self.detailLabel.alpha = 1.0;
	self.animationView.alpha = 1.0;
    [UIView commitAnimations];		
	[self.parent endRenaming];
	return YES;
}

- (void) fade {
	[UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5]; 
	self.tapRecogniser = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endRename)];
	self.tapRecogniser.numberOfTapsRequired = 1;
	[self addGestureRecognizer:self.tapRecogniser];
	self.nameLabel.alpha = 0.1;
	self.detailLabel.alpha = 0.1;
	self.animationView.alpha = 0.1;
    [UIView commitAnimations];
}

- (void) unFade {
	[self removeGestureRecognizer:self.tapRecogniser];	
	[UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];  
	self.nameLabel.alpha = 1.0;
	self.detailLabel.alpha = 1.0;
	self.animationView.alpha = 1.0;
    [UIView commitAnimations];
}

- (void) refresh {
	self.pendingDelete = NO;
	self.nameLabel.alpha = 1.0;
	self.detailLabel.alpha = 1.0;
	self.animationView.alpha = 1.0;
	if ([self.countView superview]==nil) {
		[self.animationView addSubview:self.countView];
	}
}

@end
