//
//  InfoImagesTransformer.m
//  SecurityCloud
//
//  Created by apple on 17/5/22.
//  Copyright © 2017年 yc. All rights reserved.
//

#import "InfoImagesTransformer.h"

@implementation InfoImagesTransformer

+ (Class)transformedValueClass
{
    return [NSArray class];
}

+ (BOOL)allowsReverseTransformation
{
    return YES;
}

- (id)transformedValue:(id)value
{
    return [NSKeyedArchiver archivedDataWithRootObject:value];
}

- (id)reverseTransformedValue:(id)value
{
    return [NSKeyedUnarchiver unarchiveObjectWithData:value];
}
@end
