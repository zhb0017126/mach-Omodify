//
//  TestAnotation.m
//  Mach-Odemo
//
//  Created by 赵泓博 on 2020/8/20.
//  Copyright © 2020 zhaohongbo. All rights reserved.
//

#import "TestAnotation.h"
#include <mach-o/getsect.h>
#include <mach-o/loader.h>
#include <mach-o/dyld.h>
#include <dlfcn.h>
#import <objc/runtime.h>
#import <objc/message.h>
#include <mach-o/ldsyms.h>







NSArray<NSString *>* readeDataInfomation(char *sectionName,const struct mach_header *mhp);


static void dyld_callback(const struct mach_header *mhp, intptr_t vmaddr_slide)
{
    /**多次获取，只有在指定的Section 为0*/
    NSArray *mods = readeDataInfomation(customSectionName, mhp);
    for (NSString *modName in mods) {
        Class cls;
        if (modName) {
            cls = NSClassFromString(modName);
            
            if (cls) {
                [[TestAnotation shareInstance].modelArray addObject:modName];
               
            }
        }
    }
    
    //register services
    NSArray<NSString *> *services = readeDataInfomation(custommodelserviceName,mhp);
    for (NSString *map in services) {
        NSData *jsonData =  [map dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        id json = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
        if (!error) {
            if ([json isKindOfClass:[NSDictionary class]] && [json allKeys].count) {
                
                NSString *protocol = [json allKeys][0];
                NSString *clsName  = [json allValues][0];
                
                if (protocol && clsName) {
                    [[TestAnotation shareInstance].modelServiceArray addObject:@{@"clsName":clsName,@"protocal":protocol}];
                }
                
            }
        }
    }
    
}
//constructor参数让系统执行main()函数之前调用函数(被__attribute__((constructor))修饰的函数).同理, destructor让系统在main()函数退出或者调用了exit()之后,调用我们的函数
__attribute__((constructor))
void initProphet() {
    _dyld_register_func_for_add_image(dyld_callback);
}

NSArray<NSString *>* readeDataInfomation(char *sectionName,const struct mach_header *mhp)
{
    NSMutableArray *configs = [NSMutableArray array];
    unsigned long size = 0;
#ifndef __LP64__
    uintptr_t *memory = (uintptr_t*)getsectiondata(mhp, SEG_DATA, sectionName, &size);
#else
    const struct mach_header_64 *mhp64 = (const struct mach_header_64 *)mhp;
    uintptr_t *memory = (uintptr_t*)getsectiondata(mhp64, SEG_DATA, sectionName, &size);
#endif
    
    unsigned long counter = size/sizeof(void*);
    for(int idx = 0; idx < counter; ++idx){
        char *string = (char*)memory[idx];
        NSString *str = [NSString stringWithUTF8String:string];
        if(!str)continue;
        
        NSLog(@"config = %@", str);
        if(str) [configs addObject:str];
    }
    
    return configs;

    
}

@implementation TestAnotation
+(instancetype)shareInstance;
{
    
    static TestAnotation *sharedSingleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedSingleton = [TestAnotation new];
        /***/
        sharedSingleton.modelArray = [NSMutableArray array];
        /***/
        sharedSingleton.modelServiceArray= [NSMutableArray array];;
    });
    return sharedSingleton;
}
@end
