//
//  BSDiffFileManage.h
//  TFBSDiff
//
//  Created by 李日煌 on 16/6/20.
//  Copyright © 2016年 李日煌. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  BSDiff原理 old文件和new文件，通过bsdiff算法，产生一个二进制差异包（diff）文件
 *  BSPatch 原理 old文件和新增的patch文件，通过bspatch算法，产生生成一个new文件
 */
@interface BSDiffFileManage : NSObject

/**
 *  存储old文件内容到指定路劲，内容这里是字符串，可以自定义修改
 *
 *  @param content 文本信息
 *  @return 是否创建成功
 */
- (BOOL)creatOldFileWithContent:(NSString*)content;

/**
 *  存储new文件到指定路劲，内容是字符串，可以自定义修改
 *
 *  @param content 文本信息
 *  @return 是否创建成功
 */
- (BOOL)creatNewFileWithContent:(NSString*)content;

/**
 *  从old文件路劲中读取内容
 *
 *  @return old文件的内容
 */
- (NSString*)readOldContentFromOldFilePath;

/**
 *  从diffFile路劲下读取生成的binary文件
 *
 *  @return 二进制文件
 */
- (NSData*)readDiffBinaryContentDiffFilePath;

//删除old文件
- (BOOL)deleteOldFile;

//删除new文件
- (BOOL)deleteNewFile;

/**
 *  生成一个diff文件路劲
 */
- (NSString*)creatDiffFile;

/**
 *  old文件和new文件，差异化出一个新文件，三个文件路径在实现文件中
 *  result 为 1，diff成功
 */
- (void)diff:(void(^)(NSInteger result))callBack;

/**
 *  old文件和patch文件，合成出一个新文件，三个文件路径在实现文件中
 *  result 为 1，patch成功
 */
- (void)patch:(void(^)(NSInteger result))callBack;

@end
