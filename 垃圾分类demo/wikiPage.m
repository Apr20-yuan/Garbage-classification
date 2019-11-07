//
//  wikiPage.m
//  垃圾分类demo
//
//  Created by 董渊 on 2019/7/6.
//  Copyright © 2019 董渊. All rights reserved.
//
#define SC_Width self.view.bounds.size.width
#define SC_Height self.view.bounds.size.height
#import "wikiPage.h"
#import "recy.h"
#import "unRecy.h"
#import "dry.h"
#import "wet.h"
#import "elec.h"
@interface wikiPage ()<
    UISearchBarDelegate,
    UISearchResultsUpdating,
    UITableViewDelegate,
    UITableViewDataSource>
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) UISearchBar * searchB;
@property (nonatomic,strong) UINavigationController * nav;
@end

@implementation wikiPage

- (void)viewDidLoad {
    [super viewDidLoad];
    recy * view1 =[[recy alloc]init];
    _nav = [[UINavigationController alloc]initWithRootViewController:view1];
    UITabBarItem * wikiP = [[UITabBarItem alloc]initWithTitle:@"百科" image:[UIImage imageNamed:@"wiki"] tag:101];
    self.tabBarItem = wikiP;
    self.title = @"垃圾分类";
//#pragma mark searchBar的设定
//    _searchB = [[UISearchBar alloc]initWithFrame:CGRectMake(0,self.navigationController.navigationBar.frame.size.height+[[UIApplication sharedApplication] statusBarFrame].size.height+5,SC_Width, 40)];
//
//    for (UIView *subview in _searchB.subviews) {
//        for(UIView* grandSonView in subview.subviews){
//            if ([grandSonView isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
//                grandSonView.alpha = 0.0f;
//            }else if([grandSonView isKindOfClass:NSClassFromString(@"UISearchBarTextField")] ){
//                NSLog(@"Keep textfiedld bkg color");
//            }else{
//                grandSonView.alpha = 0.0f;
//            }
//        }
//    }
//    _searchB.backgroundColor = [UIColor clearColor];//self.view.backgroundColor;
//    _searchB.translucent = YES;
//    _searchB.placeholder = @"搜索获取垃圾的分类";
//    _searchB.delegate = self;
//    [self.view addSubview:_searchB];
#pragma mark tableView
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(7, self.navigationController.navigationBar.frame.size.height+[[UIApplication sharedApplication] statusBarFrame].size.height+10, SC_Width-14, SC_Height) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor clearColor];
    //_tableView.layer.cornerRadius = 10;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    // Do any additional setup after loading the view.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0,SC_Width, 0.1)];
    view.backgroundColor = [UIColor clearColor];
    return view ;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0,SC_Width, 0.1)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * cellid = @"cell";
    UITableViewCell * cell = [_tableView dequeueReusableCellWithIdentifier:cellid];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    switch (indexPath.section) {
        case 0:
            cell.textLabel.text = @"可回收垃圾";
            cell.textLabel.font = [UIFont systemFontOfSize:25];
            cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"c%ld",(long)indexPath.section]];
            cell.backgroundColor = [UIColor colorWithRed:80/255.0 green:161/255.0 blue:64/255.0 alpha:1];
            break;
        case 1:
            cell.textLabel.text = @"有害垃圾";
             cell.textLabel.font = [UIFont systemFontOfSize:25];
            cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"c%ld",(long)indexPath.section]];
            cell.backgroundColor = [UIColor colorWithRed:202/255.0 green:32/255.0 blue:34/255.0 alpha:1];
            break;
        case 2:
            cell.textLabel.text = @"干垃圾";
             cell.textLabel.font = [UIFont systemFontOfSize:25];
            cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"c%ld",(long)indexPath.section]];
            cell.backgroundColor = [UIColor colorWithRed:210/255.0 green:182/255.0 blue:42/255.0 alpha:1];
            break;
        case 3:
            cell.textLabel.text = @"湿垃圾";
             cell.textLabel.font = [UIFont systemFontOfSize:25];
            cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"c%ld",(long)indexPath.section]];
            cell.backgroundColor = [UIColor colorWithRed:19/255.0 green:96/255.0 blue:168/255.0 alpha:1];
            break;
            
        case 4:
            cell.textLabel.text = @"电子废弃物";
            cell.textLabel.font = [UIFont systemFontOfSize:25];
            cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"c%ld",(long)indexPath.section]];
            cell.backgroundColor = [UIColor orangeColor];
            break;
    }
    cell.layer.cornerRadius = 7.0;
    cell.layer.masksToBounds = YES;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if(indexPath.section == 0)
    {
    recy * vc0 = [[recy alloc]init];
    [self.navigationController pushViewController:vc0 animated:YES];
    }
    else if(indexPath.section == 1)
    {
        unRecy * vc1 = [[unRecy alloc]init];
        [self.navigationController pushViewController:vc1 animated:YES];
    }
    else if(indexPath.section == 2)
    {
        dry * vc2 = [[dry alloc]init];
        [self.navigationController pushViewController:vc2 animated:YES];
    }
    else if(indexPath.section == 3)
    {
        wet * vc3 = [[wet alloc]init];
        [self.navigationController pushViewController:vc3 animated:YES];
    }
    else if(indexPath.section == 4)
    {
        elec * vc4 = [[elec alloc]init];
        [self.navigationController pushViewController:vc4 animated:YES];
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SC_Height/10;
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
