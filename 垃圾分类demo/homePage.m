//
//  homePage.m
//  垃圾分类demo
//
//  Created by 董渊 on 2019/7/6.
//  Copyright © 2019 董渊. All rights reserved.
//

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
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSUInteger)scope;
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
    arrayW = [[NSMutableArray alloc]init];
    _arrayR = [[NSMutableArray alloc]init];
    _arrayNet = [[NSMutableArray alloc]init];
    [self parasData];
    
    [self.view addSubview:_searchB];
    [self AFNetmonitor];
    
}

#pragma mark back
-(void)creatBack{
    UITabBarItem * homeP = [[UITabBarItem alloc]initWithTitle:@"首页" image:[UIImage imageNamed:@"home"] tag:101];
    self.tabBarItem = homeP;
    UIBarButtonItem * back = [[UIBarButtonItem alloc]initWithTitle:@"返回首页" style:UIBarButtonItemStyleDone target:self action:@selector(backOnclick)];
    self.navigationItem.leftBarButtonItem = back;
}
-(void)backOnclick{
    [_photoRec setHidden:NO];
    [_tableView setHidden:YES];
    [_searchB resignFirstResponder];
    self.navigationItem.leftBarButtonItem = nil;
    [self.searchB setShowsCancelButton:NO animated:YES];
    _searchB.text = nil;
}
#pragma mark paras
- (void) parasData{
    NSString * path = [[NSBundle mainBundle]pathForResource:@"answer_data" ofType:@"json"];
    NSData * data = [NSData dataWithContentsOfFile:path];
    array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    for(int i=0;i<array.count;i++)
    {
        NSDictionary * dic = [array objectAtIndex:i];
        NSArray * a1 = [dic allKeys];
        NSArray * a2 = [dic allValues];
        NSString * s1 = [a1 objectAtIndex:0];
        
        NSString * s2 = [a2 objectAtIndex:0];
        waste * wa = [[waste alloc]init];
        wa.wName = s1;
        wa.wType = s2;
        [arrayW addObject:wa];
    }
    for(int i = 0; i< arrayW.count ;i++)
    {
        for(int j = i+1 ;j<arrayW.count; j++ )
        {
            waste * twst = [[waste alloc]init];
            waste * wst = [[waste alloc]init];
            twst = [arrayW objectAtIndex:i];
            wst = [arrayW objectAtIndex:j];
            if([twst.wName isEqualToString:wst.wName])
            {
                [arrayW removeObject:wst];
            }
        }
    }
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [_photoRec setHidden:YES];
    [self parasData];
    [self creatBack];
    [searchBar setShowsCancelButton:YES animated:YES]; // 动画显示取消按钮
    [self filterContentForSearchText:@""];
    [self creatTableView];
    [self filterContentForSearchText:@""];
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
    [self AFGetData];
  //  [self filterContentForSearchText:[searchBar text]];
    NSLog(@"count is %lu",(unsigned long)_arrayNet.count);
}
#pragma  mark tableview!
-(void)creatTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 150,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height-100) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   // NSLog(@"sum is %d",_arrayR.count+_arrayNet.count);
    return _arrayR.count+_arrayNet.count+1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * cellid = @"cell";
    UITableViewCell * cell = [_tableView dequeueReusableCellWithIdentifier:cellid];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellid];
    }
    if(_arrayNet.count+_arrayR.count == 0)
    {
        cell.textLabel.text = @"暂无结果";
        cell.detailTextLabel.text = @"欢迎补充";
        return cell;
    }
    waste * wst = [[waste alloc]init];
    if([indexPath row] < _arrayR.count)
        wst = [_arrayR objectAtIndex:[indexPath row]];
    else if([indexPath row] >= _arrayR.count&&[indexPath row] < _arrayNet.count+_arrayR.count)
        wst = [_arrayNet objectAtIndex:[indexPath row]-_arrayR.count];
    else
        wst = nil;
    cell.textLabel.text = wst.wName;
    cell.detailTextLabel.text = wst.wType;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.searchB resignFirstResponder];
}
#pragma mark filter
-(void)filterContentForSearchText:(NSString *)searchText{
    if([searchText length] == 0)
    {
        _arrayR = [NSMutableArray arrayWithArray:arrayW];
        return;
    }
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"SELF.wName contains[c]%@",searchText];
    NSArray * tempArray = [arrayW filteredArrayUsingPredicate:predicate];
    _arrayR = [NSMutableArray arrayWithArray:tempArray];
    [self.tableView reloadData];
}

#pragma mark AFNetwork
- (void)AFGetData{
    NSLog(@"start get!");
    AFHTTPSessionManager * session = [AFHTTPSessionManager manager];
    NSString *url = [[NSString alloc]init];
    url = @"https://laji.lr3800.com/api.php?name=";
    NSString * str = _searchB.text;
    NSLog(@"the searchB.text is %@",str);
    url = [url stringByAppendingString:str];
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];//重新编码url
    NSLog(@"%@",url);
    [session.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"text/html", nil]]; //设置text/html
    [session GET:url parameters:nil headers:nil progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        UIActivityIndicatorView * load = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [load setFrame:CGRectMake(100, 100, 200, 200)];
       // [load setHidden:NO];
        [self.view bringSubviewToFront:load];
        [self->_arrayNet removeAllObjects];
      //  NSLog(@"get it!");
      //  NSLog(@"%@",responseObject);
        NSDictionary * dict = [[NSDictionary alloc]init];
        dict = responseObject;
    //    NSLog(@"%@",dict);
        NSArray * list = [[NSArray alloc]init];
    //self->_arrayNet = nil;
        list = [dict objectForKey:@"newslist"];
        //NSLog(@"!!!list!!!\n%@",list);
        NSDictionary * dict2 = [[NSDictionary alloc]init];
        dict2 = [dict objectForKey:@"newslist"];
       // NSLog(@"!!!dict!!!\n%@",dict2);
        
        for(int i = 0; i < list.count ; i++)
        {
            waste * tWaste = [[waste alloc]init];
            NSDictionary * dict1 = [[NSDictionary alloc]init];
            dict1 = list[i];
            NSLog(@"the dict is %@",dict1);
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
            NSLog(@"%@",[dict1 objectForKey:@"name"]);
            [self->_arrayNet addObject:tWaste];
        }
//        for(int i= 0;i< _arrayNet.count ;i++)
//        {
//            waste * waste1 = [[waste alloc]init];
//            waste1 = [_arrayNet objectAtIndex:i];
//            NSLog(@"%@...%@",waste1.wType,waste1.wName);
//        }
        NSLog(@"%@",self->_arrayNet);
        [self filterContentForSearchText:[self.searchB text]];
        [load setHidden:YES];
       
    }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
    {
        NSLog(@"错误！！！！");
        NSLog(@"%@",error);
    }];
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
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    //传输图片给识图api  未完成。
    NSLog(@"保存图片成功");
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
