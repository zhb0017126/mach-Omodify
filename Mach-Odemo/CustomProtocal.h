//
//  CustomProtocal.h
//  Mach-Odemo
//
//  Created by 赵泓博 on 2020/8/20.
//  Copyright © 2020 zhaohongbo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CustomProtocal <NSObject>
@optional

+ (BOOL)customClassAction;

-(id)customInstaceAction;

@end

NS_ASSUME_NONNULL_END
