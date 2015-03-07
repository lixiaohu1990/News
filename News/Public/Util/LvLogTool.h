//
//  LvLogTool.h
//
//  Tool for log
//
//  Created by guangbo on 14/12/16.
//  Copyright (c) 2014年 1024. All rights reserved.
//

#ifndef CommunityDemo_LvLogTool_h
#define CommunityDemo_LvLogTool_h

// 自定义log方法
#ifdef DEBUG
#   define DLOG(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#   define DLOG(...)
#endif

// ALog always displays output regardless of the DEBUG setting
#define ALOG(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

// 自定义assert方法
#ifdef DEBUG
#define DAssert(e) assert(e)
#else
#define DAssert(e)
#endif

#endif
