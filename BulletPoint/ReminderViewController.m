//
//  ReminderViewController.m
//  BulletPoint
//
//  Created by Chris Stott on 12-07-13.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ReminderViewController.h"
#import "AppDelegate.h"
#import "Model.h"

@interface ReminderViewController () <UITableViewDelegate,UITableViewDataSource,UIPickerViewDataSource,UIPickerViewDelegate>
@property (nonatomic,strong) IBOutlet UITableView* tableView;
@property (nonatomic,strong) IBOutlet UIPickerView* pickerView;
@property (nonatomic,strong) NSDictionary* list;
@end

@implementation ReminderViewController

@synthesize tableView = _tableView;
@synthesize pickerView = _pickerView;
@synthesize listIndex = _listIndex;
@synthesize reminder = _reminder;
@synthesize list = _list;

- (void)viewDidLoad
{
    [super viewDidLoad];

	self.navigationItem.title = @"Reminder";
	
	UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
	backButton.frame = CGRectMake(0,0,63,30),
	[backButton setBackgroundImage:[UIImage imageNamed:@"backbutton.png"] forState:UIControlStateNormal];
	
	[backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
	
	UIBarButtonItem* backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
	[self.navigationItem setLeftBarButtonItem:backButtonItem];
	
	
	UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
	doneButton.frame = CGRectMake(0,0,63,30),
	[doneButton setBackgroundImage:[UIImage imageNamed:@"donebutton.png"] forState:UIControlStateNormal];
	
	[doneButton addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
	
	UIBarButtonItem* doneButtonItem = [[UIBarButtonItem alloc] initWithCustomView:doneButton];
	[self.navigationItem setRightBarButtonItem:doneButtonItem];
	
	self.navigationItem.hidesBackButton = YES;
	
	self.reminder = [[self.list objectForKey:@"reminder_type"] isEqualToString:@"daily"];
	
	int hourIndex = [[self.list objectForKey:@"reminder_hour"] intValue]-1;
	int minuteIndex = [[self.list objectForKey:@"reminder_minute"] intValue] / 5;
	int periodIndex = [[self.list objectForKey:@"reminder_period"] isEqualToString:@"AM"] ? 0 : 1;
	
	[self.pickerView selectRow:hourIndex+12*100 inComponent:0 animated:NO];
	[self.pickerView selectRow:minuteIndex+12*100 inComponent:1 animated:NO];
	[self.pickerView selectRow:periodIndex inComponent:2 animated:NO];		
	
	
	[self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ReminderCell"];
	
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ReminderCell"];
	}
	
	cell.textLabel.font = [UIFont fontWithName:@"Gill Sans Light" size:18];
	
	NSArray* daysOfWeekLabels = [NSArray arrayWithObjects:@"Daily Reminder",@"No Reminder", nil];
	cell.textLabel.text = [daysOfWeekLabels objectAtIndex:indexPath.row];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	if (indexPath.row==0) {
		if (self.reminder) {
			cell.accessoryType = UITableViewCellAccessoryCheckmark;		
		}
		else {
			cell.accessoryType = UITableViewCellAccessoryNone;	
		}		
	}
	else {
		if (!self.reminder) {
			cell.accessoryType = UITableViewCellAccessoryCheckmark;		
		}
		else {
			cell.accessoryType = UITableViewCellAccessoryNone;	
		}				
	}


	return cell;
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 3;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	if (component == 0) {
		return 10000;
	}
	else if (component == 1) {
		return 10000;
	}
	else {
		return 2;
	}
}

- (NSString*)textForRow:(long)row component:(long)component {
	if (component == 0) {
		NSArray* hours = [NSArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12", nil];
		return [hours objectAtIndex:row % 12];
	}
	else if (component == 1) {
		NSArray* minutes = [NSArray arrayWithObjects:@"00",@"05",@"10",@"15",@"20",@"25",@"30",@"35",@"40",@"45",@"50",@"55", nil];
		return [minutes objectAtIndex:row % 12];
	}
	else {
		NSArray* suffices = [NSArray arrayWithObjects:@"AM",@"PM", nil];
		return[suffices objectAtIndex:row];
		
	}
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
//- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 28)];
	label.opaque=NO;
	label.backgroundColor=[UIColor clearColor];
	label.textColor = [UIColor blackColor];
	UIFont *font = [UIFont boldSystemFontOfSize:24];
	label.font = font;
	label.textAlignment = NSTextAlignmentCenter;
	
	label.text = [self textForRow:row component:component];
	if (component == 0) {
		label.textAlignment = NSTextAlignmentRight;
	}

	CGRect frame = label.frame;
	frame.origin.x += 10;
	label.frame = frame;
	return label;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	if (indexPath.row==0) {
		self.reminder = YES;
	}
	else {
		self.reminder = NO;
	}
	
	[tableView reloadData];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
	if (component == 0) {
		return 60.0f;
	}
	else if (component == 1) {
		return 55.0f;
	}
	else {
		return 70.0f;
	}	
}

- (void)done {
	

	long hourIndex = [self.pickerView selectedRowInComponent:0];
	long minuteIndex = [self.pickerView selectedRowInComponent:1];
	long periodIndex = [self.pickerView selectedRowInComponent:2];
	
	NSString* type = self.reminder ? @"daily" : @"none";
	NSString* hour = [self textForRow:hourIndex component:0];
	NSString* minute = [self textForRow:minuteIndex component:1];
	NSString* period = [self textForRow:periodIndex component:2];	
	
	
	NSLog(@"%@:%@ %@",hour,minute,period);
	
	Model* model = [AppDelegate instance].model;
	[model setReminderForList:self.listIndex type:type hour:hour minute:minute period:period];
	[[AppDelegate instance].navigationController popViewControllerAnimated:YES];
}

- (void)back {
	[[AppDelegate instance].navigationController popViewControllerAnimated:YES];
}

- (id)initWithListIndex:(long)listIndex {
	self = [super init];
	
	if (self) {
		self.listIndex = listIndex;

		Model* model = [AppDelegate instance].model;		
		self.list = [model listForIndex:listIndex];
		
		
	}
	
	return self;
}



@end
