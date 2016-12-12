//
//  ViewController.m
//  Test断点下载
//
//  Created by 泰吉通 on 16/12/12.
//  Copyright © 2016年 泰吉通. All rights reserved.
//

#import "ViewController.h"
#import "ResumeManager.h"

@interface ViewController ()

@property (nonatomic, strong) ResumeManager *manager;

@property (nonatomic, weak) IBOutlet UIImageView *imageWithBlock;
@property (nonatomic, copy) NSString *targetPath;

@property (nonatomic, weak) IBOutlet UIProgressView *progressView;
@property (nonatomic, weak) IBOutlet UILabel *lab;
@property (nonatomic, weak) IBOutlet UIButton *deleteBtn;


/**
 *  简单请求
 *
 *  @param sender 继续下载
 */
-(IBAction)simpleRequest:(id)sender;

/**
 *  取消请求
 *
 *  @param sender 取消
 */
-(IBAction)cancelRequest:(id)sender;

/**
 *  删除文件
 *
 *  @param sender 删除
 */
-(IBAction)deleteImage:(id)sender;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

/**
 *  简单请求
 *  @param sender 继续
 */
-(IBAction)simpleRequest:(id)sender{
    
    //1.准备
    if (self.manager) {
        
        [self cancelRequest:nil];
    }
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory=[paths objectAtIndex:0];//Documents目录
    self.targetPath = [documentsDirectory stringByAppendingPathComponent:@"mey.png"];
    NSLog(@"%@",self.targetPath);
    
    NSURL *url = [NSURL URLWithString:@"https://s3-ap-southeast-1.amazonaws.com/taijietong/1.png"];
    
    self.manager = [ResumeManager resumeManagerWithURL:url targetPath:self.targetPath success:^{
        
        NSLog(@"success");
        self.imageWithBlock.image = [UIImage imageWithContentsOfFile:self.targetPath];
        self.deleteBtn.hidden = NO;
        
    } failure:^(NSError *error) {
        
        NSLog(@"failure");
        
    } progress:^(long long totalReceivedContentLength, long long totalContentLength) {
        
        float percent = 1.0 * totalReceivedContentLength / totalContentLength;
        NSString *strPersent = [[NSString alloc]initWithFormat:@"%.f", percent *100];
        self.progressView.progress = percent;
        self.lab.text = [NSString stringWithFormat:@"已下载%@%%", strPersent];
    }];
    
    //2.启动
    [self.manager start];
    
}

/**
 *  取消请求
 *  @param sender 取消
 */
-(IBAction)cancelRequest:(id)sender{
    
    [self.manager cancel];
    self.manager = nil;
}

/**
 *  删除文件
 *
 *  @param sender 删除
 */
-(IBAction)deleteImage:(id)sender{
    
    NSFileManager *manager = [NSFileManager defaultManager];
    NSError *error = nil;
    [manager removeItemAtPath:self.targetPath error:&error];
    
    if (error == nil) {
        
        self.imageWithBlock.image = [UIImage imageWithContentsOfFile:self.targetPath];
        self.progressView.progress = 0;
        self.lab.text = nil;
        
        self.deleteBtn.hidden = YES;
    }
    
}


@end
