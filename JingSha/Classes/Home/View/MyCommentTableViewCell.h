//
//  MyCommentTableViewCell.h
//  
//
//  Created by bocweb on 15/11/19.
//
//

#import <UIKit/UIKit.h>
#import "XWNewsModel.h"

@protocol MyCommentTableViewCellDelegate <NSObject>

- (void)handlePushDetailWithSendUrl:(NSString *)str;
- (void)handleEditWithSendDic:(NSDictionary *)dic;
@end


@interface MyCommentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (nonatomic, strong) XWNewsModel *newsModel;

@property (nonatomic, assign) id<MyCommentTableViewCellDelegate> delegate;
@end
