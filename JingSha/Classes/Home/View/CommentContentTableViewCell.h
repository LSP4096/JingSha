//
//  CommentContentTableViewCell.h
//  
//
//  Created by bocweb on 15/11/13.
//
//

#import <UIKit/UIKit.h>
#import "CommentModel.h"

@protocol CommentContentTableViewCellDelegate <NSObject>

- (void)sendCommentPid:(NSString *)pid;

@end


@interface CommentContentTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UIButton *clickZanBtn;
@property (nonatomic, strong) CommentModel *model;

@property (nonatomic, assign) id<CommentContentTableViewCellDelegate> delegate;
@end
