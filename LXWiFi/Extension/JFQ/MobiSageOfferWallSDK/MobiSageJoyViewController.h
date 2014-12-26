//
//  MobiSageJoy.h
//  MobiSageJoy
//
//  Created by fwang on 13-12-6.
//  Copyright (c) 2013年 adsage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

// 消费结果状态码
typedef enum {
    
    MobiSageJoyConsumeStatusCodeSuccess = 1,    // 消费成功
    MobiSageJoyConsumeStatusCodeInsufficient,   // 剩余积分不足
    MobiSageJoyConsumeStatusCodeDuplicateOrder  // 订单重复/未知的错误
    
} MobiSageJoyConsumeStatusCode;

@class MobiSageJoyViewController;

@protocol MobiSageJoyDelegate <NSObject>

@optional
/*-------------------------------------------列表积分墙-----------------------------------------------*/
// 积分墙开始加载列表数据
- (void)JoyDidStartLoad:(MobiSageJoyViewController *)owInterstitial;

// 积分墙加载完成。
- (void)JoyDidFinishLoad:(MobiSageJoyViewController *)owInterstitial;

// 积分墙加载失败。可能的原因由error部分提供，例如网络连接失败、被禁用等。
- (void)JoyDidFailLoadWithError:(MobiSageJoyViewController *)owInterstitial
                      withError:(NSError *)error;

// 积分墙页面被关闭。
- (void)JoyDidClosed:(MobiSageJoyViewController *)owInterstitial;

@optional
/*-------------------------------------------插屏积分墙-----------------------------------------------*/
// 当积分墙插屏广告被成功加载后，回调该方法
- (void)JoyInterstitialSuccessToLoadAd:(MobiSageJoyViewController *)owInterstitial;

// 当积分墙插屏广告加载失败后，回调该方法
- (void)JoyInterstitialFailToLoadAd:(MobiSageJoyViewController *)owInterstitial
                          withError:(NSError *)err;

// 当积分墙插屏广告要被呈现出来前，回调该方法
- (void)JoyInterstitialWillPresentScreen:(MobiSageJoyViewController *)owInterstitial;

// 当积分墙插屏广告被关闭后，回调该方法
- (void)JoyInterstitialDidDismissScreen:(MobiSageJoyViewController *)owInterstitial;

@optional
/*-------------------------------------------积分查询-----------------------------------------------*/
// 积分查询成功之后，回调该接口，获取剩余积分和总已消费积分。
- (void)JoyDidFinishCheckPointWithBalancePoint:(MobiSageJoyViewController *)owInterstitial
                                       balance:(NSInteger)balance
                         andTotalConsumedPoint:(NSInteger)consumed;

// 积分查询失败之后，回调该接口，返回查询失败的错误原因。
- (void)JoyDidFailCheckPointWithError:(MobiSageJoyViewController *)owInterstitial
                            withError:(NSError *)error;

// 消费请求正常应答后，回调该接口，并返回消费状态（成功或余额不足），以及剩余积分和总已消费积分。
- (void)JoyDidFinishConsumePointWithStatusCode:(MobiSageJoyViewController *)owInterstitial
                                          code:(MobiSageJoyConsumeStatusCode)statusCode
                                  balancePoint:(NSInteger)balance
                            totalConsumedPoint:(NSInteger)consumed;

// 消费请求异常应答后，回调该接口，并返回异常的错误原因。
- (void)JoyDidFailConsumePointWithError:(MobiSageJoyViewController *)owInterstitial
                              withError:(NSError *)error;

@end

@interface MobiSageJoyViewController : UIViewController {}

/**
 *  积分墙代理
 *  @param delegate
 */
@property (nonatomic, assign) NSObject<MobiSageJoyDelegate> *delegate;

/**
 *  积分墙RootViewController
 *  @param rootViewController
 */
@property (nonatomic, assign) UIViewController *rootViewController;

/**
 *  禁用StoreKit库提供的应用内打开store页面的功能，采用跳出应用打开OS内置AppStore
 *  @param disableStoreKit 默认为NO，即使用StoreKit
 */
@property (nonatomic, assign) BOOL disableStoreKit;

/**
 *  webWallStatus值为TRUE时，通过safari展示列表积分墙
 *  webWallStatus值为FALSE时，通过启动页展示列表积分墙
 *  @param webWallStatus 默认为FALSE(前提列表积分墙开启)
 */
@property (nonatomic, assign) BOOL webWallStatus;

/**
 *  自定义开关
 *  @param akey
 *  @param enable
 */
- (BOOL)getSwitch:(NSString*) akey
          default:(BOOL) enable;

/**
 *  分配积分墙URL Scheme
 *  @param scheme
 */
- (void)setURLScheme:(NSString*) scheme;

/**
 *  使用Publisher ID初始化积分墙ViewController
 *  @param publisherID
 */
- (id)initWithPublisherID:(NSString *)publisherID;

/**
 *  使用Publisher ID和应用当前登陆用户的User ID（或其它的在应用中唯一标识用户的ID）初始化积分墙ViewController
 *  @param publisherID
 *  @param userID
 */
- (id)initWithPublisherID:(NSString *)publisherID
                andUserID:(NSString *)userID;

/**
 *  更改userID
 *  @param publisherID
 */
- (void)setUserID:(NSString *)userID;

/*-------------------------------------------插屏积分墙-----------------------------------------------*/
/**
 *  列表积分墙开关
 *  @param
 */
- (BOOL)isJoyListEnable;

/**
 *  使用App的rootViewController来弹出并显示积分墙
 *  @param
 */
- (void)presentJoy;

/**
 *  使用开发者传入的UIViewController来弹出显示积分墙
 *  @param controller
 */
- (void)presentJoyWithViewController:(UIViewController *)controller;

/*-------------------------------------------插屏积分墙-----------------------------------------------*/

/**
 *  插屏积分墙开关
 *  @param
 */
- (BOOL)isJoyFlatEnable;

/**
 *  请求加载插屏积分墙
 *  @param
 */
- (void)loadJoyInterstitial;

/**
 *  询问积分墙插屏是否完成
 *  @param
 */
- (BOOL)isJoyInterstitialReady;

/**
 *  显示加载完成的积分墙插屏。若没有加载完成，不会展现
 *  @param
 */
- (void)presentJoyInterstitial;

/*-------------------------------------------积分查询-----------------------------------------------*/
/**
 *  查询积分.
 *  @param
 */
- (void)requestOnlinePointCheck;

/**
 *  消费指定积分
 *  @param pointToConsume
 */
- (void)requestOnlineConsumeWithPoint:(NSUInteger)pointToConsume;

@end
