//
//  ADWADBannerView.h
//  ADWADBanner
//
//  Created by song duan on 12-5-10.
//  Copyright (c) 2012年 adways. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADWADProtocolEngineDelegate.h"
#import "ADWADUrlImageQueueDelegate.h"

typedef enum {
    ADWADBannerViewSize320x50 = 1,        //  (size: width = 320, height = 50)
    ADWADBannerViewSizeTypeCount = ADWADBannerViewSize320x50
} _ADWADBannerViewSizeType;
typedef NSInteger ADWADBannerViewSizeType;

@class ADWADAdList;
@class ADWADUrlImageQueue;

@protocol ADWADBannerViewDelegate

- (void)requestDidFinished:(NSInteger)sumOfAd;
- (void)requestDidFailed:(ADWADError *)error;

@end

@interface ADWADBannerView : UIControl <ADWADProtocolEngineDelegate, ADWADUrlImageQueueDelegate>
{
    ADWADBannerViewSizeType       _bannerViewSizeType;
    NSString                    *_siteId;
    NSString                    *_siteKey;
    NSString                    *_mediaId;
    NSString                    *_userIdentifier;
    BOOL                        _useSandBox;
    id<ADWADBannerViewDelegate>   _bannerViewDelegate;
    
 @private
    ADWADUrlImageQueue            *_urlImageQueue;
    NSString                    *_uiUrlString;
    NSInteger                   _currentAdIndex;
    NSMutableArray              *_requestIDArray;
    NSMutableArray              *_needShowAdInfoArray;
    NSMutableDictionary         *_reportedAdInfoDictionary;
    NSMutableDictionary         *_sendedPvDictionary;
    NSMutableArray              *_pvArray;
    NSTimer                     *_refreshUITimer;
    NSTimer                     *_sendPVTimer;
    BOOL                        _stopTimer;
    NSInteger                   _bannerListRequestErrorTime;
}
@property(nonatomic, assign) ADWADBannerViewSizeType bannerViewSizeType;
@property(nonatomic, copy) NSString *siteId;
@property(nonatomic, copy) NSString *siteKey;
@property(nonatomic, copy) NSString *mediaId;
@property(nonatomic, copy) NSString *userIdentifier;
@property(nonatomic, assign) BOOL useSandBox;
@property (nonatomic,assign) id<ADWADBannerViewDelegate> bannerViewDelegate;
/*
 function: 初始化ADWADBannerView并返回一个新的ADWADBannerView实例。
 parameter: @bannerViewSizeType，bannerView的尺寸，详情参考_ADWADBannerViewSizeType定义。
            @origin，bannerView的位置坐标。bannerView的参考点在bannerView的左上角。
            @siteId， ADWAD生成，开发者从ADWAD网站上可获得。
            @siteKey，ADWAD生成，开发者从ADWAD网站上可获得。
            @mediaId，ADWAD生成，开发者从ADWAD网站上可获得。
            @userIdentifier，标识一个用户的变量。你可以给不同的用户设置不同的值。这是一个可选参数。
            @sandBox，NO用正式环境，YES用测试环境
 retrun value: ADWADBannerView 对象。
 */
- (id)initWithBannerViewSizeType:(ADWADBannerViewSizeType)bannerViewSizeType
                      fullFilled:(BOOL)fullFilled
                          origin:(CGPoint)origin 
                          siteId:(NSString *)siteId
                         siteKey:(NSString *)siteKey
                         mediaId:(NSString *)mediaId
                  userIdentifier:(NSString *)userIdentifier
                      useSandBox:(BOOL)useSandBox
                        delegate:(id<ADWADBannerViewDelegate>)delegate;

/*
 function: 请求广告列表
 */
- (void)loadRequest;

/*
 function: 停止更新广告掉的定时器。在不需要广告条的时候（释放ADWADBannerView前）一定要调用该方法才能释放ADWADBannerView对象。
 */
- (void)stopUpdateBannerTimer;     

@end
