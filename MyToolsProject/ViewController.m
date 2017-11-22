//
//  ViewController.m
//  MyToolsProject
//
//  Created by 宋瑞航 on 16/6/30.
//  Copyright © 2016年 SRH. All rights reserved.
//

#import "ViewController.h"
#import "MyPageViewController.h"
#import "ScanQRCodeViewController.h"
#import "CollectionHeaderCollectionReusableView.h"

#import "MyBarrageView.h"

#import <TZImagePickerController.h>
#import <LocalAuthentication/LAContext.h>

#import "MyPlayerViewController.h"

#import "BluetoothViewController.h"

#import "DownloadTaskViewController.h"

#import <mach/vm_statistics.h>
#import <sys/mount.h>

@interface ViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, TZImagePickerControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"000000" alpha:1];
    self.view.backgroundColor = HexColor(@"ffffff", 0.5);
    
    [self getAvailableDiskSize];
    [self getTotalDiskSize];
    [self getDictionarySize];
}


#pragma mark - test something
- (void)testBarrageView {
    NSArray * dataArray = @[@"评论1",@"评论2",@"评论3",@"评论4",@"评论5",@"评论6",@"评论7",@"评论8",@"评论9",@"评论10",@"评论11",@"评论12",@"评论13",];
    MyBarrageView * barrage = [[MyBarrageView alloc] initWithFrame:CGRectMake(0, 100, 320, 300)];
    [self.view addSubview:barrage];
    barrage.backgroundColor = [UIColor redColor];
    [barrage setData:dataArray];
    [barrage start];
}

- (void)testCollectionView {
    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.sectionHeadersPinToVisibleBounds = YES;
    UICollectionView * collection = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:flowLayout];
    collection.delegate = self;
    collection.dataSource = self;
    [collection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Collection"];
    [self.view addSubview:collection];
    [collection registerClass:[CollectionHeaderCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CollectionHeaderCollectionReusableView"];
}


//指纹解锁
- (void)testFingerPrint {
    //需要导入头文件<LocalAuthentication/LAContext.h>
    LAContext *myContext = [[LAContext alloc] init];
    NSError *authError = nil;
    NSString * reasonString = @"指纹识别";
    if ([myContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError]) {
        [myContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:reasonString reply:^(BOOL success, NSError * _Nullable error) {
            if (success) {
                NSLog(@">>>success!");
            } else {
                
                NSLog(@">>>error!>>>%@", error.userInfo);
            }
        }];
    }
}

- (void)testPlayer {
    MyPlayerViewController *playerView = [[MyPlayerViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:playerView];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)testBluetooth {
    BluetoothViewController *bluetoothView = [[BluetoothViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:bluetoothView];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)testDownload {
    DownloadTaskViewController *downloadView = [[DownloadTaskViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:downloadView];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - collectionView Delagete DataSource flowlayoyt
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(self.view.frame.size.width, 40);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Collection" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor redColor];
    cell.layer.cornerRadius = 5.0;
    cell.layer.masksToBounds = YES;
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 200;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(20, 100);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(16, 0, 6, 0);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    CollectionHeaderCollectionReusableView * header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"CollectionHeaderCollectionReusableView" forIndexPath:indexPath];
    return header;
}

#pragma mark - TZImagePickerController delegate
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(id)asset {
    NSLog(@"select videos---%@", asset);
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    NSLog(@"select photos---");
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos {
    NSLog(@"select photos with info---%@", infos);
}

#pragma mark - touch event
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self testScanCode];
    
    
//    [self getBatteryQuantity];
//    [self getTotalMamorySize];
//    [self getTotalDiskSize];
//    [self getAvailableDiskSize];
    
//    TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:10 delegate:self];
//
//    [imagePicker setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
//
//    }];
//    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)testScanCode {
    ScanQRCodeViewController * scanCodeVC = [[ScanQRCodeViewController alloc] init];
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:scanCodeVC];
    [self presentViewController:nav animated:YES completion:nil];
}


- (void)getBatteryQuantity {
    CGFloat battery = [[UIDevice currentDevice] batteryLevel];
    NSLog(@"电池状态>>>>>>>>>>%f",battery);
}

- (void)getTotalMamorySize {
    NSInteger memorySize = [NSProcessInfo processInfo].physicalMemory;
    
    NSLog(@"内存总量>>>>>>>>>>%@",[self fileSizeToString:memorySize]);
}

- (void)getCurrentAvailableMemorySize {
    vm_statistics_data_t vmStatis;
    //    mach_msg_type_number_t infoCount = HOST_VM_INFO;
    //    kern_return_t kernReturn = host_statistics
    
}

- (void)getTotalDiskSize {
    struct statfs buf;
    NSUInteger freeSpace = -1;
    if (statfs("/var", &buf) >= 0) {
        freeSpace = (NSUInteger)(buf.f_bsize * buf.f_blocks);
    }
    
    NSString *sizeString = [self fileSizeToString:freeSpace];
    NSLog(@"总磁盘容量>>>>>>>>%@", sizeString);
}

- (void)getAvailableDiskSize {
    struct statfs buf;
    NSUInteger freeSpace = -1;
    if (statfs("/var", &buf) >= 0) {
        freeSpace = (NSUInteger)(buf.f_bsize * buf.f_bavail);
    }
    
    NSString *sizeString = [self fileSizeToString:freeSpace];
    NSLog(@"可用磁盘容量>>>>>>>>>>>%@",sizeString);
}

- (void)getDictionarySize {
    /// 总大小
    float totalsize = 0.0;
    /// 剩余大小
    float freesize = 0.0;
    /// 是否登录
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error: &error];
    if (dictionary)
    {
        NSNumber *_free = [dictionary objectForKey:NSFileSystemFreeSize];
        freesize = [_free unsignedLongLongValue]*1.0/(1024);
        
        NSNumber *_total = [dictionary objectForKey:NSFileSystemSize];
        totalsize = [_total unsignedLongLongValue]*1.0/(1024);
        
        NSLog(@"total:%f----free:%f", totalsize, freesize);
    } else
    {
        NSLog(@"Error Obtaining System Memory Info: Domain = %@, Code = %ld", [error domain], (long)[error code]);
    }
}

-(NSString *)fileSizeToString:(unsigned long long)fileSize
{
    NSInteger KB = 1024;
    NSInteger MB = KB*KB;
    NSInteger GB = MB*KB;
    
    if (fileSize < 10)
    {
        return @"0 B";
        
    }else if (fileSize < KB)
    {
        return @"< 1 KB";
        
    }else if (fileSize < MB)
    {
        return [NSString stringWithFormat:@"%.1f KB",((CGFloat)fileSize)/KB];
        
    }else if (fileSize < GB)
    {
        return [NSString stringWithFormat:@"%.1f MB",((CGFloat)fileSize)/MB];
        
    }else
    {
        return [NSString stringWithFormat:@"%.1f GB",((CGFloat)fileSize)/GB];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
