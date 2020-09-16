//
//  CustomModelService01.h
//  Mach-Odemo
//
//  Created by 赵泓博 on 2020/8/20.
//  Copyright © 2020 zhaohongbo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TestAnotation.h"
#import "CustomProtocal.h"
NS_ASSUME_NONNULL_BEGIN
@CustomModeService(CustomModelService01,CustomProtocal)
@interface CustomModelService01 : NSObject<CustomProtocal>

@end

NS_ASSUME_NONNULL_END
