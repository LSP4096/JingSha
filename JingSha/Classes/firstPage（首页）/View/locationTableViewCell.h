//
//  locationTableViewCell.h
//  JingSha
//
//  Created by 周智勇 on 15/12/14.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

//@protocol locationTableViewCellDelegate <NSObject>
//
//- (void)getLocation:(NSString *)str;
//
//@end
@interface locationTableViewCell : UITableViewCell<CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *locationCityLable;


@property (nonatomic, copy)void(^myBlock)(NSString *str);
//@property (nonatomic, weak)id<locationTableViewCellDelegate>delegate;


@end
