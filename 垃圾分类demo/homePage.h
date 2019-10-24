//
//  homePage.h
//  垃圾分类demo
//
//  Created by 董渊 on 2019/7/6.
//  Copyright © 2019 董渊. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface homePage : UIViewController<
    UISearchBarDelegate,
    UISearchResultsUpdating
>
{
    NSMutableArray * arrayW;
    NSArray * array;
}
@property(nonatomic,strong) UIButton *photoRec;
@property(nonatomic,strong) UISearchController *searchC;
@property(nonatomic,strong) UISearchBar * searchB;
@property(nonatomic,strong) UITableView * tableView;
@property(nonatomic,strong) NSMutableArray * arrayNet;
@property(nonatomic, strong) UIActivityIndicatorView * load;
@end

NS_ASSUME_NONNULL_END
