# mach-Omodify
修改Mach-O文件，并在mach-O文件中存储相关信息

# 1.修改Mach-O文件
参考系统修改Mach-O文件的方式，修改Mach-O文件。
当我们使用clang命令对.m文件编译后
```
clang -rewrite-objc TestAnotation.m
```
得到的.cpp文件中可以发现
```
extern "C" __declspec(dllexport) struct _class_t OBJC_CLASS_$_TestAnotation __attribute__ ((used, section ("__DATA,__objc_data"))) = {
    0, // &OBJC_METACLASS_$_TestAnotation,
    0, // &OBJC_CLASS_$_NSObject,
    0, // (void *)&_objc_empty_cache,
    0, // unused, was (void *)&_objc_empty_vtable,
    &_OBJC_CLASS_RO_$_TestAnotation,
};

```

[__attribute__](https://huenlil.pixnet.net/blog/post/26078382)

__attribute__ ((used, section ("__DATA,__objc_data"))) 写法，即修改Mach-O文件的方式

可存储的信息包括 整数、结构体、字符串、字典等。

```
#define CustomData(sectname) __attribute((used, section("__DATA,"#sectname" ")))
#define CustomMode(name) \
class custom; char * k##name##_mod CustomData(CustomModes) = ""#name"";
//
#define CustomModeService(servicename,impl) \
class custom; char * k##servicename##_service CustomData(CustomServices) = "{ \""#servicename"\" : \""#impl"\"}";
```
使用该宏即可完成对Mach-o文件的修改



# 读取Mach-O文件

1. 入口 _dyld_register_func_for_add_image

 这个方法当镜像 Image 被 load 或是 unload 的时候都会由 dyld 主动调用。当该方法被触发时，会为每个镜像触发其回调方法。之后则将其镜像与其回电函数进行绑定（但是未进行初始化）。使用 _dyld_register_func_for_add_image 注册的回调将在镜像中的 terminators 启动后被调用。
 > PS什么是镜像，镜像理解为类，或者理解为Mach-OSection
static void dyld_callback(const struct mach_header *mhp, intptr_t vmaddr_slide)




读取数据

```
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
```
