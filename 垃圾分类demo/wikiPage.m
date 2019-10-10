//
//  wikiPage.m
//  垃圾分类demo
//
//  Created by 董渊 on 2019/7/6.
//  Copyright © 2019 董渊. All rights reserved.
//

#import "wikiPage.h"
#import "recy.h"
#import "unRecy.h"
#import "dry.h"
#import "wet.h"
#import "elec.h"
@interface wikiPage ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) UISearchBar * searchBar;
@property (nonatomic,strong) UINavigationController * nav;
@end

@implementation wikiPage

- (void)viewDidLoad {
    [super viewDidLoad];
    recy * view1 =[[recy alloc]init];
    _nav = [[UINavigationController alloc]initWithRootViewController:view1];
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
//    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    UITabBarItem * wikiP = [[UITabBarItem alloc]initWithTitle:@"百科" image:[UIImage imageNamed:@"wiki"] tag:101];
    self.tabBarItem = wikiP;
    self.title = @"垃圾分类";
#pragma mark searchBar的设定
    _searchBar = [[UISearchBar alloc]initWithFrame: CGRectMake(20, 50, width-40, 40)];
    _searchBar.placeholder = @"请输入你要查询的垃圾";
    [self.view addSubview:_searchBar];
#pragma mark tableView
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 100, width, 500) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    // Do any additional setup after loading the view.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * cellid = @"cell";
    UITableViewCell * cell = [_tableView dequeueReusableCellWithIdentifier:cellid];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    switch ([indexPath row]) {
        case 0:
            cell.textLabel.text = @"可回收垃圾";
            cell.textLabel.font = [UIFont systemFontOfSize:25];
            cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"c%ld",[indexPath row]]];
            cell.backgroundColor = [UIColor greenColor];
            break;
        case 1:
            cell.textLabel.text = @"有害垃圾";
             cell.textLabel.font = [UIFont systemFontOfSize:25];
            cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"c%ld",[indexPath row]]];
            cell.backgroundColor = [UIColor redColor];
            break;
        case 2:
            cell.textLabel.text = @"干垃圾";
             cell.textLabel.font = [UIFont systemFontOfSize:25];
            cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"c%ld",[indexPath row]]];
            cell.backgroundColor = [UIColor yellowColor];
            break;
        case 3:
            cell.textLabel.text = @"湿垃圾";
             cell.textLabel.font = [UIFont systemFontOfSize:25];
            cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"c%ld",[indexPath row]]];
            cell.backgroundColor = [UIColor blueColor];
            break;
            
        case 4:
            cell.textLabel.text = @"电子废弃物";
            cell.textLabel.font = [UIFont systemFontOfSize:25];
            cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"c%ld",[indexPath row]]];
            cell.backgroundColor = [UIColor orangeColor];
            break;
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"you select %ld",[indexPath row]);
    if([indexPath row] == 0)
    {
    recy * vc0 = [[recy alloc]init];
    [self.navigationController pushViewController:vc0 animated:YES];
    }
    else if([indexPath row] == 1)
    {
        unRecy * vc1 = [[unRecy alloc]init];
        [self.navigationController pushViewController:vc1 animated:YES];
    }
    else if([indexPath row] == 2)
    {
        dry * vc2 = [[dry alloc]init];
        [self.navigationController pushViewController:vc2 animated:YES];
    }
    else if([indexPath row] == 3)
    {
        wet * vc3 = [[wet alloc]init];
        [self.navigationController pushViewController:vc3 animated:YES];
    }
    else if([indexPath row] == 4)
    {
        elec * vc4 = [[elec alloc]init];
        [self.navigationController pushViewController:vc4 animated:YES];
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100.0;
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
