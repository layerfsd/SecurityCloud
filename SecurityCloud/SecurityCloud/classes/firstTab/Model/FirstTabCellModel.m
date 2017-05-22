//
//  FirstTabCellModel.m
//  SecurityCloud
//
//  Created by hsgene_xu on 2017/5/22.
//  Copyright © 2017年 yc. All rights reserved.
//

#import "FirstTabCellModel.h"

@implementation FirstTabCellModel
-(instancetype)initWithTitle:(NSString *)title image:(NSString *)imageName {
    if (self = [super init]) {
        self.titleStr = title;
        self.imageName = imageName;
    }
    return self;
}
@end
