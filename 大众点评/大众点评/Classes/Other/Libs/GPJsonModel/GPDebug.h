#ifdef DEBUG
#define GPLog(...) NSLog(__VA_ARGS__)
#else
#define GPLog(...)
#endif

// 如果不想输出提示信息就注释掉该宏
#define GP_DEBUG
