//
//  ShowImgView.m
//  91TaoJin
//
//  Created by keyrun on 14-6-11.
//  Copyright (c) 2014年 guomob. All rights reserved.
//

#import "ShowImgView.h"
#import "SDImageView+SDWebCache.h"

#define kPageLabW       37.0f 
#define kPageLabH       15.0f
#define kPagePadding     83.0f     //距离底部
@implementation ShowImgView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}
-(id)initWithImgListArr:(NSArray *)listArr{
    if ([super init]) {
        self.backgroundColor =[UIColor blackColor];
        self.frame =CGRectMake(0, 0, kmainScreenWidth, kmainScreenHeigh);
        maxPage =listArr.count ;
        UIScrollView *sv =[self loadScrollViewWithPage:listArr];
//        pc =[self loadPageControlWithFrame:CGRectMake(0, kmainScreenHeigh -30, 320, 30) andPageNum:listArr.count];
        pageLab = [[TaoJinLabel alloc] initWithFrame:CGRectMake(kmainScreenWidth/2 -kPageLabW/2, self.frame.size.height -kPagePadding, kPageLabW, kPageLabH) text:[NSString stringWithFormat:@"1/%d",listArr.count] font:GetFont(11.0) textColor:kBlackTextColor textAlignment:NSTextAlignmentCenter numberLines:1];
        pageLab.backgroundColor = kWitheColor ;
        pageLab.layer.masksToBounds = YES ;
        pageLab.layer.cornerRadius = pageLab.frame.size.height/ 2;
        
        if (listArr.count <2) {
            pc.hidden =YES;
        }
        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapImage)];
        [sv addGestureRecognizer:tap];
        
        [self addSubview:sv];
        [self addSubview:pageLab];
//        [self addSubview:pc];
    }
    return self;
}
-(void)showImages{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
}

-(UIPageControl *)loadPageControlWithFrame:(CGRect) frame andPageNum:(int)num{
    UIPageControl *pageControl =[[UIPageControl alloc] initWithFrame:frame];
    pageControl.numberOfPages =num;
    pageControl.currentPageIndicatorTintColor =KOrangeColor2_0;
    return pageControl;

}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int page = scrollView.contentOffset.x / kmainScreenWidth +1;
    pageLab.text = [NSString stringWithFormat:@"%d/%d",page,maxPage];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{

    if (scrollView.contentOffset.x ==0) {
        pc.currentPage =0;
    }else{
        pc.currentPage =1;
    }
}
-(UIScrollView *)loadScrollViewWithPage:(NSArray *)pages{
    UIScrollView *scrollView =[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    scrollView.pagingEnabled =YES;
    scrollView.delegate =self;
    scrollView.showsHorizontalScrollIndicator =NO;
    [scrollView setContentSize:CGSizeMake(kmainScreenWidth *pages.count, kmainScreenHeigh)];
    float screenScale =[UIScreen mainScreen].scale ;
    for (int i=0;  i< pages.count; i++) {
        UIImageView *imageView =[[UIImageView alloc]init];
        NSDictionary *imgDic =[pages objectAtIndex:i];
        NSString *whString =[imgDic objectForKey:@"w_h"];
        NSArray *arr =[whString componentsSeparatedByString:@"x"];
        float width =[[arr objectAtIndex:0] floatValue];
        float height =[[arr objectAtIndex:1] floatValue];
        
//        [UIDevice currentDevice]
        float scale1 =kmainScreenWidth*1.0 /(kmainScreenHeigh *1.0);
        float scale2 =width/height;
        
        if (width ==kmainScreenWidth*screenScale) {
           imageView.frame =CGRectMake(kmainScreenWidth *i, 0, kmainScreenWidth, kmainScreenHeigh);
         if(height > kmainScreenHeigh*screenScale){    // 图高比屏幕大
            float size =kmainScreenHeigh*screenScale /height ;
            float newWidth =size *kmainScreenWidth ;
            imageView.frame =CGRectMake((kmainScreenWidth/2 - newWidth/2) +kmainScreenWidth *i, 0, newWidth, kmainScreenHeigh);
            
        }else if (height < kmainScreenHeigh *screenScale){      // 图宽比屏幕大
            imageView.frame =CGRectMake(kmainScreenWidth *i, kmainScreenHeigh/2 -(height/(2*screenScale)), kmainScreenWidth, height/screenScale);
        }
        }
        //按道理示例图的宽不会不等于屏幕宽的
        else if (width > kmainScreenWidth*screenScale){
            if (scale1 > scale2) {
                float scale =kmainScreenHeigh *1.0 /(height /screenScale);
                 imageView.frame =CGRectMake(kmainScreenWidth/2 -(width/(2*screenScale))*scale +kmainScreenWidth *i, 0, width/screenScale *scale, kmainScreenHeigh);
            }else if (scale1 < scale2){
                float scale =kmainScreenWidth*1.0 /(width/screenScale);
                imageView.frame =CGRectMake(kmainScreenWidth *i, kmainScreenHeigh/2 -(height/(2*screenScale))*scale, kmainScreenWidth, (height/screenScale) *scale);
            }
            /*
            if (height > kmainScreenHeigh*2) {
                float size =kmainScreenHeigh*2.0 /height ;
                float newWidth =size *kmainScreenWidth ;
                imageView.frame =CGRectMake((kmainScreenWidth/2 - newWidth/4) +kmainScreenWidth *i, 0, newWidth, kmainScreenHeigh);

            }else if (height <kmainScreenHeigh){
                
                imageView.frame =CGRectMake(kmainScreenWidth *i, kmainScreenHeigh/2 -height/4, kmainScreenWidth, height/2);
            }
             */
        }else if (width <kmainScreenWidth *screenScale){
            imageView.frame =CGRectMake(kmainScreenWidth *i, 0, kmainScreenWidth, kmainScreenHeigh);
            if (scale1 >scale2) {
                float scale =  (kmainScreenHeigh *1.0) /(height/screenScale);
               imageView.frame =CGRectMake(kmainScreenWidth/2 - scale *(width/(2*screenScale)) +kmainScreenWidth *i, 0, width/screenScale *scale, kmainScreenHeigh);
            }else if (scale1 <scale2){
                float scale =kmainScreenWidth*1.0 /(width /screenScale);
                imageView.frame =CGRectMake(kmainScreenWidth *i, kmainScreenHeigh/2 -(height/(2*screenScale))*scale, kmainScreenWidth, (height/screenScale)*scale);
                
            }
            /*
            if (height >kmainScreenHeigh*2) {
                float size =kmainScreenHeigh*2.0 /height ;
                float newWidth =size *kmainScreenWidth ;
                imageView.frame =CGRectMake(kmainScreenWidth/2 -width/4 +kmainScreenWidth *i, 0, newWidth, height/2);
            }else if (height <kmainScreenHeigh *2){
                imageView.frame =CGRectMake(kmainScreenWidth *i, kmainScreenHeigh/2 -height/4, kmainScreenWidth, height/2);
            }
             */
        }
        NSString *imgUrl =[imgDic objectForKey:@"url"];
//        [imageView setImageWithURL:[NSURL URLWithString:imgUrl] refreshCache:NO placeholderImage:GetImage(@"pic_def.png")];
        [imageView setImageWithURL:[NSURL URLWithString:imgUrl] refreshCache:NO needSetViewContentMode:true needBgColor:true placeholderImage:GetImage(@"pic_big2")];
        imageView.contentMode = UIViewContentModeScaleAspectFit;

        [scrollView addSubview:imageView];
    }
    return scrollView;
}
-(void)onTapImage{      //点击图片退出
    [self removeFromSuperview];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
