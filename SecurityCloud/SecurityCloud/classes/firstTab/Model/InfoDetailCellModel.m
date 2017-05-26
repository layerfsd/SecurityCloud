//
//  InfoDetailCellModel.m
//  SecurityCloud
//
//  Created by apple on 17/5/26.
//  Copyright © 2017年 yc. All rights reserved.
//

#import "InfoDetailCellModel.h"

@implementation InfoDetailCellModel
-(instancetype)initWithTitle:(NSString *)title showValue:(id)showValue cellType:(CustomCellType)type{
    if (self = [super init]) {
        self.titleStr = title;
        self.showValue = showValue;
        self.cellType = type;
    }
    return self;
}
@end
