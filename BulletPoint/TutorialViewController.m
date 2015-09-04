//
//  TutorialViewController.m
//  BulletPoint
//
//  Created by Chris Stott on 12-07-28.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TutorialViewController.h"
#import "AppDelegate.h"

@interface TutorialViewController () <UIScrollViewDelegate>
@property (nonatomic, strong) IBOutlet UIPageControl *pageControl;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic,strong) IBOutlet UIButton* doneButton;
@end

@implementation TutorialViewController 

@synthesize pageControl = _pageControl;
@synthesize scrollView = _scrollView;

//////////////////////////////////////////////////////////////
//
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"TutorialViewController" bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//////////////////////////////////////////////////////////////
//
- (void)viewDidLoad {
	self.doneButton.alpha = 0;
	self.navigationItem.title = @"Tutorial";
	CGRect frame = self.scrollView.frame;
	frame.origin = CGPointMake(0, 20);
	self.scrollView.frame = frame;
	[self updateViews];
}

//////////////////////////////////////////////////////////////
//
- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

//////////////////////////////////////////////////////////////
//
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	self.pageControl.currentPage = (int)round(self.scrollView.contentOffset.x / self.scrollView.frame.size.width);
	if (self.pageControl.currentPage == 6) {
		[UIView beginAnimations:@"fadeInDoneButton" context:nil];
		[UIView setAnimationDuration:0.3];
		self.doneButton.alpha=1;
		[UIView commitAnimations];
	}
}


//////////////////////////////////////////////////////////////
//
- (void)updateViews {
	for (UIView *subview in self.scrollView.subviews) {
		[subview removeFromSuperview];
	}
	
	CGSize contentSize = CGSizeMake(0, self.scrollView.frame.size.height);
	for (unsigned int i = 0; i < self.pages.count; i++) {
		NSString *imageName = [self.pages objectAtIndex:i];
		UIImage *image = [UIImage imageNamed:imageName];
		if (image) {
			UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
			[imageView sizeToFit];
			
			CGRect frame = imageView.frame;
			frame.origin.x = (self.scrollView.frame.size.width * i) + (self.scrollView.frame.size.width / 2 - imageView.frame.size.width / 2);
			//frame.origin.y = 0;
			imageView.frame = frame;
			
			contentSize.width += self.scrollView.frame.size.width;
			
			[self.scrollView addSubview:imageView];
		}
	}
	
	self.scrollView.contentSize = contentSize;
	self.pageControl.numberOfPages = self.pages.count;
}

//////////////////////////////////////////////////////////////
//
- (NSArray *)pages {
	return [NSArray arrayWithObjects:
			@"tutorial-slide1.png",
			@"tutorial-slide2.png",
			@"tutorial-slide3.png",
			@"tutorial-slide4.png",
			@"tutorial-slide5.png",
			@"tutorial-slide6.png",
			@"tutorial-slide7.png",			
			nil];
}

- (IBAction)done {
	[[AppDelegate instance] leaveTutorial];
}
@end
