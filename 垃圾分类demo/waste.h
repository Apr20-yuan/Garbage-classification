//
//  waste.h
//  垃圾分类demo
//
//  Created by 董渊 on 2019/7/8.
//  Copyright © 2019 董渊. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface waste : NSObject
{
    NSString * _wName;
    NSString * _wType;
}
@property(retain,nonatomic) NSString *wName;
@property(retain,nonatomic) NSString *wType;
@end

NS_ASSUME_NONNULL_END
