//
//  CitiesTableViewCell.m
//  JingSha
//
//  Created by 周智勇 on 15/12/16.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import "CitiesTableViewCell.h"

@interface CitiesTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *selectedCityImageVIew;
@property (weak, nonatomic) IBOutlet UILabel *cityNameLabel;

@end

@implementation CitiesTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark -- 这两个是城市的
- (void)setChecked:(BOOL)checked
{
    _checked = checked;
    if (checked) {
        self.selectedCityImageVIew.hidden = NO;
        self.cityNameLabel.textColor = RGBColor(255, 132, 0);
    }else{
        self.selectedCityImageVIew.hidden = YES;
        self.cityNameLabel.textColor = [UIColor blackColor];
    }
}

- (void)setCityName:(NSString *)cityName
{
    _cityName = cityName;
    self.cityNameLabel.text = cityName;
}

#pragma mark -- 这是分类的，二合一
- (void)setModel:(TypeModel *)model{
    _model = model;
   self.cityNameLabel.text = model.title;
    if (model.isSelected) {
        self.selectedCityImageVIew.hidden = NO;
        self.cityNameLabel.textColor = RGBColor(255, 132, 0);
    }else{
        self.selectedCityImageVIew.hidden = YES;
        self.cityNameLabel.textColor = [UIColor blackColor];
    }
}


@end
