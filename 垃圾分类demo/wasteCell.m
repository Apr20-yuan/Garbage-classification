//
//  wasteCell.m
//  wasteCell
//
//  Created by 董渊 on 2019/10/31.
//  Copyright © 2019 董渊. All rights reserved.
//
#define SCwidth self.bounds.size.width
#define SCheight self.bounds.size.width
#import "wasteCell.h"

@implementation wasteCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        _name = [[UILabel alloc]init];
        [self.contentView addSubview:_name];
        _type = [[UILabel alloc]init];
        [self.contentView addSubview:_type];
        _img = [[UIImageView alloc]init];
        [self.contentView addSubview:_img];
        self.layer.cornerRadius = 7;
        
    }
    return self;
}
- (void)layoutSubviews{
    _name.frame = CGRectMake(10, 5, SCwidth-200, 30);
    _name.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    _name.textColor = [UIColor whiteColor];
    _type.frame = CGRectMake(SCwidth-130, 5, 150, 30);
    _type.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    _type.textColor = [UIColor whiteColor];
    _img.frame = CGRectMake(SCwidth-30, 10, 20, 20);
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
