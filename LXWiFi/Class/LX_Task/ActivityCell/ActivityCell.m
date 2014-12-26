//
//  ActivityCell.m
//  免费流量王
//
//  Created by keyrun on 14-10-29.
//  Copyright (c) 2014年 keyrun. All rights reserved.
//

#import "ActivityCell.h"
#import "ActivityPageController.h"
#import "SDImageView+SDWebCache.h"
#import "ActivityObj.h"
#define kActivityViewH     150.0f
#define kPageCtlOffY         125.0f
#define kPageCtlWidth         100.0f
#define kPageCtlHeight        20.0f

@implementation ActivityCell
{
    int maxPage ;
    int currentPage ;
    UIPageControl *pageControl;
//    NSTimer* _timer;
}
@synthesize activityView =_activityView ;
@synthesize activityScroll = _activityScroll ;
@synthesize timer =_timer ;
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle =UITableViewCellSelectionStyleNone;
       /*
        _activityView =[[LLScrollView alloc] initWithFrame:CGRectMake(0, 0, kmainScreenWidth, kActivityViewH) WithPageArray:array andPageControlFrame:CGRectMake(kmainScreenWidth - kPageCtlWidth, kPageCtlOffY,kPageCtlWidth , kPageCtlHeight) llScrollBlock:^(int currentPage) {
            NSLog(@"  clicked page  %d" ,currentPage);
            ActivityPageController *activity = [[ActivityPageController alloc] initWithNibName:nil bundle:nil];
            activity.activityUrl = nil;
            UINavigationController *nc =(UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
            [nc pushViewController:activity animated:YES];
        }];
//        [activityView.scrollView setContentSize:CGSizeMake(kmainScreenWidth, kActivityViewH)];
        _activityView.userInteractionEnabled =YES;
        [self addSubview:_activityView];
 */
        
        _activityScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kmainScreenWidth, kActivityViewH)];
        _activityScroll.pagingEnabled = YES;
        _activityScroll.bounces =YES;
        _activityScroll.delegate = self ;
        _activityScroll.showsHorizontalScrollIndicator =NO;
        _activityScroll.contentOffset =CGPointMake(0, 0);

        currentPage = 0;
        maxPage =0;
        pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(kmainScreenWidth - kPageCtlWidth, kPageCtlOffY,kPageCtlWidth , kPageCtlHeight)];
    
        pageControl.pageIndicatorTintColor = ColorRGB(255.0, 255.0, 255.0, 0.5);
        pageControl.currentPageIndicatorTintColor = kWitheColor;

        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTipScrollViewContent)];
        [self addGestureRecognizer:tap];
       
        _timer= [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(changeContentOffx) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop]addTimer:_timer forMode:NSRunLoopCommonModes];

        [self addSubview:_activityScroll];
        [self addSubview:pageControl];
    }
    return self ;
}
-(void) loadContentWithData:(NSArray *)images {

    actArray = [[NSArray alloc] initWithArray:images];
    [_activityScroll setContentSize:CGSizeMake(kmainScreenWidth *images.count, kActivityViewH)];
    maxPage =images.count ;
    pageControl.numberOfPages = images.count ;
    CGSize size =[pageControl sizeForNumberOfPages:images.count];

    pageControl.frame = CGRectMake(kmainScreenWidth -size.width -kOffX_2_0, pageControl.frame.origin.y, size.width, pageControl.frame.size.height);
    UIImage *defImage =GetImage(@"huodong_loading") ;
    for (int i=0; i< images.count; i++) {
        ActivityObj *actObj = [images objectAtIndex:i];
        UIImageView *imageView =[[UIImageView alloc] initWithFrame:CGRectMake(kmainScreenWidth *i, 0, kmainScreenWidth, kActivityViewH)];
        
        [imageView setImageWithURL:[NSURL URLWithString:actObj.actImgURL] refreshCache:NO needSetViewContentMode:false needBgColor:YES placeholderImage:defImage withImageSize:CGSizeMake(kmainScreenWidth, kActivityViewH)];
        [_activityScroll addSubview:imageView];
    }
    [_activityScroll setContentSize:CGSizeMake(kmainScreenWidth *images.count, kActivityViewH)];
}
-(void) onTipScrollViewContent {
    ActivityObj *actObj = [actArray objectAtIndex:currentPage];
    ActivityPageController *activity = [[ActivityPageController alloc] initWithNibName:nil bundle:nil];
    activity.activityUrl = actObj.actWebURL;

    UINavigationController *nc =(UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    [nc presentViewController:activity animated:YES completion:^{

    }];
}
-(void) changeContentOffx {

    currentPage ++ ;
    if (currentPage >= maxPage) {
        currentPage = 0;
    }
    pageControl.currentPage = currentPage ;

//     [_activityScroll setContentOffset:CGPointMake(kmainScreenWidth *currentPage , 0) animated:YES];

    [UIView animateWithDuration:0.3f animations:^{      //使用上面的自带动画 在切换时切换界面 会有显示问题
        [_activityScroll setContentOffset:CGPointMake(kmainScreenWidth *currentPage, 0)];
    }];
    
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    pageControl.currentPage = scrollView.contentOffset.x / (kmainScreenWidth) ;
}




@end
