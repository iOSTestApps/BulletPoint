//
//  AddListCell.m
//  BulletPoint
//
//  Created by Chris Stott on 12-07-02.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AddListCell.h"
#import "SVProgressHUD.h"


@interface AddListCell () <UITextFieldDelegate>
@end

@implementation AddListCell
@synthesize parent = _parent;
@synthesize textField = _textField;

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	if ([textField.text isEqualToString:@""]) {
		[SVProgressHUD showErrorWithStatus:@"List must have a name"];
		return NO;
	}
	[textField resignFirstResponder];	
	[self.parent addList:textField.text];
	textField.text = @"";	
	return YES;
}


@end
