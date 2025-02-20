//
//  XPTasteDetailViewController.m
//  XPApp
//
//  Created by 唐天成 on 16/7/4.
//  Copyright © 2016年 ShareMerge. All rights reserved.
//

#import "XPTasteDetailViewController.h"
#import "XPTasteStoreViewModel.h"
#import "MXNavigationBarManager.h"
#import "TCTableViewCell.h"
#import "TCCollectionViewCell.h"
#import "XLPlainFlowLayout.h"
#import "TCCollectionReusableView.h"
#import "TCHeadView.h"
#import "NSString+XPRemoteImage.h"
#import "DishDetailViewController.h"
#import "TCWhiteView.h"
#import "TCOrderingView.h"
#import <ReactiveCocoa.h>
#import "TCCustomBtn.h"
#import "TastorderMenuViewController.h"
#import "TCUnUserCollectionViewCell.h"
#import "XPBaseNavigationViewController.h"
#import <XPViewPager/XPViewPager.h>
#import "XPTastDetailFirstViewController.h"


#define SCREEN_RECT [UIScreen mainScreen].bounds
#define SCREEN_W [UIScreen mainScreen].bounds.size.width
#define SCREEN_H [UIScreen mainScreen].bounds.size.height


#define OrderingViewHeight 50
#define HeaderViewHeight 200
//向上移动64之后颜色全满
#define FullAlphaHeight 84
//tableView的宽
#define TableViewWidth 81
//collectionViewCell的间距
#define CollectionViewCellSpace 10
//collectonView的列数
#define CollectionViewVerticalNumber 2
//collectionView每个section的头的高度
#define CollectionViewHeaderHeight 20
//collectionViewCell的size
#define CollectionViewCellItemSize CGSizeMake((SCREEN_W-TableViewWidth-(CollectionViewVerticalNumber-1)*CollectionViewCellSpace)/CollectionViewVerticalNumber, (SCREEN_W-TableViewWidth-(CollectionViewVerticalNumber-1)*CollectionViewCellSpace)/CollectionViewVerticalNumber * 8 / 9)
//tableView的size
#define TableViewSize CGSizeMake(TableViewWidth, self.footView.frame.size.height)

static NSString *const kMXCellIdentifer = @"kMXCellIdentifer";
static const CGFloat headerImageHeight = 260.0f;
//注册tableViewCell的标示
static NSString* tableViewIndentifier = @"TCTableViewCell";
//注册collectionViewCell的标示
static NSString* collectionViewIndentifier = @"TCCollectionViewCell";
//注册UnUsercollectionViewCell的标示
static NSString* unUsercollectionViewIndentifier = @"TCUnUserCollectionViewCell";
//注册collectionViewHead的标示
static NSString* collectionViewHead = @"TCCollectiionViewHead";


@interface XPTasteDetailViewController()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,TCCollectionViewCellDelegate>
{
    //这是每个collectionViewCell的itemSize
    CGSize itemSize;
    //这个表示现在是左边控制的滑动还是右边|||YES表示左边,NO表示右边
    BOOL isLeftController ;
    
    //荤菜数
    NSInteger meatDishCount;
    //素菜数
    NSInteger vegetableDishCount;
    //汤数
    NSInteger soupCount;
//    两荤3素4汤+其他
    NSString *allDishStr;
    //总价格
    CGFloat consumPrice;
}

//底层视图
@property (nonatomic, strong)UIView* backView;
//分组视图
//@property (nonatomic, strong)XPViewPager* viewPager;

//头部视图
@property (nonatomic, strong)TCHeadView* headView;
//白色顶层视图
@property (nonatomic, strong)TCWhiteView* whiteView;

//尾部视图
@property (nonatomic, strong)UIView* footView;
//尾部左边的tableView视图
@property (nonatomic, strong)UITableView* tableView;
//尾部右边的collectionView视图
@property (nonatomic, strong)UICollectionView* collectionView;
//最末端的点菜视图
@property(nonatomic,strong)TCOrderingView* orderingView;


@property (nonatomic, strong)XPTasteStoreViewModel* tasteStoreViewModel;

////菜模型数组
//@property (nonatomic, strong)XPDashInfoModel* dashInfoModel;

////商家模型(最大的,包括其他小模型)
@property (nonatomic, strong)XPTastStoreModel* tastStoreModel;
//私有房间模型
@property(nonatomic,strong)XPPrivateRoomModel* privateRoom;
//菜的种类列表数组
@property (nonatomic, strong)NSArray<XPMeunModel *> *meunList;
//wifi,热水,停车场数组
@property (nonatomic, strong)NSArray<NSString*> *businessTag;

//存储高度的数组
@property (nonatomic, strong)NSMutableArray* heightMutableArray;
// 小吃快餐,朋友聚餐,老字号,情侣约会,上班族
@property (nonatomic, strong)NSArray* storeTags;

//已点菜数组
@property (nonatomic, strong)NSMutableArray<XPTastOrderingModel*>* tastOrderingModelArray;


@end

@implementation XPTasteDetailViewController
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed=YES;
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
        self.tableView.delegate = self;
    self.collectionView.delegate=self;
    [MXNavigationBarManager changeAlphaWithCurrentOffset:self.collectionView.contentOffset.y];

//     [self initBarManager];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
        self.tableView.delegate = nil;
//    self.collectionView.delegate=nil;
//    [MXNavigationBarManager reStoreWithZeroStatus];
//    [MXNavigationBarManager reStore];
}
//210 是头视图的高度的
//64 是往上滚动64之后navigationBar完全不透明


-(void)viewDidLoad{
    [super viewDidLoad];
    
//    self.view.backgroundCrolor=[UIColor greenColor];
   self.title=@"商家名字";
    @weakify(self);

    
    [self initBarManager];
       self.automaticallyAdjustsScrollViewInsets=NO;
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"closeIntroduction"] style:UIBarButtonItemStylePlain target:self action:@selector(navigationBarLeftClick)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"123" style:UIBarButtonItemStylePlain target:self action:nil];
    //[[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(navigationBarLeftClick)];//[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"addBtn1"] style:UIBarButtonItemStylePlain target:self action:@selector(navigationBarLeftClick)];
    self.backView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H + FullAlphaHeight)];
    [self.view addSubview:self.backView];
    //设置头
    [self setHeadView];
    
    //设置尾
    [self setFootView];
    

    //regist注册
    [self regist];
    
    [self scrollViewDidScroll:self.collectionView];
//
    self.tasteStoreViewModel.businessId = [(NSArray *)self.model.baseTransfer objectAtIndex:0];
    self.tasteStoreViewModel.business_store_id = [(NSArray *)self.model.baseTransfer objectAtIndex:1];
    NSString* logStr=[(NSArray *)self.model.baseTransfer objectAtIndex:2];
    self.headView.logoString=logStr;
    
    self.storeTags = [(NSArray *)self.model.baseTransfer objectAtIndex:3];
    NSMutableArray* storeTagsM=[NSMutableArray array];
    for(NSDictionary* storeTagDictionary in self.storeTags){
        NSString* storeTag = storeTagDictionary[@"storeTag"];
        [storeTagsM addObject:storeTag];
    }
    self.headView.storeTags=storeTagsM;
    NSLog(@"%@",[(NSArray *)self.model.baseTransfer objectAtIndex:3]);
       [self rac_liftSelector:@selector(cleverLoader:) withSignals:RACObserve(self.tasteStoreViewModel, executing), nil];
    [self rac_liftSelector:@selector(showToastWithNSError:) withSignals:[[RACObserve(self.tasteStoreViewModel, error) ignore:nil] map:^id (id value) {
        
        return value;
    }], nil];
    //给商家logo赋值
//    NSLog(@"%@",self.headView);
//   [[[[RACObserve(self, model.baseTransfer[2])ignore:nil] flattenMap:^RACStream *(NSString *value) {
//                return value ? [value rac_remote_image] : [RACSignal return :nil];
//            }] deliverOn:[RACScheduler mainThreadScheduler]]subscribeNext:^(id x) {
//                NSLog(@"%@   %@",self.headView,x);
//                self.headView.storeImageView.image =x;
//            }];

    [[RACObserve(self, tasteStoreViewModel.tastStoreModel)ignore:nil]subscribeNext:^(XPTastStoreModel* x) {
        self.tastStoreModel = x;
        
        self.privateRoom=x.privateRooms;
        self.meunList=x.meunList;
        self.businessTag=x.businessTag;
        
        self.title=x.businessName;
        [self.tableView reloadData];
        [self.collectionView reloadData];
            [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
        
    }];
   
    [[RACObserve(self, tastStoreModel)ignore:nil]subscribeNext:^(XPTastStoreModel *tastStoreModel) {
        
        self.headView.privateRoomModel=tastStoreModel.privateRooms;
        self.headView.businessTag=tastStoreModel.businessTag;
        self.whiteView.businessTag=tastStoreModel.businessTag;
        self.headView.businessTimeLabel.text=[NSString stringWithFormat:@"营业时间: %@",tastStoreModel.businessTime];
        self.headView.businessTelLabel.text = [NSString stringWithFormat:@"联系电话: %@",tastStoreModel.businessTel];
        self.headView.businessAddLabel.text = [NSString stringWithFormat:@"商家地址: %@",tastStoreModel.businessAdd];
        self.headView.averagePriceLabel.text=[NSString stringWithFormat:@"￥%@/位",tastStoreModel.averagePrice];
        
        self.heightMutableArray=[NSMutableArray array];
        NSArray* meunList = self.tastStoreModel.meunList;
        for(int i =0;i<meunList.count;i++){
            XPMeunModel* meunModel=meunList[i];
            NSArray* dashArray=meunModel.dashInfo;
            int lineNumber = dashArray.count/2 + dashArray.count%2;
            CGFloat height =itemSize.height * lineNumber + CollectionViewCellSpace * (lineNumber+1) + CollectionViewHeaderHeight;
            if(self.heightMutableArray.count>0){
                NSNumber* lastHeight = [self.heightMutableArray lastObject];
                height = height + lastHeight.floatValue;
                if(i == meunList.count-1){
                    //如果是最后一个,那就加50高度(下面绿色点菜View的高度)-10(空隙)
                    height=height+OrderingViewHeight-CollectionViewCellSpace;
                }
            }
            [self.heightMutableArray addObject:@(height)];
        }
        NSLog(@"%@",self.heightMutableArray);
    }];

        [self.tasteStoreViewModel.tastStoreCommand execute:nil];
}
-(void)navigationBarLeftClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}
//设置头部那块绿色头部视图
-(void)setHeadView{
    self.headView = [TCHeadView headView];//initWithFrame:CGRectMake(0, 0, SCREEN_W, 210)];
    _headView.frame=CGRectMake(0, 0, SCREEN_W, HeaderViewHeight);
    [self.headView setView];
  
    self.headView.backgroundColor=[UIColor greenColor];
    
//    CAGradientLayer *layer = [CAGradientLayer new];
//    layer.colors = @[(__bridge id)RGBA(42, 160, 88, 1).CGColor, (__bridge id)RGBA(163, 212, 185, 1).CGColor];
//    layer.startPoint = CGPointMake(0, HeaderViewHeight/2);
//    layer.endPoint =CGPointMake(SCREEN_W, HeaderViewHeight/2) ;
//    layer.frame = self.headView.bounds;
//    [self.headView.layer insertSublayer:layer atIndex:0];
    
    [self.backView addSubview:self.headView];
    UIImageView* imageV=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0,  SCREEN_W, HeaderViewHeight)];
    imageV.image=[UIImage imageNamed:@"frame"];
    [self.headView addSubview:imageV];
    self.whiteView = [[TCWhiteView alloc]initWithFrame:CGRectMake(0, 64+FullAlphaHeight, SCREEN_W, HeaderViewHeight-64-FullAlphaHeight)];
       self.whiteView.backgroundColor=[UIColor whiteColor];
    [self.headView addSubview:self.whiteView];
    
}
//设置底下的滚动视图
-(void)setFootView{
    self.footView=[[UIView alloc]initWithFrame:CGRectMake(0, HeaderViewHeight, SCREEN_W, SCREEN_H-HeaderViewHeight+FullAlphaHeight)];
    self.footView.backgroundColor=[UIColor purpleColor];
    [self.backView addSubview:self.footView];
    //左边的tableView小标题
    [self setTableView];
    //右边的collectionView商品信息
    [self setCollectionView];
    //尾端点菜视图
    [self setOrderingView];
//    [self.footView addSubview:self.viewPager];
}
//左边的tableView小标题
-(void)setTableView{
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, TableViewWidth, self.footView.frame.size.height) style:UITableViewStylePlain];
    self.tableView.contentInset = UIEdgeInsetsMake(0 , 0, OrderingViewHeight, 0);
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.backgroundColor=RGBA(246, 245, 245, 1);
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    [self.footView addSubview:self.tableView];
}
//右边的collectionView商品信息
-(void)setCollectionView{
    UICollectionViewFlowLayout* layout =[[UICollectionViewFlowLayout alloc]init];
//    layout.scrollDirection=UICollectionViewScrollDirectionHorizontal;

    layout.itemSize = CGSizeMake((SCREEN_W-TableViewWidth-(CollectionViewVerticalNumber-1)*CollectionViewCellSpace)/CollectionViewVerticalNumber, (SCREEN_W-TableViewWidth-(CollectionViewVerticalNumber-1)*CollectionViewCellSpace)/CollectionViewVerticalNumber * 8 / 9);
    itemSize=layout.itemSize;
    NSLog(@"%@",NSStringFromCGSize(layout.itemSize));
    //W:H=9:8
    layout.sectionInset = UIEdgeInsetsMake(CollectionViewCellSpace, 0, CollectionViewCellSpace, 0);
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(TableViewWidth, 0, SCREEN_W-TableViewWidth, self.footView.frame.size.height) collectionViewLayout:layout];
    self.collectionView.contentInset = UIEdgeInsetsMake(0 , 0, OrderingViewHeight-CollectionViewCellSpace, 0);
    self.collectionView.backgroundColor=RGBA(241, 241, 241, 1);
    //    self.collectionView.bounces=NO;
    self.collectionView.dataSource=self;
    self.collectionView.delegate=self;
    
    [self.footView addSubview:self.collectionView];
}

-(void)setOrderingView{
    CGFloat height = OrderingViewHeight;
    self.orderingView = [TCOrderingView orderingView];
    self.orderingView.frame=CGRectMake(0, ScreenH-height, ScreenW, height);
    [self.view addSubview:self.orderingView];
    [[self.orderingView.orderDishBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        NSLog(@"%@",self.tastOrderingModelArray);
        TastorderMenuViewController* orderMenuViewController=[[TastorderMenuViewController alloc]init];
        
        orderMenuViewController.tastOrderingModelArray=self.tastOrderingModelArray;
        XPBaseNavigationViewController* nav=[[XPBaseNavigationViewController alloc]initWithRootViewController:orderMenuViewController];
        [self presentViewController:nav animated:YES completion:nil];
        
//        [self.navigationController pushViewController:orderMenuViewController animated:YES];
        
    }];
}

-(void)regist{
    //注册tableView的Cell
    [self.tableView registerNib:[UINib nibWithNibName:@"TCTableViewCell" bundle:nil] forCellReuseIdentifier:tableViewIndentifier];
    
    //注册collectionView的Cell
    [self.collectionView registerNib:[UINib nibWithNibName:@"TCCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:collectionViewIndentifier];
    
    //注册UnUsercollectionViewCell的标示
    [self.collectionView registerNib:[UINib nibWithNibName:@"TCUnUserCollectionViewCell" bundle:nil]  forCellWithReuseIdentifier:unUsercollectionViewIndentifier];

    //注册collectionViewHead
    [self.collectionView registerNib:[UINib nibWithNibName:@"TCCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:collectionViewHead];
}

#pragma  mark UITbaleViewDataSource/UICollectionDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.meunList.count;;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TCTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:tableViewIndentifier];
//    cell.nameLabel.text=[NSString stringWithFormat:@"%d %d",indexPath.section,indexPath.row];
    XPMeunModel* meunModel = self.tastStoreModel.meunList[indexPath.section];
    cell.nameLabel.text = meunModel.dashClassName;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 52;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    isLeftController = YES;
//    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
    [UIView animateWithDuration:0.3 animations:^{
    
    if(indexPath.section == 0){
            //若为第0个,那就直接滚到最上
            
//            self.collectionView.contentOffset=CGPointMake(0, 0);
            [self.collectionView scrollToTopAnimated:YES];
        }else{//如果非第一个
            
            CGFloat lastHeight =[self.heightMutableArray[self.heightMutableArray.count - 1] floatValue] - [self.heightMutableArray[indexPath.section-1] floatValue];
            if(lastHeight >= self.collectionView.height){
                //如果最后的剩余高度大于等于collectionView的高度
                NSNumber *contentHeightNumber =self.heightMutableArray[indexPath.section-1];
                CGFloat contentHeight = contentHeightNumber.floatValue;
                self.collectionView.contentOffset=CGPointMake(0, contentHeight);
            }else{
                if([self.heightMutableArray[self.heightMutableArray.count-1] floatValue]<self.collectionView.height){
                //若整个heightMutableArray的高度都比collectionView的高度小
                    [self.collectionView scrollToTopAnimated:YES];
                }else{
                //若整个heightMutableArray的高度不比collectionView的高度小
                    CGFloat scrollHeight =[self.heightMutableArray[self.heightMutableArray.count - 1] floatValue] - self.collectionView.height;
                     self.collectionView.contentOffset=CGPointMake(0, scrollHeight);
                }
            }
        }
//        self.collectionView.contentOffset=CGPointMake(self.collectionView.contentOffset.x, self.collectionView.contentOffset.y-20);
    }];
}
#pragma  mark UICollectionViewDataSource/UIcollectionViewDelegate

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.meunList.count;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    XPMeunModel* menuModel = self.meunList[section];
    NSArray<XPDashInfoModel *>*dashInfoModelArray = menuModel.dashInfo;
    NSLog(@"%ld",dashInfoModelArray.count);
    if(dashInfoModelArray.count % 2 != 0){
        return dashInfoModelArray.count+1;
    }
    return dashInfoModelArray.count;
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    XPMeunModel* meunModel = self.meunList[indexPath.section];
    
    if(meunModel.dashInfo.count % 2 != 0){
        if(indexPath.item == meunModel.dashInfo.count){
            NSLog(@"%ld   %ld",indexPath.section,indexPath.item);
        UICollectionViewCell* cell=[collectionView dequeueReusableCellWithReuseIdentifier:unUsercollectionViewIndentifier forIndexPath:indexPath];
            
//        cel.backgroundColor=[UIColor redColor];
        return cell;
        }
    }
    TCCollectionViewCell* cel=[collectionView dequeueReusableCellWithReuseIdentifier:collectionViewIndentifier forIndexPath:indexPath];
    cel.delegate=self;
    XPMeunModel* menuModel = self.meunList[indexPath.section];
   
    NSArray<XPDashInfoModel *>*dashInfoModelArray = menuModel.dashInfo;
    
    [cel bindModel:dashInfoModelArray[indexPath.item]];
    
    
    
//    cel.dishNameLabel.text=@"关东煮";
//    cel.dishPrice.text=[NSString stringWithFormat:@"￥%ld %ld",(long)indexPath.section,(long)indexPath.item];
    

    return cel;
}
-(UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    TCCollectionReusableView* headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:collectionViewHead forIndexPath:indexPath];
    
    headView.backgroundColor=RGBA(241, 241, 241, 1);
//    headView.headNameLabel.text=[NSString stringWithFormat:@"%d  %d",indexPath.section,indexPath.item];
    //        headView.frame=CGRectMake(0, 0, 100, 50);
    [[RACObserve(self, tastStoreModel.meunList)ignore:nil]subscribeNext:^(NSArray* meunList) {
         XPMeunModel* meunModel = meunList[indexPath.section];
        headView.headNameLabel.text =[NSString stringWithFormat:@"%@(%ld)",meunModel.dashClassName,meunModel.dashInfo.count];
        
    }];
    
//    RAC(self.imageView, image) = [[RACObserve(self, model.dashImg) flattenMap:^RACStream *(id value) {
//        return value ? [value rac_remote_image] : [RACSignal return :nil];
//    }] deliverOn:[RACScheduler mainThreadScheduler]];
    return headView;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    XPMeunModel* meunModel=self.tastStoreModel.meunList[indexPath.section];
    if(meunModel.dashInfo.count % 2 != 0 && indexPath.item == meunModel.dashInfo.count){
        return;
    }
    
    XPDashInfoModel* dashInfoModel=meunModel.dashInfo[indexPath.item];
    
    DishDetailViewController *dishViewContrller = [[DishDetailViewController alloc]init];
    dishViewContrller.dishModel=dashInfoModel;
    [self presentViewController:dishViewContrller animated:YES completion:nil];

}

//section头高度
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(0, 20);
}
#pragma mark TCCollectionViewCellDelegate
-(void)collectionViewCell:(TCCollectionViewCell *)collectionViewCell addOrderWithDashModel:(XPDashInfoModel *)dashModel{
    self.orderingView.hidden=NO;
    if(dashModel.typeDish == 0){
        meatDishCount++;
    }else if(dashModel.typeDish == 1){
        vegetableDishCount++;
    }else if(dashModel.typeDish == 2){
        soupCount++;
    }
    
    NSString* meatStr=@"";
    NSString* vegetableStr=@"";
    NSString* soupStr=@"";
    if(meatDishCount!=0){
        meatStr=[NSString stringWithFormat:@"%ld荤",meatDishCount];
    }
    if(vegetableDishCount!=0){
        vegetableStr=[NSString stringWithFormat:@"%ld素",vegetableDishCount];
    }
    if(soupCount!=0){
        soupStr=[NSString stringWithFormat:@"%ld汤",soupCount];
    }
    allDishStr=[NSString stringWithFormat:@"%@%@%@+其他",meatStr,vegetableStr,soupStr];
    self.orderingView.allDishLabel.text=allDishStr;
    NSString* price = [dashModel.cutPrize isEqualToString:@""]?dashModel.oldPrize:dashModel.cutPrize;
    CGFloat priceFloat=[price floatValue];
    consumPrice = consumPrice  + priceFloat;
    
    self.orderingView.consumpLabel.text=[NSString stringWithFormat:@"￥%.1lf",consumPrice];
    
    //添加进数组中
    Boolean isalreadyChange = NO;
    for(int i=0 ; i<self.tastOrderingModelArray.count;i++){
        XPTastOrderingModel* orderModel = self.tastOrderingModelArray[i];
        XPDashInfoModel* dashInfoModel=orderModel.dashInfoModel;
        if([dashInfoModel isEqual:dashModel]){
            orderModel.count++;
            isalreadyChange=YES;
            break;
        }
    }
    if(isalreadyChange == NO){
        XPTastOrderingModel* tastOrderingModel = [[XPTastOrderingModel alloc]init];
        tastOrderingModel.count=1;
        tastOrderingModel.dashInfoModel=dashModel;
        [self.tastOrderingModelArray addObject:tastOrderingModel];
    }
}


- (void)initBarManager {
    [MXNavigationBarManager managerWithController:self];
    [MXNavigationBarManager setBarColor:[UIColor yellowColor]];
    [MXNavigationBarManager setTintColor:[UIColor purpleColor]];
//    [MXNavigationBarManager setStatusBarStyle:UIStatusBarStyleDefault];
//    [MXNavigationBarManager setZeroAlphaOffset:0];
//    [MXNavigationBarManager setFullAlphaOffset:FullAlphaHeight];
//    [MXNavigationBarManager setFullAlphaTintColor:[UIColor blackColor]];
//    [MXNavigationBarManager setFullAlphaBarStyle:UIStatusBarStyleLightContent];
}


#pragma mark  scrollView delegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    isLeftController = NO;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    if(scrollView == self.collectionView){
        //navigationBar渐变
        [MXNavigationBarManager changeAlphaWithCurrentOffset:scrollView.contentOffset.y];
        self.whiteView.alpha=scrollView.contentOffset.y/FullAlphaHeight;
        if(self.tastStoreModel){
        //视图上下移动
        if( scrollView.contentOffset.y <= FullAlphaHeight){
            
            self.backView.transform=CGAffineTransformMakeTranslation(0, -scrollView.contentOffset.y);
        }else{
            //这种情况是当滚动过快导致都没监听到64就过去了
            if( self.backView.transform.ty > -FullAlphaHeight){
                [UIView animateWithDuration:0.1 animations:^{
                    self.backView.transform=CGAffineTransformMakeTranslation(0, -FullAlphaHeight);
                }];
            }
        }
        if(isLeftController == YES){
            
        }else{
            NSInteger index = 0;
            for(int i=0; i<self.heightMutableArray.count;i++){
                if(scrollView.contentOffset.y >= [self.heightMutableArray[i] floatValue]){
                    index =i+1;
                }else{
                    break;
                }
            }
//            NSInteger index =scrollView.contentOffset.y/(itemSize.height*2+CollectionViewCellSpace*3+CollectionViewHeaderHeight);
            [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] animated:YES scrollPosition:UITableViewScrollPositionTop];
        }
        NSLog(@"%lf   %lf",scrollView.contentOffset.y,itemSize.height*2+CollectionViewCellSpace*3+CollectionViewHeaderHeight);
    }
    }
    
}

#pragma mark - 懒加载
-(XPTasteStoreViewModel*)tasteStoreViewModel{
    if(_tasteStoreViewModel == nil){
        _tasteStoreViewModel=[[XPTasteStoreViewModel alloc]init];
    }
    return _tasteStoreViewModel;
}
-(NSMutableArray*)tastOrderingModelArray{
    if(!_tastOrderingModelArray){
        _tastOrderingModelArray=[NSMutableArray array];
    }
    return _tastOrderingModelArray;
}

//- (XPViewPager *)viewPager
//{
//    if(_viewPager == nil) {
//        UIViewController *get = [[XPTastDetailFirstViewController alloc]init];
////        self.get=get;
//        UIViewController *receive = [[XPTastDetailFirstViewController alloc]init];
//        UIViewController *use = [[XPTastDetailFirstViewController alloc]init];
//        
//        _viewPager = [[XPViewPager alloc] initWithFrame:ccr(0, 0, SCREEN_W, SCREEN_H-HeaderViewHeight+FullAlphaHeight) titles:@[@"待领取", @"待收货", @"待使用"] icons:nil selectedIcons:nil views:@[get, receive, use]];
//        _viewPager.showVLine = NO;
//        _viewPager.tabTitleColor = [UIColor blackColor];
//        _viewPager.tabSelectedTitleColor = [UIColor colorWithRed:0.627 green:0.176 blue:0.169 alpha:1.000];
//        _viewPager.tabSelectedArrowBgColor = [UIColor colorWithRed:0.784 green:0.259 blue:0.251 alpha:1.000];
//        _viewPager.tabArrowBgColor = [UIColor colorWithWhite:0.929 alpha:1.000];
//        
//    }
//    return _viewPager;
//}
@end
