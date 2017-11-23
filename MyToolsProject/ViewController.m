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

@interface ViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, TZImagePickerControllerDelegate, UITableViewDelegate, UITableViewDataSource>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"000000" alpha:1];
    self.view.backgroundColor = HexColor(@"ffffff", 0.5);
    
//    [self getAvailableDiskSize];
//    [self getTotalDiskSize];
//    [self getDictionarySize];
    
    [self initTableView];
}

- (void)initTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view  addSubview:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 9;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"测试弹幕";
            break;
        case 1:
            cell.textLabel.text = @"测试指纹解锁";
            break;
        case 2:
            cell.textLabel.text = @"测试播放器";
            break;
        case 3:
            cell.textLabel.text = @"测试测试蓝牙";
            break;
        case 4:
            cell.textLabel.text = @"测试下载";
            break;
        case 5:
            cell.textLabel.text = @"测试扫码";
            break;
        case 6:
            cell.textLabel.text = @"手机磁盘容量";
            break;
        case 7:
            cell.textLabel.text = @"磁盘可用容量";
            break;
        case 8:
            cell.textLabel.text = @"打印磁盘容量";
            break;
            
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [self testBarrageView];
    } else if (indexPath.row == 1) {
        [self testFingerPrint];
    } else if (indexPath.row == 2) {
        [self testPlayer];
    } else if (indexPath.row == 3) {
        [self testBluetooth];
    } else if (indexPath.row == 4) {
        [self testDownload];
    } else if (indexPath.row == 5) {
        [self testScanCode];
    } else if (indexPath.row == 6) {
        
        [self getTotalDiskSize];
        
        
    } else if (indexPath.row == 7) {
        
        [self getAvailableDiskSize];
        
    } else if (indexPath.row == 8) {
        [self getDictionarySize];
    }
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

- (NSString *)getTotalDiskSize {
    struct statfs buf;
    NSUInteger freeSpace = -1;
    if (statfs("/var", &buf) >= 0) {
        freeSpace = (NSUInteger)(buf.f_bsize * buf.f_blocks);
    }
    
    NSString *sizeString = [self fileSizeToString:freeSpace];
    NSLog(@"总磁盘容量>>>>>>>>%@", sizeString);
    return sizeString;
}

- (NSString *)getAvailableDiskSize {
    struct statfs buf;
    NSUInteger freeSpace = -1;
    if (statfs("/var", &buf) >= 0) {
        freeSpace = (NSUInteger)(buf.f_bsize * buf.f_bavail);
    }
    
    NSString *sizeString = [self fileSizeToString:freeSpace];
    NSLog(@"可用磁盘容量>>>>>>>>>>>%@",sizeString);
    return sizeString;
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
