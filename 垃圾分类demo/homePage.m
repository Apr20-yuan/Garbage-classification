//
//  homePage.m
//  垃圾分类demo
//
//  Created by 董渊 on 2019/7/6.
//  Copyright © 2019 董渊. All rights reserved.
//
#define SC_With self.view.bounds.size.width
#define SC_Height self.view.bounds.size.height
#import "homePage.h"
#import "waste.h"
#import "searchAll.h"
#import "AFNetworking.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
@interface homePage ()<
UISearchBarDelegate,
UISearchResultsUpdating,
UITableViewDelegate,
UITableViewDataSource,
UINavigationControllerDelegate,
UIImagePickerControllerDelegate
>

@property (nonatomic,strong) UIImagePickerController *imagePickerController;
@end

@implementation homePage


- (void)viewDidLoad {
    [super viewDidLoad];
    UITabBarItem * homeP = [[UITabBarItem alloc]initWithTitle:@"首页" image:[UIImage imageNamed:@"home"] tag:101];
    self.tabBarItem = homeP;
#pragma mark 设置button
    _photoRec = [UIButton  buttonWithType:UIButtonTypeSystem];
    NSInteger width = [UIScreen mainScreen].bounds.size.width;
    NSInteger hegiht = [UIScreen mainScreen].bounds.size.height;
    NSInteger widthOfBtn = 200;
    _photoRec.backgroundColor = [UIColor colorWithRed:45/255.0 green:103/255.0 blue:113/255.0 alpha:1.0];
    _photoRec.frame=CGRectMake((width-widthOfBtn)/2, (hegiht-widthOfBtn)/3, widthOfBtn, widthOfBtn);
    _photoRec.layer.cornerRadius = widthOfBtn/2;
    [_photoRec setImage:[UIImage imageNamed:@"photo"] forState:UIControlStateNormal];
    [_photoRec setTitle:@"拍照识别" forState:UIControlStateNormal];
    _photoRec.titleLabel.font = [UIFont systemFontOfSize:20];
    [_photoRec setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.view.backgroundColor = [UIColor greenColor];
    CGFloat totalHeight = _photoRec.imageView.frame.size.height + _photoRec.titleLabel.frame.size.height;
    [_photoRec setImageEdgeInsets:UIEdgeInsetsMake(-(totalHeight - _photoRec.imageView.frame.size.height), 0.0, 5, -_photoRec.titleLabel.frame.size.width)];
    [_photoRec setTitleEdgeInsets:UIEdgeInsetsMake(0.0, -_photoRec.imageView.frame.size.width - 6, -(totalHeight - _photoRec.titleLabel.frame.size.height)- 10,0.0)];
    [_photoRec addTarget:self action:@selector(imageViewIsSelector) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_photoRec];
#pragma mark 设置searchBar
    _searchB = [[UISearchBar alloc]initWithFrame:CGRectMake(0,100, width, 40)];
    _searchB.backgroundColor = [UIColor redColor];//self.view.backgroundColor;
    _searchB.placeholder = @"搜索获取垃圾的分类";
    _searchB.delegate = self;
    _arrayNet = [[NSMutableArray alloc]init];
    _arrayNetImg = [[NSMutableArray alloc]init];
    [self.view addSubview:_searchB];
    [self AFNetmonitor];
    
}

#pragma mark back
-(void)creatBack{
    UITabBarItem * homeP = [[UITabBarItem alloc]initWithTitle:@"首页" image:[UIImage imageNamed:@"home"] tag:101];
    self.tabBarItem = homeP;
    UIBarButtonItem * back = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemClose target:self action:@selector(backOnclick)];
   // UIBarButtonItem * back = [[UIBarButtonItem alloc]initWithTitle:@"返回首页" style:UIBarButtonSystemItemCancel target:self action:@selector(backOnclick)];
    self.navigationItem.leftBarButtonItem = back;
}
-(void)backOnclick{
    [_photoRec setHidden:NO];
    [_tableView setHidden:YES];
    [_searchB resignFirstResponder];
    self.navigationItem.leftBarButtonItem = nil;
    [self.searchB setShowsCancelButton:NO animated:YES];
    _searchB.text = nil;
    [_tableViewImg setHidden:YES];
}
#pragma mark searchbar

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [_photoRec setHidden:YES];
    [self creatBack];
    [searchBar setShowsCancelButton:YES animated:YES]; // 动画显示取消按钮
    [_tableView setHidden:YES];
   // [self creatTableView];
    //NSLog(@"搜索结果的数量为%lu",(unsigned long)_arrayR.count);
    
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [_tableView setHidden:YES];
    [_photoRec setHidden:NO];
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
    self.navigationItem.leftBarButtonItem = nil;
    searchBar.text = nil;
    //[searchBar resignFirstResponder];
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [_tableView setHidden:YES];
    [self AFGetData];
   // [self creatTableView];
    //[_tableView reloadData];
    NSLog(@"count is %lu",(unsigned long)_arrayNet.count);
}
#pragma  mark tableview!
-(void)creatTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 150,self.view.bounds.size.width,self.view.bounds.size.height-100) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
}
-(void)creatTableViewImg{
    _tableViewImg = [[UITableView alloc]initWithFrame:CGRectMake(SC_With/7, SC_Height/5, SC_With/7*5, SC_Height/5*3)];
    _tableViewImg.dataSource = self;
    _tableViewImg.delegate = self;
    [self.view addSubview:_tableViewImg];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView == _tableView)
        return _arrayNet.count;
    else
        return _arrayNetImg.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == _tableView)
    {
    NSString * cellid = @"cell";
    UITableViewCell * cell = [_tableView dequeueReusableCellWithIdentifier:cellid];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellid];
    }
    if(self.arrayNet.count == 0)
    {
        cell.textLabel.text = @"暂无结果";
        cell.detailTextLabel.text = @"欢迎补充";
        return cell;
    }
    waste * wst = [[waste alloc]init];
    wst = [self.arrayNet objectAtIndex:[indexPath row]];
    NSLog(@"%lu----%ld",(unsigned long)_arrayNet.count,[indexPath row]);
    cell.textLabel.text = wst.wName;
    cell.detailTextLabel.text = wst.wType;
    return cell;
    }
    else
    {
        NSString * cellid = @"cell1";
        UITableViewCell * cell = [_tableViewImg dequeueReusableCellWithIdentifier:cellid];
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellid];
        }
        if(self.arrayNetImg.count == 0)
        {
            cell.textLabel.text = @"暂无结果";
            cell.detailTextLabel.text = @"欢迎补充";
            return cell;
        }
        waste * wst = [[waste alloc]init];
        wst = [self.arrayNetImg objectAtIndex:[indexPath row]];
        NSLog(@"%lu----%ld",(unsigned long)_arrayNetImg.count,[indexPath row]);
        cell.textLabel.text = wst.wName;
        cell.detailTextLabel.text = wst.wType;
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.searchB resignFirstResponder];
}
#pragma mark AFNetwork
- (void)AFGetData{
    
        NSString * urlStr = [NSString stringWithFormat:@"http://api.tianapi.com/txapi/lajifenlei/?key=3db609bd6c1e6b9b1522f9306f7d4b9a&word=%@",_searchB.text];
        urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];//参数带中文需转UTF8
        NSURL *url = [NSURL URLWithString:urlStr];
        NSLog(@"url is %@",urlStr);
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];

        [request setHTTPMethod:@"GET"]; //请求方式

        [request setTimeoutInterval:10]; //请求超时限制

        [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData]; //缓存模式

        

        NSURLSession *session = [NSURLSession sharedSession];

    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"请求错误：%@", error);
            return;
        }
        // data到NSString
        NSDictionary * dict = [[NSDictionary alloc]init];
        dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        //    NSLog(@"%@",dict);
        NSArray * list = [[NSArray alloc]init];
        //self->_arrayNet = nil;
        list = [dict objectForKey:@"newslist"];
            //NSLog(@"!!!list!!!\n%@",list);
        NSDictionary * dict2 = [[NSDictionary alloc]init];
        dict2 = [dict objectForKey:@"newslist"];
           // NSLog(@"!!!dict!!!\n%@",dict2);
        [self->_arrayNet removeAllObjects];
            for(int i = 0; i < list.count ; i++)
            {
                waste * tWaste = [[waste alloc]init];
                NSDictionary * dict1 = [[NSDictionary alloc]init];
                dict1 = list[i];
               // NSLog(@"the dict is %@",dict1);
                int type = [[dict1 objectForKey:@"type"] intValue];
                switch (type) {
                    case 0:
                    {
                        tWaste.wName = [dict1 objectForKey:@"name"];
                        tWaste.wType = @"可回收垃圾";
                        break;
                    }
                    case 1:
                    {
                        tWaste.wName = [dict1 objectForKey:@"name"];
                        tWaste.wType = @"有害垃圾";
                        break;
                    }
                    case 2:
                    {
                        tWaste.wName = [dict1 objectForKey:@"name"];
                        tWaste.wType = @"湿垃圾";
                        break;
                    }
                    case 3:
                    {
                        tWaste.wName = [dict1 objectForKey:@"name"];
                        tWaste.wType = @"干垃圾";
                        break;
                    }
                    default:
                    {   NSLog(@"错误！！");
                        break;
                    }
                }
               // NSLog(@"%@",[dict1 objectForKey:@"name"]);
                [self->_arrayNet addObject:tWaste];

                

            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self creatTableView];
            });
           
        }];
        // 执行请求任务

        [task resume];
}
- (void)AFNetmonitor{
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:
            {
                NSLog(@"无网络连接！");
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWiFi:
            {
                NSLog(@"WiFi接入!");
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWWAN:
            {
                NSLog(@"通过蜂窝网络接入！");
                break;
            }
            default:
                break;
        }
    }];
    
}



#pragma mark 加载imgagePicker

- (UIImagePickerController *)imagePickerController {
    if (_imagePickerController == nil) {
        _imagePickerController = [[UIImagePickerController alloc] init];
        _imagePickerController.delegate = self; //delegate遵循了两个代理
        _imagePickerController.allowsEditing = YES;
    }
    return _imagePickerController;
}
#pragma mark 摄像头
- (void)imageViewIsSelector {
    
    //MARK: - 06.点击图片调起弹窗并检查权限;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"使用相机拍摄" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self checkCameraPermission];//调用检查相机权限方法
    }];
    UIAlertAction *album = [UIAlertAction actionWithTitle:@"从相册中选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self checkAlbumPermission];//调起检查相册权限方法
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alert addAction:camera];
    [alert addAction:album];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Camera(检查相机权限方法)
- (void)checkCameraPermission {
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                [self takePhoto];
            }
        }];
    } else if (status == AVAuthorizationStatusDenied || status == AVAuthorizationStatusRestricted) {
        
        [self alertAlbum];//如果没有权限给出提示
    } else {
        [self takePhoto];//有权限进入调起相机方法
    }
}

- (void)takePhoto {
#pragma mark - 判断相机是否可用，如果可用调起
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:self.imagePickerController animated:YES completion:^{
            
        }];
    } else {
        NSLog(@"相机加载失败");
    }
}
#pragma mark - Album(相册流程与相机流程相同,相册是不存在硬件问题的,只要有权限就可以直接调用)
- (void)checkAlbumPermission {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (status == PHAuthorizationStatusAuthorized) {
                    [self selectAlbum];
                }
            });
        }];
    } else if (status == PHAuthorizationStatusDenied || status == PHAuthorizationStatusRestricted) {
        [self alertAlbum];
    } else {
        [self selectAlbum];
    }
}

- (void)selectAlbum {
    //判断相册是否可用
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:self.imagePickerController animated:YES completion:^{
            
            
        }];
    }
}

- (void)alertAlbum {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"请在设置中打开相册" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark - UIImagePickerControllerDelegate(最后一步,选完就把图片加上就完事了)
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];
    [self netPost:image];
    //UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
   // [self netPost:image];
    NSLog(@"保存图片成功");
}
#pragma mark POST传输base64编码后和图片
- (void)netPost:(UIImage *)image
{
    NSURL * url = [NSURL URLWithString:@"http://api.tianapi.com/txapi/imglajifenlei/"];
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url];
    request.timeoutInterval = 5.0;
    request.HTTPMethod = @"POST";
    NSData * data = UIImageJPEGRepresentation(image, 1.0f);
    NSString * str = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    NSString *page = CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)str, nil, CFSTR(":/?#[]@!$&’()*+,;="), kCFStringEncodingUTF8)); //重新编码 base64 字符串在传输过程中特殊字符（比如：+）被替换成空格了导致不能转
    NSString * bodyStr = [NSString stringWithFormat:@"key=%@&img=%@",@"3db609bd6c1e6b9b1522f9306f7d4b9a",page];
    NSLog(@"bodyString is %@",bodyStr);
    request.HTTPBody = [bodyStr dataUsingEncoding:NSUTF8StringEncoding];
    NSURLSession *session = [NSURLSession sharedSession];
    
    [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        [self->_arrayNetImg removeAllObjects];
        NSDictionary * jsonDict = [[NSDictionary alloc]init];
        jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"json is %@",jsonDict);
        NSArray * list = [[NSArray alloc]init];
        list = [jsonDict objectForKey:@"newslist"];
        for(int i = 0; i < list.count ; i++)
            {
                waste * tWaste = [[waste alloc]init];
                NSDictionary * dict1 = [[NSDictionary alloc]init];
                dict1 = list[i];
                int type = [[dict1 objectForKey:@"lajitype"] intValue];
                switch (type) {
                    case 0:
                    {
                        tWaste.wName = [dict1 objectForKey:@"name"];
                        tWaste.wType = @"可回收垃圾";
                        tWaste.trust = [[dict1 objectForKey:@"trust"]intValue];
                        break;
                    }
                    case 1:
                    {
                        tWaste.wName = [dict1 objectForKey:@"name"];
                        tWaste.wType = @"有害垃圾";
                        tWaste.trust = [[dict1 objectForKey:@"trust"]intValue];
                        break;
                    }
                    case 2:
                    {
                        tWaste.wName = [dict1 objectForKey:@"name"];
                        tWaste.wType = @"湿垃圾";
                        tWaste.trust = [[dict1 objectForKey:@"trust"]intValue];
                        break;
                    }
                    case 3:
                    {
                        tWaste.wName = [dict1 objectForKey:@"name"];
                        tWaste.wType = @"干垃圾";
                        tWaste.trust = [[dict1 objectForKey:@"trust"]intValue];
                        break;
                    }
                    case 4:
                    {
                        tWaste.wName = [dict1 objectForKey:@"name"];
                        tWaste.wType = @"未识别类型";
                        tWaste.trust = [[dict1 objectForKey:@"trust"]intValue];
                        break;
                    }
                    default:
                    {   NSLog(@"错误！！");
                        break;
                    }
                }
                [self->_arrayNetImg addObject:tWaste];
            } // 解析完成
        for(int i = 0; i<self->_arrayNetImg.count;i++)
        {
            waste * wst = [[waste alloc]init];
            wst = self->_arrayNetImg[i];
            NSLog(@"%@--%@--%d",wst.wName,wst.wType,wst.trust);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self creatBack];
            [self creatTableViewImg];
        });
        
    }]
     resume];



    
}

@end
