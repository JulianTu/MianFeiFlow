//
//  LLMethodTable.m
//  免费流量王
//
//  Created by keyrun on 14-10-15.
//  Copyright (c) 2014年 keyrun. All rights reserved.
//

#import "LLMethodTable.h"
#import "ShareMethodCell.h"
#import "LLAsynURLConnection.h"
#import "LoadingView.h"
#import "TablePullToLoadingView.h"
#import "UIAlertView+NetPrompt.h"
#define kMethodCellH      65.5f
@implementation LLMethodTable
{
    NSMutableArray *methods ;
    int failCount ;
    int locationPage;
    int curPage ;
    int maxPage ;
}
@synthesize haveRequest =_haveRequest ;
-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        
        self.separatorStyle = UITableViewCellSeparatorStyleNone ;
        self.delegate =self;
        self.dataSource =self;
        
        TablePullToLoadingView *loadingView = [[TablePullToLoadingView alloc] init];
        self.tableFooterView = loadingView;
        self.tableFooterView.hidden = YES;
    }
    return self;
}
- (void) initShareMethodData{
    failCount = 0;
    locationPage =1;
    methods =[[NSMutableArray alloc] init];
    [self performSelector:@selector(requestForShareMethod) onThread:[NSThread currentThread] withObject:nil waitUntilDone:NO];
}
/**
*  请求分享方法
*/
-(void) requestForShareMethod{
    if (![[LoadingView showLoadingView] actViewIsAnimation] && locationPage ==1) {
        [[LoadingView showLoadingView] actViewStartAnimation];
    }

    NSString *urlStr =[NSString stringWithFormat:kOnlineWeb,@"invite/strategy/"];
    urlStr =[urlStr stringByAppendingString:NSStringFromInt(locationPage)];
    [LLAsynURLConnection requestForMethodGetWithURL:urlStr dataDic:nil andProtocolNum:@"70004" andTimeOut:httpTimeout successBlock:^(NSData *data) {
       dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
           NSDictionary *dataDic =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
           NSLog(@" 获取分享攻略数据 == %@ ",dataDic);
           if ([[dataDic objectForKey:@"flag"] intValue] ==1) {
               _haveRequest =YES;
               NSDictionary *body =[dataDic objectForKey:@"body"];
               NSArray *array = [body objectForKey:@"lists"];
               if (methods.count!=0) {
                   for (NSDictionary *dic in array) {
                       [methods addObject:dic];
                   }
               }else{
                   methods =[[NSMutableArray alloc] initWithArray:array] ;
               }
               curPage =[[body objectForKey:@"curpage"] intValue];
               maxPage =[[body objectForKey:@"maxpage"] intValue];
               dispatch_async(dispatch_get_main_queue(), ^{
                   [self reloadData];
                    [[LoadingView showLoadingView] actViewStopAnimation];
               });
               locationPage++;
           }else{
               dispatch_async(dispatch_get_main_queue(), ^{
                   [[LoadingView showLoadingView] actViewStopAnimation];
               });
           }
       });
         self.tableFooterView.hidden = YES;

    } andFailBlock:^(NSError *error) {
        _haveRequest =NO;
        if(error.code == timeOutErrorCode){
            if(failCount < 2){
                failCount ++;
                [self requestForShareMethod];
            }else{
                [[LoadingView showLoadingView] actViewStopAnimation];
                failCount = 0;
                self.tableFooterView.hidden = YES;
                if(![UIAlertView isInit]){
                    UIAlertView *alertView = [UIAlertView showNetAlert];
                    alertView.tag = kTimeOutTag;
                    alertView.delegate = self;
                    [alertView show];
                }
            }
        }else{
            [[LoadingView showLoadingView] actViewStopAnimation];
            self.tableFooterView.hidden = YES;
        }

    }];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == kTimeOutTag){
        if(buttonIndex == 0){
            [alertView dismissWithClickedButtonIndex:0 animated:YES];
            [UIAlertView resetNetAlertNil];
            [[LoadingView showLoadingView] actViewStartAnimation];
            [self requestForShareMethod];
        }
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return methods.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *string = @"cellID";
    ShareMethodCell *cell =[tableView dequeueReusableCellWithIdentifier:string];
    if (!cell) {
        cell = [[ShareMethodCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:string];
    }
    NSDictionary *dic =[methods objectAtIndex:indexPath.row];
    int value =[[dic objectForKey:@"is_hot"] intValue];
    int value2 =[[dic objectForKey:@"is_new"] intValue];
    ShareTipType type;
    if (value ==0 && value2 ==0) {
        type =ShareTipTypeNo ;
    }else if (value == 1 && value2 ==0){
        type =ShareTipTypeHot ;
    }else if (value ==0 && value2 ==1){
        type =ShareTipTypeNew ;
    }
    [cell loadMethodCellWith:[dic objectForKey:@"title"] andContent:[dic objectForKey:@"sub_title"] withTipType:type];
    for (UIView *currentView in cell.subviews)
    {
        if([currentView isKindOfClass:[UIScrollView class]])
        {
            ((UIScrollView *)currentView).delaysContentTouches = NO;
            break;
        }
    }
    
    return cell ;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return kMethodCellH ;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
     [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    NSDictionary *dic =[methods objectAtIndex:indexPath.row];
    NSString *url =[dic objectForKey:@"url"];
    NSString *name =[dic objectForKey:@"title"];
    [self.methodDelegate selectedMethodTableIndex:indexPath.row andUrl:url andName:name] ;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    float y_float = self.contentOffset.y;
    if (y_float < 0)
        return;
    
    if (methods.count != 0 && curPage != maxPage) {
        CGPoint offset = scrollView.contentOffset;
        CGRect bounds = scrollView.bounds;
        CGSize size = scrollView.contentSize;
        UIEdgeInsets inset = scrollView.contentInset;
        float y = offset.y + bounds.size.height - inset.bottom;
        float h = size.height;
        //        float reload_distance = 2 * kTableLoadingViewHeight2_0;
        if(y > h - 1) {
            self.tableFooterView.hidden = NO;
            [self requestForShareMethod];
        }else{
            self.tableFooterView.hidden = YES;
        }
    }else{
        self.tableFooterView.hidden =YES;
    }
}

@end
