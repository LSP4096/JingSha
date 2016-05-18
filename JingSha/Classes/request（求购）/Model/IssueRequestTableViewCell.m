
//  IssueRequestTableViewCell.m
//  JingSha
//
//  Created by 周智勇 on 15/12/30.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import "IssueRequestTableViewCell.h"

@interface IssueRequestTableViewCell ()

@property (nonatomic, strong)UIView * backView;
@property (nonatomic, strong)UILabel * titleLable;


@property (nonatomic, strong)UIImageView * rightImageView;


@end

@implementation IssueRequestTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = RGBColor(231, 231, 231);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.backView];
        
        [self.contentView addSubview:self.rightImageView];
        [self.backView addSubview:self.titleLable];
        [self.backView addSubview:self.contentField];
        [self.backView addSubview:self.rightButton];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChanged) name:UITextFieldTextDidChangeNotification object:nil];
    }
    return self;
}

- (UIView *)backView{
    if (_backView == nil) {
        self.backView = [[UIView alloc] initWithFrame:CGRectMake(20, 3, kUIScreenWidth - 40, 38)];
        self.backView.backgroundColor = RGBColor(255, 255, 255);
        self.backView.layer.masksToBounds = YES;
        self.backView.layer.cornerRadius = 5;
        [self.backView addSubview:self.titleLable];
        [self.backView addSubview:self.contentField];
        [self.backView addSubview:self.rightButton];
    }
    return _backView;
}

- (UIImageView *)rightImageView{
    if (_rightImageView == nil) {
        self.rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kUIScreenWidth - 15, 18, 8, 8)];
        _rightImageView.image = [UIImage imageNamed:@"Request_need"];
    }
    return _rightImageView;
}

- (UILabel *)titleLable{
    if (_titleLable == nil) {
        self.titleLable =[[UILabel alloc] initWithFrame:CGRectMake(5, 12, 70, 20)];
        self.titleLable.font = [UIFont systemFontOfSize:13];
        self.titleLable.textColor = RGBColor(129, 129, 129);
//        _titleLable.text = @"请输入原料:";
    }
    return _titleLable;
}
- (UITextField *)contentField{
    if (_contentField == nil) {
        self.contentField = [[UITextField alloc] initWithFrame:CGRectMake(75, 12, kUIScreenWidth - 140, 20)];
//        _contentField.backgroundColor = [UIColor grayColor];
        _contentField.font = [UIFont systemFontOfSize:12];
        _contentField.textColor = RGBColor(108, 108, 108);
        
    }
    return _contentField;
}


- (UIButton *)rightButton{
    if (_rightButton == nil) {
        self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.rightButton.frame = CGRectMake(CGRectGetMaxX(_backView.frame) - 45, 12, 20, 20);
        self.rightButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [self.rightButton setTitleColor:RGBColor(187, 186, 194) forState:UIControlStateNormal];
    }
    return _rightButton;
}

- (void)setModel:(IssueModel *)model{
    _model = model;
    self.titleLable.text = _model.leftTitle;
    if (![_model.contentStr isKindOfClass:[NSNull class]] && _model.contentStr.length > 0) {
        
        self.contentField.text = _model.contentStr;
    }else{
        self.contentField.text = nil;
    }
    
    if ([_model.leftTitle isEqualToString:@"产品大类:"]) {
        self.contentField.placeholder = @"请选择产品大类";
        self.contentField.userInteractionEnabled = NO;
        [self.rightButton setImage:[UIImage imageNamed:@"Request_down"] forState:UIControlStateNormal];
        _model.isDown = YES;
    }else if ([_model.leftTitle isEqualToString:@"支数:"]){
        self.contentField.placeholder = @"请选择支数";
        self.contentField.userInteractionEnabled = NO;
        [self.rightButton setImage:[UIImage imageNamed:@"Request_down"] forState:UIControlStateNormal];
        _model.isDown = YES;
        self.contentField.userInteractionEnabled = NO;
    }
//    else if ([_model.leftTitle isEqualToString:@"所属类别:"]){
//        self.contentField.placeholder = @"请选择类别";
//        self.contentField.userInteractionEnabled = NO;
//        self.rightImageView.hidden = NO;
//        [self.rightButton setImage:[UIImage imageNamed:@"Request_down"] forState:UIControlStateNormal];
//        _model.isPush = YES;
//        
//    }
    else if ([_model.leftTitle isEqualToString:@"乌斯特质量:"]){
        self.contentField.placeholder = @"请选择乌斯特质量";
        self.rightImageView.hidden = YES;
        self.contentField.userInteractionEnabled = NO;
        [self.rightButton setImage:[UIImage imageNamed:@"Request_down"] forState:UIControlStateNormal];
        _model.isDown = YES;
    }else if ([_model.leftTitle isEqualToString:@"有效期:"]){
        self.contentField.placeholder = @"请选择有效期";
        self.contentField.userInteractionEnabled = NO;
        [self.rightButton setImage:[UIImage imageNamed:@"Request_down"] forState:UIControlStateNormal];
        _model.isDown = YES;
    }else if ([_model.leftTitle isEqualToString:@"交货期:"]){
        self.rightImageView.hidden = YES;
        self.contentField.placeholder = @"请填写交货日期";
        [self.rightButton setTitle:@"天" forState:UIControlStateNormal];
    }else if ([_model.leftTitle isEqualToString:@"产品名称:"]){
        self.contentField.placeholder = @"请输入产品名称";
    }else if ([_model.leftTitle isEqualToString:@"原料成分:"]){
        self.contentField.placeholder = @"请选择原料成分";
        self.contentField.userInteractionEnabled = NO;
        self.rightImageView.hidden = YES;
        [self.rightButton setImage:[UIImage imageNamed:@"Request_ReWrite"] forState:UIControlStateNormal];
        _model.isPromote = YES;
    }else if ([_model.leftTitle isEqualToString:@"数量:"]){
        self.contentField.placeholder = @"请输入数量";
        self.rightImageView.hidden = YES;
        [self.rightButton setTitle:@"吨" forState:UIControlStateNormal];
        [self.rightButton addTarget:self action:@selector(selectUnit:) forControlEvents:UIControlEventTouchUpInside];//选择单位
        [self.contentField setKeyboardType:UIKeyboardTypeNumberPad];
        
        
    }else if ([_model.leftTitle isEqualToString:@"意向价格:"] || [_model.leftTitle isEqualToString:@"价格:"]){
        self.rightImageView.hidden = YES;
        [self.rightButton setTitle:@"元/吨" forState:UIControlStateNormal];
        [self.rightButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
        if (self.isRequest) {
            self.contentField.placeholder = @"请输入价格";
        }else{
            self.contentField.placeholder = @"请输入价格(可填写为面议)";
        }
    }else if ([_model.leftTitle isEqualToString:@"产品分类:"]){
        self.contentField.placeholder = @"请选择产品分类";
        self.contentField.userInteractionEnabled = NO;
        [self.rightButton setImage:[UIImage imageNamed:@"Request_down"] forState:UIControlStateNormal];
        self.rightImageView.hidden = NO;
//        _model.isDown = YES;
        
        
    }else if ([_model.leftTitle isEqualToString:@"产品规格:"]){
         [self.rightButton setTitle:nil forState:UIControlStateNormal];
        [self.rightButton setImage:nil forState:UIControlStateNormal];
        self.contentField.placeholder = @"请输入规格";
        self.rightImageView.hidden = NO;
        self.userInteractionEnabled = YES;
        [self.contentField setKeyboardType:UIKeyboardTypeDefault];
        _model.isPush = NO;
        _model.isPush = NO;
    }else if([_model.leftTitle isEqualToString:@"企业评价:"]){
        self.userInteractionEnabled = NO;
        self.backView.backgroundColor = RGBColor(249, 249, 249);
        self.rightImageView.hidden = YES;
    }else if ([_model.leftTitle isEqualToString:@"企业分类:"]){
        [self.rightButton setImage:[UIImage imageNamed:@"Request_down"] forState:UIControlStateNormal];
        self.contentField.userInteractionEnabled = NO;
    }else if ([_model.leftTitle isEqualToString:@"主营产品:"] || [_model.leftTitle isEqualToString:@"主要采购纱线:"]){
        [self.rightButton setImage:[UIImage imageNamed:@"Request_ReWrite"] forState:UIControlStateNormal];
        self.contentField.userInteractionEnabled = NO;
        if ([_model.leftTitle isEqualToString:@"主要采购纱线:"]) {
            self.titleLable.font = [UIFont systemFontOfSize:11];
        }else{
            self.titleLable.font = [UIFont systemFontOfSize:13];
        }
    }else if ([_model.leftTitle isEqualToString:@"年采购量:"]){
        [self.rightButton setImage:[UIImage imageNamed:@"Request_down"] forState:UIControlStateNormal];
        self.contentField.userInteractionEnabled = NO;
    }else if ([_model.leftTitle isEqualToString:@"企业网址:"]){
        [self.rightButton setImage:nil forState:UIControlStateNormal];
        self.contentField.userInteractionEnabled = YES;
    }
}


- (void)setCanChange:(BOOL)canChange{
    _canChange = canChange;
    if (canChange) {
        if ([_model.leftTitle isEqualToString:@"法人代表:"] || [_model.leftTitle isEqualToString:@"注册地:"]||[_model.leftTitle isEqualToString:@"注册资本:"] || [_model.leftTitle isEqualToString:@"企业名称:"]){
            self.userInteractionEnabled = NO;
            self.backView.backgroundColor = RGBColor(219, 219, 219);
        }else{
            self.userInteractionEnabled = YES;
            self.backView.backgroundColor = RGBColor(255, 255, 255);
        }
    }
}
#pragma mark ---

- (void)textFieldDidChanged
{
    self.model.contentStr = self.contentField.text;
}

- (void)selectUnit:(UIButton *)sender{
    if (_delegate && [_delegate respondsToSelector:@selector(showUnitView:)]) {
        [_delegate showUnitView:sender];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
