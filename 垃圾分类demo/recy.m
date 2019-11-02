//
//  recy.m
//  垃圾分类demo
//
//  Created by 董渊 on 2019/7/8.
//  Copyright © 2019 董渊. All rights reserved.
//

#import "recy.h"
#import "waste.h"
@interface recy ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation recy

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];
    arrayW = [[NSMutableArray alloc]init];
    [self parasData];
    tableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];

}
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
        if([s2 isEqualToString:@"可回收物"])
            [arrayW addObject:wa];
    }
    for(int i = 0; i< arrayW.count ;i++)
    {
        for(int j = i+1 ;j<arrayW.count ; j++ )
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
    [tableView reloadData];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrayW.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * cellid = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellid];
    }
    waste * wst = [arrayW objectAtIndex:[indexPath row]];
    cell.textLabel.text = wst.wName;
    cell.detailTextLabel.text = wst.wType;
    return cell;
   
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
