//
//  MainViewController.m
//  BulletPoint
//
//  Created by Chris Stott on 12-07-01.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"
#import "MainCell.h"
#import "AddListCell.h"
#import "ListViewController.h"
#import "AppDelegate.h"

@interface MainViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) IBOutlet UITableView* tableView;
@property (nonatomic, strong) UINib* tableCellLoader;
@property (nonatomic, strong) UINib* tableCellLoader2;
@property (nonatomic, strong) UIButton* endButton;
@property (nonatomic, assign) bool isEditingMode;
@property (nonatomic, assign) bool isRenamingMode;
@property (nonatomic, assign) bool shouldOpenTextField;
@property (nonatomic, assign) bool pendingAdd;
@property (nonatomic, assign) NSTimeInterval lastEditModeChangeTime;
@property (nonatomic, strong) MainCell* renamingMainCell;
@end

@implementation MainViewController
@synthesize tableView = _tableView;
@synthesize tableCellLoader = _tableCellLoader;
@synthesize tableCellLoader2 = _tableCellLoader2;
@synthesize endButton = _endButton;
@synthesize isEditingMode = _isEditingMode;
@synthesize isRenamingMode = _isRenamingMode;
@synthesize lastEditModeChangeTime = _lastEditModeChangeTime;
@synthesize renamingMainCell = _renamingMainCell;
@synthesize shouldOpenTextField = _shouldOpenTextField;
@synthesize pendingAdd = _pendingAdd;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title.png"]];
		self.navigationItem.titleView = imageView;
		self.tableCellLoader = [UINib nibWithNibName:@"MainCell" bundle:nil];
		self.tableCellLoader2 = [UINib nibWithNibName:@"AddListCell" bundle:nil];		
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	NSLog(@"model = %@",[AppDelegate instance].model);
	if ([[AppDelegate instance].model numberOfLists]==0) {
		self.shouldOpenTextField = YES;
	}
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
//	[self.tableView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section==0) {
		if (self.isEditingMode || ([[AppDelegate instance].model numberOfLists]==0 && !self.pendingAdd)) {
			return 1;
		}		
		else {
			return 0;
		}
	}
	else {
		return [[AppDelegate instance].model numberOfLists];
	}
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (indexPath.section==0) {
		AddListCell* addItemCell = [tableView dequeueReusableCellWithIdentifier:@"AddListCell"];
		if (addItemCell == nil) {
			addItemCell = [[self.tableCellLoader2 instantiateWithOwner:self options:nil] objectAtIndex:0];
			addItemCell.parent = self;
		}
		
		if (self.shouldOpenTextField) {
			self.shouldOpenTextField = false;
			[addItemCell.textField becomeFirstResponder];
		}
		
		return addItemCell;
	}
	
	if (indexPath.section==1) {
		MainCell* cell = [tableView dequeueReusableCellWithIdentifier:@"MainCell"];
		
		if (cell == nil) {
			cell = [[self.tableCellLoader instantiateWithOwner:self options:nil] objectAtIndex:0];
			UILongPressGestureRecognizer* gr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress)];
			[cell addGestureRecognizer:gr];
			
			UITapGestureRecognizer* gr2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doublePress:)];
			gr2.numberOfTapsRequired = 2;
			[cell addGestureRecognizer:gr2];	
			
			UITapGestureRecognizer* gr3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singlePress:)];
			gr3.numberOfTapsRequired = 1;
			
			[gr3 requireGestureRecognizerToFail:gr2];
			
			[cell addGestureRecognizer:gr3];
		}
		
		Model* model = [AppDelegate instance].model;
		[cell refresh];
		cell.nameLabel.text = [model listNameForIndex:indexPath.row];
		cell.countLabel.text = [NSString stringWithFormat:@"%d",[model listCountForIndex:indexPath.row]];	
		cell.parent = self;
		if ([model listCountForIndex:indexPath.row]>0) {
			cell.detailLabel.text = [NSString stringWithFormat:@"Next Item - %@",[model nextItemForIndex:indexPath.row]];		
		}
		else {
			cell.detailLabel.text = @"";
		}
		
		return cell;	
	}
	
	return nil;
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 60.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSLog(@"didSelectRow delegate");
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	if (self.isEditingMode) {
		return;
	}

	if (indexPath.section==1) {
		[self hideDeleteButtonsExcluding:nil];
		ListViewController* lvc = [[ListViewController alloc] initWithIndex:indexPath.row];
		lvc.parent = self;
		[[AppDelegate instance].navigationController pushViewController:lvc animated:YES];
		[lvc considerOpeningKeyboard];		
	}
}

- (void)addList:(NSString*)listName {
	self.pendingAdd = YES;
	[self endEditing];
	self.pendingAdd = NO;

	Model* model = [AppDelegate instance].model;
	[model addList:listName];
	
	[self.tableView beginUpdates];
	NSArray* rows = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:1]];
	[self.tableView insertRowsAtIndexPaths:rows withRowAnimation:UITableViewRowAnimationBottom];
	[self.tableView endUpdates];
	[NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(selectFirstRow) userInfo:nil repeats:NO];
}

- (void)selectFirstRow {
	[self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] animated:YES scrollPosition:UITableViewScrollPositionTop];	
	[self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];	
}

- (void)deleteList:(MainCell*)cell {
	Model* model = [AppDelegate instance].model;
	
	NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
	
	[model deleteList:indexPath.row];
	
	[self.tableView beginUpdates];
	NSArray* rows = [NSArray arrayWithObject:indexPath];
	NSLog(@"Deleting 1 row in deleteList");
	[self.tableView deleteRowsAtIndexPaths:rows withRowAnimation:UITableViewRowAnimationBottom];
	
	if ([[AppDelegate instance].model numberOfLists]==0) {
		NSIndexPath* topRow = [NSIndexPath indexPathForRow:0 inSection:0];
		[self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:topRow] withRowAnimation:UITableViewRowAnimationTop];
		self.shouldOpenTextField = YES;
	}
	
	[self.tableView endUpdates];
	
}

- (void)singlePress:(id)target {
	NSLog(@"singlePress");
	MainCell* mainCell = (MainCell*)((UIGestureRecognizer*)target).view;
	if (!mainCell.pendingDelete) {
		NSIndexPath* indexPath = [self.tableView indexPathForCell:mainCell];
		[self tableView:self.tableView didSelectRowAtIndexPath:indexPath];		
	}
}

- (void)doublePress:(id)target {
	NSLog(@"doublePress");	
	if (self.isRenamingMode) {
		[self endRenaming];
		return;
	}
	
	if (!self.isEditingMode) {
		MainCell* mainCell = (MainCell*)((UIGestureRecognizer*)target).view;		
		[self startRenaming:mainCell];
	}	
}

- (void)startRenaming:(MainCell*)mainCell {
	self.isRenamingMode = true;	
	self.renamingMainCell = mainCell;
	
	NSIndexPath* cellIndexPath = [self.tableView indexPathForCell:mainCell];
	

	
	[mainCell rename];
	
	CGRect frame = self.tableView.frame;
	frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 200);
	self.tableView.frame = frame;
	[self.tableView scrollToRowAtIndexPath:cellIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];	
	
	/*for (int i=0; i < [self.tableView numberOfRowsInSection:1]; i++) {
		if (i != cellIndexPath.row) {
			MainCell* otherCell = (MainCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:1]];
			[otherCell fade];
		}
	}*/	
}

- (void)endRenaming {
	[self.tableView beginUpdates];
	self.isRenamingMode = false;
	
	[UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5]; 
	CGRect frame = self.tableView.frame;
	NSLog(@"frame.height=%f",frame.size.height);
	frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 416);
	self.tableView.frame = frame;	

    [UIView commitAnimations];	
	
//	NSIndexPath* cellIndexPath = [self.tableView indexPathForCell:self.renamingMainCell];	
//	[self.tableView scrollToRowAtIndexPath:cellIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];		
	[self.renamingMainCell cancelRename];
	self.renamingMainCell = nil;
	//[self unfade];
	[self.tableView endUpdates];
}

- (void)rename:(NSString*)listID to:(NSString*)to {
	if ([to isEqualToString:@""]) {
		return;
	}
	
	Model* model = [AppDelegate instance].model;	
	int index = [model renameList:listID to:to];
	
	NSArray* rows = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:index inSection:1]];
	[self.tableView reloadRowsAtIndexPaths:rows withRowAnimation:UITableViewRowAnimationNone];	
	
}

- (void)unfade {
	for (int i=0; i < [self.tableView numberOfRowsInSection:1]; i++) {
		MainCell* otherCell = (MainCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:1]];
		[otherCell unFade];
	}
}

- (void)longPress {
	NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
	NSLog(@"time elapsed=%f",now-self.lastEditModeChangeTime);
	
	if ((now-self.lastEditModeChangeTime) < 1.0f) {
		return;
	}
	
	self.lastEditModeChangeTime = now;
	
	if (self.isEditingMode) {
		[self endEditing];
	}
	else {
		NSLog(@"editing mode");		
		[self hideDeleteButtonsExcluding:nil];
		[self.tableView setEditing:YES animated:YES];
		for (int i=0; i < [self.tableView numberOfRowsInSection:1]; i++) {
			MainCell* otherCell = (MainCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:1]];
			[otherCell startMoving];
		}
		self.isEditingMode = YES;		
		NSArray* rows = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]];
		[self.tableView insertRowsAtIndexPaths:rows withRowAnimation:UITableViewRowAnimationTop];
		UIButton* endButton = [UIButton buttonWithType:UIButtonTypeCustom];
		endButton.frame = CGRectMake(0, 0, 320, 44);
		[endButton addTarget:self action:@selector(endEditing) forControlEvents:UIControlEventTouchUpInside];
		[[AppDelegate instance].navigationController.view addSubview:endButton];
		self.endButton = endButton;
	}
	
}

- (void)endEditing {
	[self.tableView beginUpdates];
	self.isEditingMode = NO;	
	NSLog(@"end editing");
	NSIndexPath* addBarIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
	AddListCell* cell = (AddListCell*)[self.tableView cellForRowAtIndexPath:addBarIndexPath];
	if (cell) {
		[cell.textField resignFirstResponder];
	}
	NSArray* rows = [NSArray arrayWithObject:addBarIndexPath];
	NSLog(@"Deleting 1 row in endEditing");
	[self.tableView deleteRowsAtIndexPaths:rows withRowAnimation:UITableViewRowAnimationTop];
	[self.endButton removeFromSuperview];
	[self.tableView setEditing:NO animated:YES];
	for (int i=0; i < [self.tableView numberOfRowsInSection:1]; i++) {
		MainCell* otherCell = (MainCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:1]];
		[otherCell endMoving];
	}
	[self.tableView endUpdates];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section==1) {
		return YES;
	}
	else {
		return NO;
	}
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
	Model* model = [AppDelegate instance].model;
	
	int sourceIndex = sourceIndexPath.row;
	int destIndex = destinationIndexPath.row;
	NSLog(@"move %d->%d",sourceIndex,destIndex);
	[model moveListFrom:sourceIndex to:destIndex];	
}

//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
//	return UITableviewcell
//}


// Controls whether the background is indented while editing.  If not implemented, the default is YES.  This is unrelated to the indentation level below.  This method only applies to grouped style table views.
- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
	if (proposedDestinationIndexPath.section==0) {
		return [NSIndexPath indexPathForRow:0 inSection:1];
	}
	else {
		return proposedDestinationIndexPath;
	}
}

- (void)refresh {
	[self.tableView reloadData];
}

- (void)hideDeleteButtonsExcluding:(MainCell*)cell {
	int index = -1;
	
	if (cell) {
		NSIndexPath* cellIndexPath = [self.tableView indexPathForCell:cell];
		index = cellIndexPath.row;		
	}

	for (int i=0; i < [self.tableView numberOfRowsInSection:1]; i++) {
		if (i != index) {
			MainCell* otherCell = (MainCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:1]];
			[otherCell hideDeleteButton];
		}
	}
	
}



@end
