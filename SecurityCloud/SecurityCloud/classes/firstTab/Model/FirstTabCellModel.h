//
//  FirstTabCellModel.h
//  SecurityCloud
//
//  Created by hsgene_xu on 2017/5/22.
//  Copyright © 2017年 yc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FirstTabCellModel : NSObject
@property (nonatomic,copy) NSString *titleStr;
@property (nonatomic,copy) NSString *imageName;


-(instancetype)initWithTitle:(NSString*)title image:(NSString*)imageName;
@end
