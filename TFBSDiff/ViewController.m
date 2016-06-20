//
//  ViewController.m
//  TFBSDiff
//
//  Created by 李日煌 on 16/6/20.
//  Copyright © 2016年 李日煌. All rights reserved.
//

#import "ViewController.h"
#import "BSDiffFileManage.h"

@interface ViewController ()

@property (nonatomic,strong) NSMutableArray *data;

@property (nonatomic,strong) BSDiffFileManage *fileManage;
@property (weak, nonatomic) IBOutlet UILabel *oContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *nContentLabel;//竟然不能命名newContentLabel，命名空间冲突，来鬼了。。。

- (IBAction)oldText:(id)sender;

- (IBAction)newText:(id)sender;

- (IBAction)diff:(id)sender;

- (IBAction)patch:(id)sender;

@end

@implementation ViewController

#pragma mark - lazy load
- (BSDiffFileManage*)fileManage{
    if (!_fileManage) {
        _fileManage = [[BSDiffFileManage alloc] init];
    }
    return _fileManage;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _tf_configureData];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)_tf_configureData{
    self.data = [NSMutableArray arrayWithCapacity:0];
}

//old文件是否存在
- (BOOL)isExistOldLocalFileContent{
    NSString *oldFileContent =[self.fileManage readOldContentFromOldFilePath];
    return  oldFileContent.length ? YES : NO;
}


- (NSString*)_tf_convertArrayToJson:(NSArray*)array{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:&error];
    NSString *content = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return content;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString*)_kep_filterTxt:(NSString*)toRemoveMobileString{
    toRemoveMobileString = [toRemoveMobileString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    toRemoveMobileString = [toRemoveMobileString stringByReplacingOccurrencesOfString:@"[" withString:@""];
    toRemoveMobileString = [toRemoveMobileString stringByReplacingOccurrencesOfString:@"]" withString:@""];
    toRemoveMobileString = [toRemoveMobileString stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *mobileString = [toRemoveMobileString stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    return mobileString;
}

- (IBAction)oldText:(id)sender {
    [self.data addObjectsFromArray:@[@"1",@"2",@"3",@"4",@"5",@"6"]];
    NSString *text = [self _tf_convertArrayToJson:self.data];
    text = [self _kep_filterTxt:text];
    [self.fileManage creatOldFileWithContent:text];
    self.oContentLabel.text = text;
}

- (IBAction)newText:(id)sender {

    [self.data addObjectsFromArray:@[@"7"]];
    NSString *text = [self _tf_convertArrayToJson:self.data];
    text = [self _kep_filterTxt:text];
    [self.fileManage creatNewFileWithContent:text];
    self.nContentLabel.text = text;
}

- (IBAction)diff:(id)sender {
    [self.fileManage diff:^(NSInteger result) {
        if (result) {
            NSLog(@"diff success!");
        }else{
            NSLog(@"diff failure!");
        }
    }];
}

- (IBAction)patch:(id)sender {
    //need copy BSDiff old and diff file,then patch them to new file!
    return;
    [self.fileManage patch:^(NSInteger result) {
        if (result) {
            NSLog(@"patch success!");
        }else{
            NSLog(@"patch failure!");
        }
    }];
}

@end
