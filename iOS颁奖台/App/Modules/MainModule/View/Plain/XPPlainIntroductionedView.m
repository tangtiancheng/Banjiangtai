//
//  XPPlainIntroductionedView.m
//  XPApp
//
//  Created by 唐天成 on 16/4/28.
//  Copyright © 2016年 ShareMerge. All rights reserved.
//

#import "XPPlainIntroductionedView.h"
#import <Masonry.h>
#import <ReactiveCocoa.h>
@interface XPPlainIntroductionedView()
//关闭按钮
@property (nonatomic, strong)UIButton* closeIntroductionBtn;
//滚动视图
@property (nonatomic, strong)UIScrollView* scrollerVIew;
//活动简介label
@property (nonatomic, strong)UILabel* label;

@property(nonatomic,assign,getter=isPush)BOOL push;
@end

@implementation XPPlainIntroductionedView
-(void)setPlainIntroduction:(NSString *)plainIntroduction{
//    plainIntroduction=@"dsjfdsjkfdjslfjdlajflkejiorwureowiuraojfajjfldsjflsnf,ns,zfn,dsnf,mdns,fnsd,mnf,snfdsnf,sdnfnefjdlfdsfldksjfhjksdhkfjhskdfhdskjhfkdshfkshfkdhskfhdskjfeu的客户机是否符合的客户发空间按收费空间的首付诶我人也UI无烟日uew";
    plainIntroduction =[plainIntroduction stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
    //当接收到活动简介字符串时
    
    _plainIntroduction=plainIntroduction;
    NSLog(@"%@",plainIntroduction);
    
    UIFont* labelFont=[UIFont systemFontOfSize:textFontSize];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    [paragraphStyle setLineSpacing:labelLineSpace];
//    paragraphStyle.alignment = NSTextAlignmentLeft;  //对齐
//    [paragraphStyle setFirstLineHeadIndent:30.0];
//     paragraphStyle.headIndent = 10;          //行首缩进
    NSDictionary *dict = @{NSFontAttributeName:labelFont ,NSParagraphStyleAttributeName:paragraphStyle};
    
    CGSize textSize = [plainIntroduction boundingRectWithSize:CGSizeMake(self.frame.size.width-2*borderr, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    
    //    NSLog(@"%@",NSStringFromCGSize(size));
    self.label.frame=CGRectMake(0, 0, textSize.width, textSize.height);
    //    self.label.backgroundColor=[UIColor greenColor];
    //    self.label.text=detailPlain;
    //    [self.label sizeToFit];
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:_plainIntroduction];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:labelLineSpace];
//    [paragraphStyle1 setFirstLineHeadIndent:40.0];
//    paragraphStyle1.headIndent = 30;          //行首缩进

    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [_plainIntroduction length])];
    [self.label setAttributedText:attributedString1];
//    self.label.backgroundColor=[UIColor greenColor];
    [self.label sizeToFit];
    self.scrollerVIew.contentSize=CGSizeMake(textSize.width, textSize.height);
    
}


-(id)initWithFrame:(CGRect)frame{
    if(self=[super initWithFrame:frame]){
        @weakify(self)
        
        
//        self.backgroundColor=[UIColor yellowColor];
        //背景图
        UIImageView* imageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"intoductionViewBG"]];
//        imageView.contentMode=UIViewContentModeScaleAspectFill;
        imageView.userInteractionEnabled=YES;
        [self addSubview:imageView];
        UIButton* closeBtn=[[UIButton alloc]init];
        [closeBtn setImage:[UIImage imageNamed:@"closeIntroduction"] forState:UIControlStateNormal];
        [[closeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            NSLog(@"%p",self.superview);
//            [self removeFromSuperview];
            [self.superview removeFromSuperview];
        }];
//        [closeBtn setTitle:@"123" forState:UIControlStateNormal];
//        [closeBtn setBackgroundColor:[UIColor orangeColor]];
        [self addSubview:closeBtn];
        

        self.scrollerVIew=[[UIScrollView alloc]init];
        
        self.scrollerVIew.showsHorizontalScrollIndicator=NO;
        self.scrollerVIew.showsVerticalScrollIndicator=NO;
        
        [imageView addSubview:self.scrollerVIew];
//        self.scrollerVIew.backgroundColor=[UIColor greenColor];
        
        [self.scrollerVIew mas_makeConstraints:^(MASConstraintMaker *make) {
            //        make.topMargin.mas_equalTo(10);
            make.left.mas_equalTo(imageView.mas_left).offset(borderr);
            make.top.mas_equalTo(imageView.mas_top).offset(topBorder);
            make.bottom.mas_equalTo(imageView.mas_bottom).offset(-bottomBorder);
            make.right.mas_equalTo(imageView.mas_right).offset(-borderr);
        }];
        [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.bottom.equalTo(self);
            make.width.equalTo(@35);
            make.height.equalTo(@35);
        }];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.top.equalTo(self);
            make.right.equalTo(self);
            make.bottom.equalTo(closeBtn.mas_top);
        }];
        self.label=[[UILabel alloc]init];
        self.label.backgroundColor=[UIColor clearColor];
        [self.scrollerVIew addSubview:self.label];
        //    self.label.lineBreakMode = UILineBreakModeWordWrap;
        self.label.numberOfLines=0;
        self.label.font=[UIFont systemFontOfSize:textFontSize];
        self.label.textColor=[UIColor whiteColor];
        

        
    }
    return self;
}
@end
