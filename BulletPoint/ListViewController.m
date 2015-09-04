//
//  ListViewController.m
//  BulletPoint
//
//  Created by Chris Stott on 12-07-01.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ListViewController.h"
#import "AppDelegate.h"
#import "ListCell.h"
#import "DoneListCell.h"
#import "AddItemCell.h"
#import "ListOptionsCell.h"
#import "ReminderViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface ListViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) IBOutlet UITableView* tableView;
@property (nonatomic, strong) UINib * tableCellLoader;
@property (nonatomic, strong) UINib * tableCellLoader2;
@property (nonatomic, strong) UINib * tableCellLoader3;
@property (nonatomic, strong) UINib * tableCellLoader4;
@property (nonatomic, assign) bool shouldOpenTextField;
@property (nonatomic, strong) UIButton* endButton;
@property (nonatomic, assign) bool isEditingMode;
@property (nonatomic, assign) bool isRenamingMode;
@property (nonatomic, strong) ListCell* renamingListCell;
@property (nonatomic, assign) NSTimeInterval lastEditModeChangeTime;

@end

@implementation ListViewController

@synthesize listTitle = _listTitle;
@synthesize tableView = _tableView;
@synthesize tableCellLoader = _tableCellLoader;
@synthesize tableCellLoader2 = _tableCellLoader2;
@synthesize tableCellLoader3 = _tableCellLoader3;
@synthesize tableCellLoader4 = _tableCellLoader4;
@synthesize listIndex = _listIndex;
@synthesize shouldOpenTextField = _shouldOpenTextField;
@synthesize parent = _parent;
@synthesize endButton = _endButton;
@synthesize isEditingMode = _isEditingMode;
@synthesize isRenamingMode = _isRenamingMode;
@synthesize lastEditModeChangeTime = _lastEditModeChangeTime;
@synthesize renamingListCell = _renamingListCell;

- (id)initWithIndex:(int)index
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
		self.tableCellLoader = [UINib nibWithNibName:@"ListCell" bundle:nil];
		self.tableCellLoader2 = [UINib nibWithNibName:@"AddItemCell" bundle:nil];
		self.tableCellLoader3 = [UINib nibWithNibName:@"DoneListCell" bundle:nil];	
		self.tableCellLoader4 = [UINib nibWithNibName:@"ListOptionsCell" bundle:nil];			
		self.listIndex = index;
		Model* model = [AppDelegate instance].model;	
		self.listTitle = [model listNameForIndex:index];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	self.navigationItem.title = self.listTitle;
	
	UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
	backButton.frame = CGRectMake(0,0,63,30),
	[backButton setBackgroundImage:[UIImage imageNamed:@"backbutton.png"] forState:UIControlStateNormal];
	
	[backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
	
	UIBarButtonItem* backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
	[self.navigationItem setLeftBarButtonItem:backButtonItem];
	self.navigationItem.hidesBackButton = YES;
	
	[self.tableView reloadData];


	/*UIButton *editButton = [UIButton buttonWithType:UIButtonTypeCustom];
	editButton.frame = CGRectMake(0,0,63,30),
	[editButton setBackgroundImage:[UIImage imageNamed:@"editbutton.png"] forState:UIControlStateNormal];
	
	[editButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
	
	UIBarButtonItem* editButtonItem = [[UIBarButtonItem alloc] initWithCustomView:editButton];
	[self.navigationItem setRightBarButtonItem:editButtonItem];*/
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)back {
	[self.parent refresh];
	[[AppDelegate instance].navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	Model* model = [AppDelegate instance].model;	
	
	if (section==0) {
		NSLog(@"self.isEditingMode=%d",self.isEditingMode);
		NSLog(@"self.isRenamingMode=%d",self.isRenamingMode);		
		if (!self.isRenamingMode) {
			NSLog(@"section 0 wants 1 row");
			return 1;			
		}
		else {
			NSLog(@"section 0 wants 0 row");
			return 0;
		}

	}
	else if (section==1) {
		int count = [model listCountForIndex:self.listIndex];
		NSLog(@"rows in section : %d",count);
		return count;
	}
	else if (section==2) {
		return [model doneCountForIndex:self.listIndex];		
	}
	
	return 0;
	
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSLog(@"cell - %d,%d",indexPath.section,indexPath.row);
	Model* model = [AppDelegate instance].model;			
	
	if (indexPath.section==0) {
		if (!self.isEditingMode) {
			AddItemCell* cell = [tableView dequeueReusableCellWithIdentifier:@"AddItemCell"];
			
			if (cell == nil) {
				cell = [[self.tableCellLoader2 instantiateWithOwner:self options:nil] objectAtIndex:0];
				cell.parent = self;
				
				if (self.shouldOpenTextField) {
					self.shouldOpenTextField = false;
					[cell.textField becomeFirstResponder];
				}
				
			}
			NSLog(@"done0");
			return cell;			
		}
		else {
			ListOptionsCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ListOptionsCell"];
			
			if (cell == nil) {
				cell = [[self.tableCellLoader4 instantiateWithOwner:self options:nil] objectAtIndex:0];
				cell.parent = self;
			}
			NSLog(@"done01");
			return cell;			
		}

	}
	else if (indexPath.section==1) {

		
		
		ListCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ListCell"];
		
		if (cell == nil) {
			cell = [[self.tableCellLoader instantiateWithOwner:self options:nil] objectAtIndex:0];
			UILongPressGestureRecognizer* gr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
			[cell.gestureView addGestureRecognizer:gr];
			
			UITapGestureRecognizer* gr2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
			gr2.numberOfTapsRequired = 2;
			[cell addGestureRecognizer:gr2];
			
			UITapGestureRecognizer* gr3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
			gr3.numberOfTapsRequired = 1;
			[cell addGestureRecognizer:gr3];	
			
			[gr3 requireGestureRecognizerToFail:gr2];

		}
		
		[cell clean];

		cell.itemLabel.text = [model itemForList:self.listIndex atIndex:indexPath.row];
		cell.parent = self;
		
		if (self.isRenamingMode && self.renamingListCell!=cell) {
			[cell fade];
		}
		else {
			[cell unfade];
		}
		

		NSLog(@"done1");		
		return cell;
		
	}
	else if (indexPath.section==2) {
		DoneListCell* cell = [tableView dequeueReusableCellWithIdentifier:@"DoneListCell"];
		
		if (cell == nil) {
			cell = [[self.tableCellLoader3 instantiateWithOwner:self options:nil] objectAtIndex:0];
		}
		
		UITapGestureRecognizer* gr3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapOnDone:)];
		gr3.numberOfTapsRequired = 1;
		[cell addGestureRecognizer:gr3];	
		
		cell.itemLabel.text = [model doneItemForList:self.listIndex atIndex:indexPath.row];
		cell.parent = self;
		if (self.isRenamingMode) {
			[cell fade];
		}
		else {
			[self unFade];
		}
		NSLog(@"done2");		
		return cell;
		
	}	
	return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section==0) {
		return 54.0f;
	}
	else {
		return 44.0f;		
	}

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)checkRow:(NSString*)title {

	[self.tableView beginUpdates];		

	UITableViewRowAnimation animationType = UITableViewRowAnimationLeft;
	
	Model* model = [AppDelegate instance].model;				
	int index = [model checkItemForList:self.listIndex atIndex:title];	
	
	int numItems = [model listCountForIndex:self.listIndex];
	if (numItems==0 || index==numItems) {
		animationType = UITableViewRowAnimationNone;
	}
	
	


	NSArray* rows = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:index inSection:1]];
	[self.tableView deleteRowsAtIndexPaths:rows withRowAnimation:animationType];
	NSArray* insertRows = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:2]];	
	[self.tableView insertRowsAtIndexPaths:insertRows withRowAnimation:animationType];
	[self.tableView endUpdates];	

}

- (void)uncheckRow:(NSString*)title {
	if (!self.isEditingMode) {
		[self.tableView beginUpdates];		
		Model* model = [AppDelegate instance].model;	
		int index = [model uncheckItemForList:self.listIndex atIndex:title];
		NSArray* rows = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:index inSection:2]];
		[self.tableView deleteRowsAtIndexPaths:rows withRowAnimation:UITableViewRowAnimationRight];
		NSArray* insertRows = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:1]];	
		[self.tableView insertRowsAtIndexPaths:insertRows withRowAnimation:UITableViewRowAnimationRight];
		[self.tableView endUpdates];			
	}
}

- (void)addItem:(NSString*)title {
	Model* model = [AppDelegate instance].model;	
	[model addItem:title toList:self.listIndex];
	
	NSArray* rows = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:1]];
	[self.tableView insertRowsAtIndexPaths:rows withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)rename:(NSString*)itemID to:(NSString*)to {
	Model* model = [AppDelegate instance].model;	
	
	if ([to isEqualToString:@""]) {
		int index = [model deleteItemOnList:self.listIndex atIndex:itemID];
		
		NSArray* rows = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:index inSection:1]];
		[self.tableView deleteRowsAtIndexPaths:rows withRowAnimation:UITableViewRowAnimationTop];
	}
	else {
		int index = [model renameItemOnList:self.listIndex atIndex:itemID to:to];
		
		NSArray* rows = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:index inSection:1]];
		[self.tableView reloadRowsAtIndexPaths:rows withRowAnimation:UITableViewRowAnimationNone];			
	}
	



}

- (void)considerOpeningKeyboard {
	Model* model = [AppDelegate instance].model;						  
					  
	if ([model listCountForIndex:self.listIndex]==0 && [model doneCountForIndex:self.listIndex]==0) {
		self.shouldOpenTextField = true;
	}
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 3;
}

- (void)endEditingAnimate {
	[self endEditing:YES];
}

- (void)longPress:(id)target {
	NSLog(@"entering long press");
	NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
	NSLog(@"now=%f",now-self.lastEditModeChangeTime);
	
	if ((now-self.lastEditModeChangeTime) < 1.0f) {
		return;
	}
	
	self.lastEditModeChangeTime = now;
	
	if (self.isEditingMode) {
		[self endEditing:YES];
	}
	else {
		NSLog(@"editing mode");		
		[self.tableView setEditing:YES animated:YES];
		self.isEditingMode = YES;		
		UIButton* endButton = [UIButton buttonWithType:UIButtonTypeCustom];
		endButton.frame = CGRectMake(0, 0, 320, 44);
		[endButton addTarget:self action:@selector(endEditingAnimate) forControlEvents:UIControlEventTouchUpInside];
		[[AppDelegate instance].navigationController.view addSubview:endButton];
		
		NSArray* rows = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]];
		[self.tableView beginUpdates];
		[self.tableView deleteRowsAtIndexPaths:rows withRowAnimation:UITableViewRowAnimationTop];
		[self.tableView insertRowsAtIndexPaths:rows withRowAnimation:UITableViewRowAnimationTop];		
		[self.tableView endUpdates];
		
		
		self.endButton = endButton;
	}
	NSLog(@"exiting long press");	
}

- (void)singleTap:(id)target {
	if (self.isEditingMode) {
		return;
	}
	
	ListCell* listCell = (ListCell*)((UIGestureRecognizer*)target).view;			
	
	if (self.isRenamingMode) {
		if (listCell != self.renamingListCell) {
			[self endRenaming];
		}
	}
	else {
		[listCell checked];
	}
}

- (void)singleTapOnDone:(id)target {
	DoneListCell* listCell = (DoneListCell*)((UIGestureRecognizer*)target).view;			
	
	if (!self.isRenamingMode && !self.isEditingMode) {
		[listCell unchecked];
	}
}


- (void)doubleTap:(id)target {
	if (self.isRenamingMode) {
		[self endRenaming];
		return;
	}
	
	if (!self.isEditingMode) {
		ListCell* listCell = (ListCell*)((UIGestureRecognizer*)target).view;		
		[self startRenaming:listCell];
	}
}

- (void)startRenaming:(ListCell*)listCell {
	self.isRenamingMode = true;	
	self.renamingListCell = listCell;

	NSArray* rows = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]];
	[self.tableView deleteRowsAtIndexPaths:rows withRowAnimation:UITableViewRowAnimationTop];
	NSIndexPath* cellIndexPath = [self.tableView indexPathForCell:listCell];
	
	for (int i=0; i < [self.tableView numberOfRowsInSection:1]; i++) {
		if (i != cellIndexPath.row) {
			ListCell* otherCell = (ListCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:1]];
			[otherCell animatedFade];
		}
	}
	for (int i=0; i < [self.tableView numberOfRowsInSection:2]; i++) {
		DoneListCell* otherCell = (DoneListCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:2]];
		[otherCell animatedFade];
	}	
	
	[listCell rename];
	
	CGRect frame = self.tableView.frame;
	frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 200);
	self.tableView.frame = frame;
	[self.tableView scrollToRowAtIndexPath:cellIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];	
}

- (void)endRenaming {
	if (!self.isRenamingMode) {
		return;
	}
	
	[self.tableView beginUpdates];
	self.isRenamingMode = false;
	CGRect frame = self.tableView.frame;
	frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 416);
	self.tableView.frame = frame;	
	[self.renamingListCell cancelRename];
	self.renamingListCell = nil;
	NSArray* rows = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]];
	NSLog(@"inserting add bar");
	[self.tableView insertRowsAtIndexPaths:rows withRowAnimation:UITableViewRowAnimationTop];
	[self unFade];
	[self.tableView endUpdates];
}

- (void)endEditing:(bool)animate {
	[self.tableView beginUpdates];
	self.isEditingMode = NO;	
	NSLog(@"end editing");
	NSArray* rows = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]];
	[self.endButton removeFromSuperview];
	[self.tableView setEditing:NO animated:YES];
	NSLog(@"inserting add bar (after editing)");
	if (!animate) {
		[self.tableView reloadRowsAtIndexPaths:rows withRowAnimation:UITableViewRowAnimationFade];		
	}
	else {
		[self.tableView deleteRowsAtIndexPaths:rows withRowAnimation:UITableViewRowAnimationTop];	
		[self.tableView insertRowsAtIndexPaths:rows withRowAnimation:UITableViewRowAnimationTop];				
	}

	[self.tableView endUpdates];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
	return indexPath.section==1;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
	NSLog(@"FINISHING MOVE");
	if (self.isEditingMode) {
		int sourceIndex = sourceIndexPath.row;
		int destIndex = destinationIndexPath.row;
		NSLog(@"%d -> %d",sourceIndex,destIndex);
		Model* model = [AppDelegate instance].model;	
		[model moveItemOnList:self.listIndex from:sourceIndex to:destIndex];		
	}
	NSLog(@"Exiting moveRowAtIndexPath");
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
	NSLog(@"TARGETING MOVE");
	if (proposedDestinationIndexPath.section==1) {
		return proposedDestinationIndexPath;
	}
	
	if (proposedDestinationIndexPath.section==0) {
		return [NSIndexPath indexPathForRow:0 inSection:1];
	}
	
	if (proposedDestinationIndexPath.section==2) {
		Model* model = [AppDelegate instance].model;		
		return [NSIndexPath indexPathForRow:[model listCountForIndex:self.listIndex]-1 inSection:1];
	}	
	return 0;
}

- (void)unFade {
	for (int i=0; i < [self.tableView numberOfRowsInSection:1]; i++) {
		ListCell* otherCell = (ListCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:1]];
		[otherCell animatedUnfade];
	}
	for (int i=0; i < [self.tableView numberOfRowsInSection:2]; i++) {
		DoneListCell* otherCell = (DoneListCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:2]];
		[otherCell animatedUnfade];
	}	
}

- (void)addReminder {
	[self endEditing:NO];
	
	ReminderViewController* rvc = [[ReminderViewController alloc] initWithListIndex:self.listIndex];
	[self.navigationController pushViewController:rvc animated:YES];
}

@end
