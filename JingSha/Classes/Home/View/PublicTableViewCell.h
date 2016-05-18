//
//  PublicTableViewCell.h
//  
//
//  Created by bocweb on 15/11/24.
//
//

#import <UIKit/UIKit.h>

@interface PublicTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@end
