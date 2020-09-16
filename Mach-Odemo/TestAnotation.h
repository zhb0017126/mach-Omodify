//
//  TestAnotation.h
//  Mach-Odemo
//
//  Created by 赵泓博 on 2020/8/20.
//  Copyright © 2020 zhaohongbo. All rights reserved.
//

#import <Foundation/Foundation.h>

#define customSectionName "CustomModes" //存储字符串，model名称section  第一个自定义section
#define custommodelserviceName "CustomServices" // 存储json串


#define CustomData(sectname) __attribute((used, section("__DATA,"#sectname" ")))




#define CustomMode(name) \
class custom; char * k##name##_mod CustomData(CustomModes) = ""#name"";
//
#define CustomModeService(servicename,impl) \
class custom; char * k##servicename##_service CustomData(CustomServices) = "{ \""#servicename"\" : \""#impl"\"}";
// data长度有限制 最长16个字符串 CustomServices 作为Data名称最高不能太长


NS_ASSUME_NONNULL_BEGIN

@interface TestAnotation : NSObject
+(instancetype)shareInstance;
/***/
@property (nonatomic,strong) NSMutableArray *modelArray;
/***/
@property (nonatomic,strong) NSMutableArray *modelServiceArray;
@end

NS_ASSUME_NONNULL_END
