//
//  HSDAutoSelectView.m
//  HaoShiDai
//
//  Created by 唐明明 on 2017/11/22.
//  Copyright © 2017年 360haoshidai. All rights reserved.
//

#import "HSDAutoSelectView.h"

//获取屏幕 宽度、高度
#define D_W ([UIScreen mainScreen].bounds.size.width)
#define D_H ([UIScreen mainScreen].bounds.size.height)
#define IS_IPHONE_X    (([[UIScreen mainScreen] bounds].size.height) ==812)
#define SELECTVIEW_HIGHT 264.0f //选择视图默认高
#define ROW_HIGHT 44.0f //选择视图默认高

typedef NS_ENUM(NSInteger, HSDAutoSelectViewPoint) {
    HSDAutoSelectViewPointTop = 0,
    HSDAutoSelectViewPointBottom = 1
};


@interface HSDAutoSelectView()

@property(nonatomic,strong)AutoSelectCallBack selectCallBack;

@end


@implementation HSDAutoSelectView


-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setFrame:CGRectMake(0, 0, D_W, D_H)];
    }
    
    return self;
}


+(HSDAutoSelectView *)instanceView
{
    HSDAutoSelectView * instanceSelectView = [[[NSBundle mainBundle]loadNibNamed:@"HSDAutoSelectView" owner:nil options:nil]firstObject];
    instanceSelectView.selectIndex = -1;
    return instanceSelectView;
}


/**
 显示在某个视图上

 @param atView 基于的视图
 @param size 大小
 @param callback 选择回调
 */
//-(void)showWithView:(UIView *)atView viewSize:(CGSize)size callBack:(AutoSelectCallBack)callback
//{
//    
////    [self.bottomView setClipsToBounds:YES];
////    [self.bottomView.layer setCornerRadius:8.0f];
////    //[self.bottomView.layer setBorderWidth:1.0f];
////    //[self.bottomView.layer setBorderColor:[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0f].CGColor];
////
////    [self.tableView setDelegate:self];
////    [self.tableView setDataSource:self];
////    CGRect atrect = [[UIApplication sharedApplication].delegate.window convertRect:atView.frame fromView:atView.superview];
////
////    CGRect rect = CGRectMake(atrect.origin.x-2, atrect.origin.y+atrect.size.height+4, size.width, size.height);
////    [self.bottomView setFrame:rect];
////    [self.tableView setFrame:CGRectMake(8, 8, size.width -16, size.height -16)];
////
////    [[UIApplication sharedApplication].delegate.window addSubview:self];
////
////    [self bezierPathHollowOut:atrect];
//    
//}

/**
 显示在某个视图上
 
 @param atView 基于的视图
 @param callback 选择回调
 */
-(void)showWithView:(UIView *)atView callBack:(AutoSelectCallBack)callback
{
    self.selectCallBack = callback;
    
    //设置tableView代理
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.tableView setAlwaysBounceVertical:YES];
    //自适应位置
    [self autoPoint:atView];
    
    
    
    [[UIApplication sharedApplication].delegate.window addSubview:self];
    
   
    
}


#pragma mark -添加点击事件
-(void)addTap:(CGRect)atrect
{
    UIView *maskView = [[UIView alloc] initWithFrame:atrect];
    [maskView setBackgroundColor:[UIColor clearColor]];
    [self addSubview:maskView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
    [maskView addGestureRecognizer:tap];
    
//        UITapGestureRecognizer *viewtap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
//        [self addGestureRecognizer:viewtap];
    [self addTarget:self action:@selector(tapClick) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark -点击隐藏
-(void)tapClick
{
    //    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, DISPATCH_QUEUE_PRIORITY_DEFAULT);
    //    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 0.25f * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    //    dispatch_source_set_event_handler(timer, ^{
    
    //    });
    //    dispatch_resume(timer);
    
    [UIView animateWithDuration:0.25f animations:^{
        [self setAlpha:0.0f];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}


#pragma mark -自动适应选择视图的位置
-(void)autoPoint:(UIView *)atView
{
    //获取基于视图在window上面的frame
    CGRect atrect = [[UIApplication sharedApplication].delegate.window convertRect:atView.frame fromView:atView.superview];
    //添加按钮位置视图和点击事件
    [self addTap:atrect];
    
    [self setHidden:YES];
    dispatch_async(dispatch_get_main_queue(), ^{
        CGFloat offset = 20;
        if (IS_IPHONE_X) {
            offset = 44;
        }
        
        CGFloat tableViewHeight = 44;
        if (self.tableView.contentSize.height < SELECTVIEW_HIGHT && self.tableView.contentSize.height > 40)
        {
            tableViewHeight = self.tableView.contentSize.height;
        }
        else if(self.tableView.contentSize.height >= SELECTVIEW_HIGHT)
        {
            tableViewHeight = SELECTVIEW_HIGHT;
        }
        
        
        //计算frame能放下选择视图的可能性
        CGFloat top = atrect.origin.y - offset;//顶部空间
        CGFloat bottom = D_H - (atrect.origin.y + atrect.size.height)-offset;//底部空间
        
        if (bottom >= SELECTVIEW_HIGHT) {//如果底部空间大于选择视图的大小
            CGRect rect = CGRectMake(atrect.origin.x-2, atrect.origin.y+atrect.size.height+2, atView.frame.size.width+4, tableViewHeight +2);
            [self.bottomView setFrame:rect];
            
            [self.tableView setFrame:CGRectMake(0, 1, rect.size.width, tableViewHeight)];
            
            [self bezierPathHollowOut:atrect point:HSDAutoSelectViewPointBottom];
        }
        else if(top > SELECTVIEW_HIGHT) {//如果顶部空间大于选择视图的大小
            CGRect rect = CGRectMake(atrect.origin.x-2, atrect.origin.y-(tableViewHeight+2), atView.frame.size.width+4, tableViewHeight +2);
            [self.bottomView setFrame:rect];
            
            [self.tableView setFrame:CGRectMake(0, 1, rect.size.width, tableViewHeight)];
            
            [self bezierPathHollowOut:atrect point:HSDAutoSelectViewPointTop];
        }
        else//顶部和底部的空间都没有选择视图的默认大小大，使用底部或者顶部空间大小作为选择视图大小
        {
            if(top > bottom)//顶部空间大，放顶部
            {
                CGRect rect = CGRectMake(atrect.origin.x-2, offset, atView.frame.size.width+4, top);//预留空间
                [self.bottomView setFrame:rect];
                
                [self.tableView setFrame:CGRectMake(0, 1, rect.size.width , rect.size.height -2)];
                
                [self bezierPathHollowOut:atrect point:HSDAutoSelectViewPointTop];
            }
            else//反之则全部放底部
            {
                CGRect rect = CGRectMake(atrect.origin.x-2, atrect.origin.y+atrect.size.height+2, atView.frame.size.width+4, bottom);//预留空间
                [self.bottomView setFrame:rect];
                
                [self.tableView setFrame:CGRectMake(0, 1, rect.size.width , rect.size.height -2)];
                
                [self bezierPathHollowOut:atrect point:HSDAutoSelectViewPointBottom];
            }
        }
        [self setHidden:NO];
        
        if (self.selectIndex != -1 && self.dataArray.count > self.selectIndex) {
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectIndex inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:YES];
        }
        
    });
    
    
    
    
    
   
}




#pragma mark -绘制镂空视图

/**
 绘制镂空视图

 @param atrect 绘制范围
 @param p 选择视图基于视图的位置
 */
-(void)bezierPathHollowOut:(CGRect)atrect point:(HSDAutoSelectViewPoint)p
{
    
    if (p == HSDAutoSelectViewPointBottom) {
        //设置所需的圆角位置以及大小
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bottomView.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(4, 4)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.bottomView.bounds;
        maskLayer.path = maskPath.CGPath;
        self.bottomView.layer.mask = maskLayer;
        
        
        // 创建一个全屏大的path
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:[UIApplication sharedApplication].delegate.window.bounds];
        // 创建按钮位置path
        UIBezierPath *rectPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(atrect.origin.x-2, atrect.origin.y-4, atrect.size.width+4, atrect.size.height+12) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(4, 4)];
        //叠加path，重叠的部分将会镂空透明
        [path appendPath:rectPath];
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.fillRule = kCAFillRuleEvenOdd;//中间镂空的关键点 填充规则
        shapeLayer.path = path.CGPath;
        self.layer.mask = shapeLayer;
    }
    else  if (p == HSDAutoSelectViewPointTop)
    {
        //设置所需的圆角位置以及大小
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bottomView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(4, 4)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.bottomView.bounds;
        maskLayer.path = maskPath.CGPath;
        self.bottomView.layer.mask = maskLayer;
        
        
        // 创建一个全屏大的path
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:[UIApplication sharedApplication].delegate.window.bounds];
        // 创建一个按钮位置的path
        UIBezierPath *rectPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(atrect.origin.x-2, atrect.origin.y-8, atrect.size.width+4, atrect.size.height+12) byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(4, 4)];
        //叠加path，重叠的部分将会镂空透明
        [path appendPath:rectPath];
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.fillRule = kCAFillRuleEvenOdd;//中间镂空的关键点 填充规则
        shapeLayer.path = path.CGPath;
        self.layer.mask = shapeLayer;
    }
}



#pragma mark - TableDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dataArray) {
        return self.dataArray.count;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ROW_HIGHT;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"myCell"];
    }
    
    if (indexPath.row < self.dataArray.count) {
        NSString *title = self.dataArray[indexPath.row];
        [cell.textLabel setText:title];
        [cell.textLabel setFont:[UIFont systemFontOfSize:14.0f]];
        
        if (self.selectIndex != -1 && self.selectIndex == indexPath.row && self.selectIndex < self.dataArray.count) {
            //设置自定义图片勾选样式
//            UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
//            [img setImage:[UIImage imageNamed:@"auto_selected"]];
//            cell.accessoryView = img;
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
        {
            //cell.accessoryView = nil;
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        if (indexPath.row != 0) {
            UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 0.5)];
            [line setBackgroundColor:[UIColor lightGrayColor]];
            [cell addSubview:line];
        }
        
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (self.selectCallBack) {
        self.selectCallBack(indexPath.row, cell.textLabel.text);
    }
    
    [self tapClick];
    
}



@end
