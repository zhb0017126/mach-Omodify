//
//  CustomModelService01.m
//  Mach-Odemo
//
//  Created by 赵泓博 on 2020/8/20.
//  Copyright © 2020 zhaohongbo. All rights reserved.
//

#import "CustomModelService01.h"

@implementation CustomModelService01

+ (BOOL)customClassAction;
{
    NSLog(@"++++++++customClassAction:::%@",NSStringFromClass(self));
    return YES;
}

-(id)customInstaceAction;
{
    NSLog(@"---------customInstaceAction::calss:%@----:%@",NSStringFromClass([self class]),self);
    return nil;
}
@end
