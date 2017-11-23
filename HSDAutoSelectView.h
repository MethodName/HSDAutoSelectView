//
//  HSDAutoSelectView.h
//  HaoShiDai
//
//  Created by 唐明明 on 2017/11/22.
//  Copyright © 2017年 360haoshidai. All rights reserved.
//

#import <UIKit/UIKit.h>


#define SELECTVIEW_HIGHT 300.0f //选择视图高



typedef void (^AutoSelectCallBack)(NSInteger  selectedIndex,NSString *selectTitle);

@interface HSDAutoSelectView : UIControl<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic,strong)NSArray<NSString *> *dataArray;

@property(nonatomic,assign)NSInteger selectIndex;

+(HSDAutoSelectView *)instanceView;

///**
// 显示在某个视图上
//
// @param atView 基于的视图
// @param size 大小
// @param callback 选择回调
// */
//-(void)showWithView:(UIView *)atView viewSize:(CGSize)size callBack:(AutoSelectCallBack)callback;


/**
 显示在某个视图上
 
 @param atView 基于的视图
 @param callback 选择回调
 */
-(void)showWithView:(UIView *)atView callBack:(AutoSelectCallBack)callback;


@end
