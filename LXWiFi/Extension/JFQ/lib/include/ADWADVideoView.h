//
//  ADWADVideoView.h
//  ADWADSDK
//
//  Created by li fengrong on 13-4-18.
//  Copyright (c) 2014年 adways. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADWADProtocolEngineDelegate.h"
#import "ADWADUrlImageQueueDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import <MediaPlayer/MediaPlayer.h>

@class  ADWADUrlImageQueue;

@protocol ADWADVideoViewDelegate;

@interface ADWADVideoView : UIView<ADWADProtocolEngineDelegate,
ADWADUrlImageQueueDelegate>
{
    NSString                        *_siteId;
    NSString                        *_siteKey;
    NSString                        *_mediaId;
    NSString                        *_userIdentifier;
    BOOL                             _useSandBox;
    BOOL                             _canClose;
    id<ADWADVideoViewDelegate>        _videoViewDelegate;
    
@private
    
    NSMutableArray                  *_requestIDArray;
    UIButton                        *_closeButton;
    NSMutableArray                  *_needShowArray;
    NSMutableArray                  *_cacheListArray;
    NSMutableArray                  *_isReadyArray;
    ADWADUrlImageQueue                *_urlImageQueue;
    MPMoviePlayerController         *_moviePlayer;
    NSInteger                        _errorNumber;
    NSString                        *_domain;
    BOOL                             _isNeedDownload;
}

@property(nonatomic, copy) NSString *siteId;
@property(nonatomic, copy) NSString *siteKey;
@property(nonatomic, copy) NSString *mediaId;
@property(nonatomic, copy) NSString *userIdentifier;
@property(nonatomic, assign) BOOL useSandBox;
@property(nonatomic, assign) BOOL canClose;
@property(nonatomic, assign) id<ADWADVideoViewDelegate>videoViewDelegate;

/*
 function: 创建并返回一个新的ADWADVideoView实例。
 parameter: @siteId， ADWAD生成，开发者从ADWAD网站上可获得。
            @siteKey，ADWAD生成，开发者从ADWAD网站上可获得。
            @mediaId，ADWAD生成，开发者从ADWAD网站上可获得。
            @userIdentifier，标识一个用户的变量。你可以给不同的用户设置不同的值。这是一个可选参数。
            @sandBox，NO用正式环境，YES用测试环境。
 retrun value: ADWADVideoView 对象
 */
+ (ADWADVideoView *)initWithSiteId:(NSString *)siteId
                          siteKey:(NSString *)siteKey
                          mediaId:(NSString *)mediaId
                   userIdentifier:(NSString *)userIdentifier
                       useSandBox:(BOOL)useSandBox;

/*
 function: 初始化一个新的ADWADVideoView实例。
 parameter: @videoFrame， 设置view的位置和大小。
            @siteId，ADWAD生成，开发者从ADWAD网站上可获得。
            @siteKey，ADWAD生成，开发者从ADWAD网站上可获得。
            @mediaId，ADWAD生成，开发者从ADWAD网站上可获得。
            @userIdentifier，标识一个用户的变量。你可以给不同的用户设置不同的值。这是一个可选参数。
            @sandBox，NO用正式环境，YES用测试环境。
            @delegate，设置代理。
 retrun value: ADWADVideoView对象。
 */
- (id)initWithVideoView:(CGRect)videoframe
                  siteId:(NSString *)siteId
                 siteKey:(NSString *)siteKey
                 mediaId:(NSString *)mediaId
          userIdentifier:(NSString *)userIdentifier
              useSandBox:(BOOL)useSandBox
                canClose:(BOOL)canClose
                delegate:(id<ADWADVideoViewDelegate>)delegate;

/*
 function: 判断本地是否有资源
 */
- (BOOL)isReady;

/*
 function: 请求广告队列
 */
- (void)loadRequestList;

@end


@protocol ADWADVideoViewDelegate<NSObject>

@optional

- (void)closeVideoView;                        //关闭videoView的回调方法

@end