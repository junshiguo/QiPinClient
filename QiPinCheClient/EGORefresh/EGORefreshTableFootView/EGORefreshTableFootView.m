//
//  EGORefreshTableHeaderView.m
//  Demo
//


#define  RefreshViewHight 10.0f

#import "EGORefreshTableFootView.h"


#define TEXT_COLOR	 [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]
#define FLIP_ANIMATION_DURATION 0.18f


@interface EGORefreshTableFootView (Private)
- (void)setState:(EGOPullRefreshState1)aState;
@end

@implementation EGORefreshTableFootView

@synthesize delegate=_delegate;

//初始化方法
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame: frame];
    if (self) {
		
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, -40, self.frame.size.width, self.frame.size.height)];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont boldSystemFontOfSize:13.0f];
		label.textColor = TEXT_COLOR;
		label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		label.shadowOffset = CGSizeMake(0.0f, 1.0f);
		label.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >=6000
		label.textAlignment = NSTextAlignmentCenter;
#else
        label.textAlignment=UITextAlignmentCenter;
  
#endif
		[self addSubview:label];
		_statusLabel=label;
        
		UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        view.frame = CGRectMake(80.0f, -30, 20.0f, 20.0f);
		[self addSubview:view];
		_activityView = view;
		
		[self setState:EGOOPullRefreshNormal1];		
    }	
    return self;
	
}


#pragma mark -
#pragma mark Setters

- (void)refreshLastUpdatedDate {
    _lastUpdatedLabel.text = nil;
}


- (void)setState:(EGOPullRefreshState1)aState{
	
	switch (aState) {
		case EGOOPullRefreshPulling1:
			
			_statusLabel.text = NSLocalizedString(@"加载更多⋯", @"加载更多⋯");
			[CATransaction begin];
			[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
			//_arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
			[CATransaction commit];
			
			break;
		case EGOOPullRefreshNormal1:
			
			if (_state == EGOOPullRefreshPulling1) {
				[CATransaction begin];
				[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
				//_arrowImage.transform = CATransform3DIdentity;
				[CATransaction commit];
			}
			
			_statusLabel.text = NSLocalizedString(@"加载更多", @"加载更多⋯");
			[_activityView stopAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
			//_arrowImage.hidden = NO;
			//_arrowImage.transform = CATransform3DIdentity;
			[CATransaction commit];
			
			[self refreshLastUpdatedDate];
			
			break;
		case EGOOPullRefreshLoading1:
			
			_statusLabel.text = NSLocalizedString(@"正在加载⋯", @"正在加载⋯");
			[_activityView startAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
			//_arrowImage.hidden = YES;
			[CATransaction commit];
			
			break;
		default:
			break;
	}
	
	_state = aState;
}


#pragma mark -
#pragma mark ScrollView Methods

//手指屏幕上不断拖动调用此方法
- (void)egoRefreshScrollViewDidScroll:(UIScrollView *)scrollView {	
	
	if (_state == EGOOPullRefreshLoading1) {
		
		scrollView.contentInset = UIEdgeInsetsMake(0.0, 0.0f, RefreshViewHight, 0.0f);
		
	} else if (scrollView.isDragging) {
		
		BOOL _loading = NO;
		/*if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceIsLoading:)]) {
			_loading = [_delegate egoRefreshTableFootDataSourceIsLoading:self];
		}*/
		
		if (_state == EGOOPullRefreshPulling1 && scrollView.contentOffset.y + (scrollView.frame.size.height) < scrollView.contentSize.height + RefreshViewHight && scrollView.contentOffset.y > 0.0f && !_loading) {
			[self setState:EGOOPullRefreshNormal1];
		} else if (_state == EGOOPullRefreshNormal1 && scrollView.contentOffset.y + (scrollView.frame.size.height) > scrollView.contentSize.height + RefreshViewHight  && !_loading) {
			[self setState:EGOOPullRefreshPulling1];
		}
		
		if (scrollView.contentInset.bottom != 0) {
			scrollView.contentInset = UIEdgeInsetsZero;
		}
		
	}
	
}
//当停止偏移的时候
- (void)egoRefreshscrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    /*BOOL _loading = NO;
	if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceIsLoading:)]) {
		_loading = [_delegate egoRefreshTableFootDataSourceIsLoading:self];
        NSLog(@"%c",_loading);
        
	}*/
    //判断tableview是否到达底部
    if (scrollView.contentSize.height==scrollView.contentOffset.y+scrollView.frame.size.height) {
        NSLog(@"到达底部");
        
        if ([_delegate respondsToSelector:@selector(egoRefreshTableFootDidTriggerRefresh:)]) {
			[_delegate egoRefreshTableFootDidTriggerRefresh:self];
		}
		
		[self setState:EGOOPullRefreshLoading1];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
		scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, RefreshViewHight, 0.0f);
		[UIView commitAnimations];
        
    }
    
    

}

//当用户停止拖动，并且手指从屏幕中拿开的的时候调用此方法
- (void)egoRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView {
	
	BOOL _loading = NO;
	/*if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceIsLoading:)]) {
		_loading = [_delegate egoRefreshTableFootDataSourceIsLoading:self];
	}*/
    
	if (scrollView.contentOffset.y + (scrollView.frame.size.height) > scrollView.contentSize.height  && !_loading) {
		if ([_delegate respondsToSelector:@selector(egoRefreshTableFootDidTriggerRefresh:)]) {
			[_delegate egoRefreshTableFootDidTriggerRefresh:self];
		}
		
		[self setState:EGOOPullRefreshLoading1];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
		scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, RefreshViewHight, 0.0f);
		[UIView commitAnimations];
		
	}
	
}

//当开发者页面页面刷新完毕调用此方法，[delegate egoRefreshScrollViewDataSourceDidFinishedLoading: scrollView];
- (void)egoRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView {	
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.3];
	[scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
	[UIView commitAnimations];
	
	[self setState:EGOOPullRefreshNormal1];

}


#pragma mark -
#pragma mark Dealloc

- (void)dealloc {
	
	_delegate=nil;
	_activityView = nil;
	_statusLabel = nil;
	//_arrowImage = nil;
	_lastUpdatedLabel = nil;
    
    
}


@end
