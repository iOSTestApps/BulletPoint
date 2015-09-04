//
//  AddItemCell.m
//  BulletPoint
//
//  Created by Chris Stott on 12-07-01.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AddItemCell.h"
#import "AppDelegate.h"

@interface AddItemCell () <UITextFieldDelegate>
@property (nonatomic,strong) UIButton* endButton;
@end

@implementation AddItemCell
@synthesize parent = _parent;
@synthesize textField = _textField;
@synthesize endButton = _endButton;

- (void)textFieldDidBeginEditing:(UITextField *)textField {
	UIButton* endButton = [UIButton buttonWithType:UIButtonTypeCustom];
	endButton.frame = CGRectMake(0, 44+54+10, 320, 150);
	[endButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
	[[AppDelegate instance].navigationController.view addSubview:endButton];
	self.endButton = endButton;
}

- (void)cancel {
	self.textField.text = @"";	
	[self.textField resignFirstResponder];
	[self.endButton removeFromSuperview];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	if ([textField.text isEqualToString:@""]) {
		[textField resignFirstResponder];			
		return YES;
	}

	[self.parent addItem:textField.text];
	textField.text = @"";	
	return YES;
}

@end
