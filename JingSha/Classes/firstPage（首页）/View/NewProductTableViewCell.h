//
//  NewProductTableViewCell.h
//  
//
//  Created by bocweb on 15/11/21.
//
//

#import <UIKit/UIKit.h>

@protocol NewProductTableViewCellDelegate <NSObject>
- (void)pushToDetailVCFromCell:(NSString *)string;

@end

@interface NewProductTableViewCell : UITableViewCell
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *imageArray;

@property (nonatomic ,weak)id<NewProductTableViewCellDelegate>delegate;
@end
