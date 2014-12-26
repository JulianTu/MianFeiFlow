//
//  ADWADPopupView.h
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

@protocol ADWADPopupViewDelegate;

@interface ADWADPopupView : UIView<ADWADProtocolEngineDelegate,
ADWADUrlImageQueueDelegate>
{
    NSString                        *_siteId;
    NSString                        *_siteKey;
    NSString                        *_mediaId;
    NSString                        *_userIdentifier;
    BOOL                             _useSandBox;
    id<ADWADPopupViewDelegate>        _popupViewDelegate;
    
@private
    
    UIImageView                     *_showImageView;
    NSMutableArray                  *_requestIDArray;
    UIButton                        *_closeButton;
    NSMutableArray                  *_needShowArray;
    NSMutableArray                  *_cacheListArray;
    NSMutableArray                  *_isReadyArray;
    ADWADUrlImageQueue                *_urlImageQueue;
    NSString                        *_orientationTYpeString;
    UIView                          *_backgroundView;
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
@property(nonatomic, copy) NSString *orientationTYpeString;
@property(nonatomic, assign) BOOL useSandBox;
@property(nonatomic, assign) id<ADWADPopupViewDelegate>popupViewDelegate;


/*
 function: 创建并返回一个新的ADWADPopupView实例。
 parameter: @siteId， ADWAD生成，开发者从ADWAD网站上可获得。
            @siteKey，ADWAD生成，开发者从ADWAD网站上可获得。
            @mediaId，ADWAD生成，开发者从ADWAD网站上可获得。
            @userIdentifier，标识一个用户的变量。你可以给不同的用户设置不同的值。这是一个可选参数。
            @popupViewOrientationType 传入屏幕的方向，参数采用官方标准，示例：UIInterfaceOrientationPortrait
            @sandBox，NO用正式环境，YES用测试环境。
            @delegate， 设置代理
 retrun value: ADWADPopupView 对象
 */
+ (ADWADPopupView *)initWithSiteId:(NSString *)siteId
                          siteKey:(NSString *)siteKey
                          mediaId:(NSString *)mediaId
                   userIdentifier:(NSString *)userIdentifier
                       orentation:(UIInterfaceOrientation)popupViewOrientationType
                       useSandBox:(BOOL)useSandBox
                         delegate:(id<ADWADPopupViewDelegate>)delegate;

/*
 function: 初始化一个新的ADWADPopupView实例。
 parameter: @popupViewOrientationType 传入屏幕的方向，参数采用官方标准，示例：UIInterfaceOrientationPortrait
            @siteId，ADWAD生成，开发者从ADWAD网站上可获得。
            @popupFrame， 设置view的位置和大小。
            @siteKey，ADWAD生成，开发者从ADWAD网站上可获得。
            @mediaId，ADWAD生成，开发者从ADWAD网站上可获得。
            @userIdentifier，标识一个用户的变量。你可以给不同的用户设置不同的值。这是一个可选参数。
            @sandBox，NO用正式环境，YES用测试环境。
            @delegate，设置代理。
 retrun value: ADWADPopupView对象。
 */
- (id)initWithPopupViewOrentationType:(UIInterfaceOrientation)popupViewOrientationType
                           popupFrame:(CGRect)frame
                                siteId:(NSString *)siteId
                               siteKey:(NSString *)siteKey
                               mediaId:(NSString *)mediaId
                        userIdentifier:(NSString *)userIdentifier
                            useSandBox:(BOOL)useSandBox
                              delegate:(id<ADWADPopupViewDelegate>)delegate;

/*
 function: 判断本地是否有资源
 */
- (BOOL)isReady;

/*
 function: 请求广告队列
 */
- (void)loadRequestList;

@end


@protocol ADWADPopupViewDelegate<NSObject>

@optional

- (void)closePopupView;                        //关闭popupView的回调方法
- (void)clickImagePopupView;                   //点击图片的回调方法

@end