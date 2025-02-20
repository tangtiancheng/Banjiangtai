//
//  XPScrapePrizeView.m
//  XPApp
//
//  Created by 唐天成 on 16/4/7.
//  Copyright © 2016年 ShareMerge. All rights reserved.
//

#import "XPScrapePrizeListView.h"
#import "XPScrapePrizeView.h"
@interface XPScrapePrizeListView()
@property (nonatomic, strong)UIScrollView* scrollerView;

@end

@implementation XPScrapePrizeListView
-(instancetype)initWithFrame:(CGRect)frame{
    if(self=[super initWithFrame:frame]){
//        self.backgroundColor=[UIColor greenColor];
        self.scrollerView=[[UIScrollView alloc]init];
        self.scrollerView.showsHorizontalScrollIndicator=NO;
        self.scrollerView.showsVerticalScrollIndicator=NO;
//        self.scrollerView.bounces=NO;
        [self addSubview:self.scrollerView];
        [self.scrollerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
//        self.scrollerView.backgroundColor=[UIColor purpleColor];
        
        
    }
    return self;
}
-(void)setPrizeList:(NSArray*)prizeList{
    _prizeList=prizeList;
    [self layoutIfNeeded];
    [self.scrollerView layoutIfNeeded];
    
    NSLog(@"%@",NSStringFromCGRect(self.scrollerView.frame));
    UIView* prizeListBackView=[[UIView alloc]init];
//    prizeListBackView.backgroundColor=[UIColor yellowColor];
    [self.scrollerView addSubview:prizeListBackView];
    
    if(prizeList.count>3){
        prizeListBackView.left=0 ;
        prizeListBackView.top=0;
        prizeListBackView.width=self.scrollerView.width;
        prizeListBackView.height=self.scrollerView.height/3*prizeList.count;

//    [prizeListBackView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.scrollerView);
//        make.left.equalTo(self.scrollerView);
//        make.right.equalTo(self.scrollerView);
////        make.bottom.equalTo(self.scrollerView);
//        make.width.equalTo(@(self.width));
//        make.height.equalTo(@(self.height/3*prizeList.count));
//
//    }];
//        prizeListBackView.frame=CGRectMake(0, 0, self.width, self.height/3*prizeList.count);
//        [prizeListBackView layoutIfNeeded];
        self.scrollerView.contentSize=CGSizeMake(prizeListBackView.width, prizeListBackView.height);
        NSLog(@"%@",NSStringFromCGSize( self.scrollerView.contentSize));
        NSLog(@"%@",NSStringFromCGRect(prizeListBackView.frame));
    }else{
    [prizeListBackView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.scrollerView);
        make.left.equalTo(self.scrollerView);
        make.right.equalTo(self.scrollerView);
//        make.bottom.equalTo(self.scrollerView);
        make.width.equalTo(@(self.width));
        make.height.equalTo(@(self.height/3*prizeList.count));
        make.centerY.equalTo(self.scrollerView.mas_centerY);
    }];
    }
    
//    prizeListBackView se
     NSLog(@"%@",NSStringFromCGRect(self.scrollerView.frame));
    for(int i=0;i<prizeList.count;i++ ){
        NSLog(@"%ld",prizeList.count);
        XPMainPlainPrizeModel* prizeModel=prizeList[i];
        XPScrapePrizeView* scrapePrizeView=[[XPScrapePrizeView alloc]init];
//        scrapePrizeView.backgroundColor=[UIColor randomColor];
        [prizeListBackView addSubview:scrapePrizeView];
        
        [scrapePrizeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(prizeListBackView);
            make.right.equalTo(prizeListBackView);
            make.height.equalTo(@(self.height/3));
            
            if(i==0){
                make.top.equalTo(prizeListBackView);
            }else{
                make.top.equalTo(prizeListBackView.subviews[i-1].mas_bottom);
            }
//            if(i==prizeList.count-1){
//                make.bottom.equalTo(prizeListBackView);
//            }
        }];
        
        scrapePrizeView.mainPlainPrizeModel=prizeModel;
        [scrapePrizeView layoutIfNeeded];
        NSLog(@"%@",NSStringFromCGRect(scrapePrizeView.frame));
    }
    NSLog(@"%@",prizeListBackView.subviews);
    
}
@end
