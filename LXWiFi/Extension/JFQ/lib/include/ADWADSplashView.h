//
//  ADWADSplashView.h
//  ADWADSDK
//
//  Created by li fengrong on 13-4-18.
//  Copyright (c) 2014年 adways. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADWADProtocolEngineDelegate.h"
#import "ADWADUrlImageQueueDelegate.h"
#import <QuartzCore/QuartzCore.h>

@class  ADWADUrlImageQueue;

@protocol ADWADSplashViewDelegate;

@interface ADWADSplashView : UIView<ADWADProtocolEngineDelegate,
ADWADUrlImageQueueDelegate>
{
    NSString                        *_siteId;
    NSString                        *_siteKey;
    NSString                        *_mediaId;
    NSString                        *_userIdentifier;
    BOOL                             _useSandBox;
    id<ADWADSplashViewDelegate>        _splashViewDelegate;
    
@private
    
    UIImageView                     *_showImageView;
    NSMutableArray                  *_requestIDArray;
    UIButton                        *_closeButton;
    NSMutableArray                  *_needShowArray;
    NSMutableArray                  *_cacheListArray;
    NSMutableArray                  *_isReadyArray;
    ADWADUrlImageQueue                *_urlImageQueue;
    UIView                          *_contentView;
    NSInteger                        _errorNumber;
    UIButton                        *_touchButton;
    NSString                        *_domain;
    BOOL                             _isNeedDownload;
}

@property(nonatomic, copy) NSString *siteId;
@property(nonatomic, copy) NSString *siteKey;
@property(nonatomic, copy) NSString *mediaId;
@property(nonatomic, copy) NSString *userIdentifier;
@property(nonatomic, assign) BOOL useSandBox;
@property(nonatomic, assign) id<ADWADSplashViewDelegate>splashViewDelegate;


/*
 function: 创建并返回一个新的ADWADSplashView实例。
 parameter: @siteId， ADWAD生成，开发者从ADWAD网站上可获得。
            @siteKey，ADWAD生成，开发者从ADWAD网站上可获得。
            @mediaId，ADWAD生成，开发者从ADWAD网站上可获得。
            @userIdentifier，标识一个用户的变量。你可以给不同的用户设置不同的值。这是一个可选参数。
            @sandBox，NO用正式环境，YES用测试环境。
            @delegate， 设置代理
 retrun value: ADWADSplashView 对象
 */
+ (ADWADSplashView *)initWithSiteId:(NSString *)siteId
                          siteKey:(NSString *)siteKey
                          mediaId:(NSString *)mediaId
                   userIdentifier:(NSString *)userIdentifier
                       useSandBox:(BOOL)useSandBox
                         delegate:(id<ADWADSplashViewDelegate>)delegate;

/*
 function: 初始化一个新的ADWADSplashView实例。
 parameter: @splashFrame， 设置view的位置和大小。
            @siteId，ADWAD生成，开发者从ADWAD网站上可获得。
            @siteKey，ADWAD生成，开发者从ADWAD网站上可获得。
            @mediaId，ADWAD生成，开发者从ADWAD网站上可获得。
            @userIdentifier，标识一个用户的变量。你可以给不同的用户设置不同的值。这是一个可选参数。
            @sandBox，NO用正式环境，YES用测试环境。
            @delegate，设置代理。
 retrun value: ADWADSplashView对象。
 */
- (id)initWithSplashView:(CGRect)splashframe
                  siteId:(NSString *)siteId
                 siteKey:(NSString *)siteKey
                 mediaId:(NSString *)mediaId
          userIdentifier:(NSString *)userIdentifier
              useSandBox:(BOOL)useSandBox
                delegate:(id<ADWADSplashViewDelegate>)delegate;

/*
 function: 判断本地是否有资源
 */
- (BOOL)isReady;

/*
 function: 请求广告队列
 */
- (void)loadRequestList;

@end


@protocol ADWADSplashViewDelegate<NSObject>

@optional

- (void)clickImageSplashView;                   //点击图片的回调方法

@end