//
//  MyCommentTableViewCell.m
//  
//
//  Created by bocweb on 15/11/19.
//
//

#import "MyCommentTableViewCell.h"
#import "MemberEditViewController.h"
@interface MyCommentTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *CommontLabel;

@property (weak, nonatomic) IBOutlet UIImageView *avartView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;


@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UILabel *contentNewsLabel;

@end


@implementation MyCommentTableViewCell
/**
 *  点击进入详情
 */
- (void)handlePush {
    if ([self.delegate respondsToSelector:@selector(handlePushDetailWithSendUrl:)]) {
        [self.delegate handlePushDetailWithSendUrl:[NSString stringWithFormat:@"http://121.41.128.239:8096/jxw/index.php/newsinfo/%@", _newsModel.newsid]];
    }
}
/**
 *  点击头像进入编辑
 */
- (void)handleEdit {
    if (KUserImfor == nil) {
        return;
    }
    //请求数据
    NSString *netPath = @"userinfo/userinfo_post";
    NSMutableDictionary *allParameters = [NSMutableDictionary dictionary];
    [allParameters setObject:KUserImfor[@"userid"] forKey:@"userid"];
    [HttpTool postWithPath:netPath params:allParameters success:^(id responseObj) {
        if ([self.delegate respondsToSelector:@selector(handleEditWithSendDic:)]) {
            [self.delegate handleEditWithSendDic:responseObj[@"data"]];
        }
    } failure:^(NSError *error) {
        
    }];
}
- (void)setNewsModel:(XWNewsModel *)newsModel {
    _newsModel = newsModel;
    self.CommontLabel.textColor = RGBColor(43, 76, 145);
    [self.avartView sd_setImageWithURL:[NSURL URLWithString:KUserImfor[@"photo"]] placeholderImage:[UIImage imageNamed:@"网络暂忙-193-133"]];
    [self.avartView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleEdit)]];
    _avartView.layer.cornerRadius = _avartView.height / 2;
    _avartView.layer.masksToBounds = YES;
    self.timeLabel.text = newsModel.time;
    self.contentLabel.text = newsModel.title;//用户评论的内容

    [self.contentNewsLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handlePush)]];
    self.photoImageView.layer.masksToBounds = YES;
    
    if (newsModel.photo.count == 0 || newsModel.photo == nil) {
        CGRect frame = self.photoImageView.frame;
        frame.size.width = 1;
        self.photoImageView.frame = frame;
    } else {
        NSArray *phot = newsModel.photo;
        [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:phot.firstObject] placeholderImage:[UIImage imageNamed:@"网络暂忙-193-133"]];
    }
    if (newsModel.newstitle.length == 0 || newsModel.newstitle == nil || [newsModel.newstitle isEqualToString:@"<null>"]) {
        self.contentNewsLabel.text = [NSString stringWithFormat:@"原文:暂无" ];
        if (newsModel.photo.count == 0 || newsModel.photo == nil) {
            CGRect frame = _contentLabel.frame;
            frame.origin.x = 10;
            self.contentLabel.frame = CGRectMake(0, 0, kUIScreenWidth, 30);
               MyLog(@"%@, %@", NSStringFromCGRect(frame),NSStringFromCGRect(_contentLabel.frame));
        }
    } else {
        self.contentNewsLabel.text = [NSString stringWithFormat:@"原文: %@", newsModel.newstitle];
        if (newsModel.photo.count == 0 || newsModel.photo == nil) {
            CGRect frame = _contentLabel.frame;
            frame.origin.x = 10;
           self.contentLabel.frame = CGRectMake(0, 0, kUIScreenWidth, 30);
            MyLog(@"%@", NSStringFromCGRect(_contentLabel.frame));
        }
    }
    
}




- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
