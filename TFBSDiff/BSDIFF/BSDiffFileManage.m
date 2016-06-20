//
//  BSDiffFileManage.m
//  TFBSDiff
//
//  Created by 李日煌 on 16/6/20.
//  Copyright © 2016年 李日煌. All rights reserved.
//

#import "BSDiffFileManage.h"
#include "bsdiff.h"
#include "bspatch.h"

static NSString *const BSDIFF = @"BSDIFF";
static NSString *const BSPATCH = @"BSPATCH";

static NSString *const OLDFILE = @"oldFile.txt";
static NSString *const NEWFILE = @"newFile.txt";
static NSString *const DIFFFILE = @"diffFile";

@interface BSDiffFileManage ()

@property (nonatomic,strong)  NSFileManager *fileManager;

@end

@implementation BSDiffFileManage

- (instancetype)init{
    self = [super init];
    if (self) {
        self.fileManager = [NSFileManager defaultManager];
    }
    return self;
}

#pragma mark - Content handle
- (BOOL)creatOldFileWithContent:(NSString*)content{
    NSString *oldFile = [self createFile:OLDFILE dir:BSDIFF];
    return [self writeFile:oldFile content:content];
}

- (BOOL)creatNewFileWithContent:(NSString*)content{
    NSString *newFile = [self createFile:NEWFILE dir:BSDIFF];
    return [self writeFile:newFile content:content];
}

- (NSString*)creatDiffFile{
    return [self createFile:DIFFFILE dir:BSDIFF];
}

- (NSString*)readOldContentFromOldFilePath{
    NSString *oldFile = [self createFile:OLDFILE dir:BSDIFF];
    NSStringEncoding encodeing = NSUTF8StringEncoding;
    NSString *oldContent = [NSString stringWithContentsOfFile:oldFile usedEncoding:&encodeing error:NULL];
    return oldContent;
}

- (NSData*)readDiffBinaryContentDiffFilePath{
    NSString *diffFile = [self createFile:DIFFFILE dir:BSDIFF];
    NSData *diffBinary = [NSData dataWithContentsOfFile:diffFile];
    return diffBinary;
}

- (BOOL)deleteOldFile{
    NSError *error;
    BOOL success;
    NSString *path;
    path = [self createFile:OLDFILE dir:BSDIFF];
    
    if ([self.fileManager isDeletableFileAtPath:path]) {
        
        success = [self.fileManager removeItemAtPath:path error:&error];
    }
    return success;
}

- (BOOL)deleteNewFile{
    NSError *error;
    BOOL success;
    NSString *path;
    path = [self createFile:NEWFILE dir:BSDIFF];
    
    if ([self.fileManager isDeletableFileAtPath:path]) {
        
        success = [self.fileManager removeItemAtPath:path error:&error];
    }
    return success;
}

#pragma mark -BSDiff Tools
- (void)diff:(void(^)(NSInteger result))callBack{
    
    NSString *oldFile = [self createFile:OLDFILE dir:BSDIFF];
    const char *oldDiffFileChar = [oldFile UTF8String];
    
    NSString *newFile = [self createFile:NEWFILE dir:BSDIFF];
    const char *newDiffFileChar = [newFile UTF8String];
    
    NSString *diffFile = [self createFile:DIFFFILE dir:BSDIFF];
    const char *diffPatchFileChar = [diffFile UTF8String];
    
    NSInteger result = bsDiffWithThreeFile(oldDiffFileChar,newDiffFileChar,diffPatchFileChar);
    if (callBack) {
        callBack(result);
    }
}

- (void)patch:(void(^)(NSInteger result))callBack{
    NSString *oldFile = [self createFile:OLDFILE dir:BSPATCH];
    const char *oldDiffFileChar = [oldFile UTF8String];
    
    NSString *newFile = [self createFile:NEWFILE dir:BSPATCH];
    const char *newDiffFileChar = [newFile UTF8String];
    
    NSString *diffFile = [self createFile:DIFFFILE dir:BSPATCH];
    const char *diffPatchFileChar = [diffFile UTF8String];
    
    NSInteger result = bsPatchWithThreeFile(oldDiffFileChar , newDiffFileChar,diffPatchFileChar);
    if (callBack) {
        callBack(result);
    }
}

#pragma mark - File manage
//获取Library目录
-(NSString *)dirDoc{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *directory = [paths objectAtIndex:0];
    NSLog(@"app_home_doc: %@",directory);
    return directory;
}

-(NSString*)createFile:(NSString*)fileName dir:(NSString*)dir{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = paths[0];
    //在docment下添加文件夹,会被itune同步，备份和恢复
    NSString *docmentFile = [docPath stringByAppendingPathComponent:dir];
    //创建文件夹
    
    [fileManager createDirectoryAtPath:docmentFile withIntermediateDirectories:YES attributes:nil error:nil];
    
    NSString *path = [docmentFile stringByAppendingPathComponent:fileName];
    if (![fileManager fileExistsAtPath:path]) {
        
        [fileManager createFileAtPath:path contents:nil attributes:nil];
    }
    return path;
}

- (BOOL)writeFile:(NSString*)path content:(NSString*)content{
    NSError *error = nil;
    BOOL res=[content writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&error];
    if (res) {
        NSLog(@"文件写入成功");
    }else{
        NSLog(@"文件写入失败");
    }
    return res;
}

@end
