//
//  TasteShowCell.m
//  XPApp
//
//  Created by Pua on 16/5/31.
//  Copyright © 2016年 ShareMerge. All rights reserved.
//

#import "TasteShowCell.h"
#import "TasteMainModel.h"
#import "NSString+XPRemoteImage.h"
#import "UILabel+XPAttribute.h"

@interface TasteShowCell()

@property (nonatomic, strong) TasteMainModel *model;

@end

@implementation TasteShowCell



+ (instancetype)loadFromNib
{
    return [[[NSBundle mainBundle] loadNibNamed:@"TasteShowCell" owner:self options:nil] lastObject];
}
-(void)awakeFromNib
{
    RAC(self.ImageIcon, image) = [[RACObserve(self, model.storeLogo) flattenMap:^RACStream *(id value) {
        return value ? [value rac_remote_image] : [RACSignal return :nil];
    }] deliverOn:[RACScheduler mainThreadScheduler]];
    
    RAC(self.StroreName,text) = [[RACObserve(self,model.storeName)ignore:nil]map:^id(id value) {
        return [@""stringByAppendingString:value];
    }];
    RAC(self.addressLabel, text) = [[RACObserve(self, model.storeAddress) ignore:nil] map:^id(id value) {
        return [@"" stringByAppendingString:value];
    }];
    RAC(self.averageLabel, text) = [[RACObserve(self, model.avgPrice) ignore:nil] map:^id(id value) {
        self.typeLabelFirst.backgroundColor = RGBA(123, 187, 61, 1);
        self.typeLabelFirst.textColor = [UIColor whiteColor];
        self.typeLabelFirst.cornerRadius = 6;
        if (_model.storeTags.count >= 3) {
            self.typeLabelFirst.text = [NSString stringWithFormat:@"  %@  ",[self.model.storeTags[0] objectForKey:@"storeTag"]];
            self.typeLabelThired.text = [NSString stringWithFormat:@"  %@  ",[self.model.storeTags[2]objectForKey:@"storeTag"]];
            self.typeLabelThired.backgroundColor = RGBA(123, 187, 61, 1);
            self.typeLabelThired.textColor = [UIColor whiteColor];
            self.typeLabelThired.cornerRadius = 6;
            self.typeLabelSec.text = [NSString stringWithFormat:@"  %@  ",[self.model.storeTags[1]objectForKey:@"storeTag"]];
            self.typeLabelSec.backgroundColor = RGBA(123, 187, 61, 1);
            self.typeLabelSec.textColor = [UIColor whiteColor];
            self.typeLabelSec.cornerRadius = 6;
        }else if (_model.storeTags.count ==2){
            self.typeLabelFirst.text = [NSString stringWithFormat:@"  %@  ",[self.model.storeTags[0] objectForKey:@"storeTag"]];
            self.typeLabelSec.text = [NSString stringWithFormat:@"  %@  ",[self.model.storeTags[1]objectForKey:@"storeTag"]];
            self.typeLabelThired.text = @"";
            self.typeLabelSec.backgroundColor = RGBA(123, 187, 61, 1);
            self.typeLabelSec.textColor = [UIColor whiteColor];
            self.typeLabelSec.cornerRadius = 6;
        }else if(_model.storeTags.count == 1){
            self.typeLabelFirst.text = [NSString stringWithFormat:@"  %@  ",[self.model.storeTags[0] objectForKey:@"storeTag"]];
            self.typeLabelThired.text = @"";
            self.typeLabelSec.text = @"";
        }else{
            self.typeLabelFirst.text = @"";
            self.typeLabelThired.text = @"";
            self.typeLabelSec.text = @"";
        }
        return [NSString stringWithFormat:@"￥%@/位",value];
    }];
}
#pragma mark - Public Interface
- (void)bindModel:(TasteMainModel *)model
{
    NSParameterAssert([model isKindOfClass:[TasteMainModel class]]);
    self.model = model;
}


@end
