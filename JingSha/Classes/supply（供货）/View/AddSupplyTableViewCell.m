//
//  AddSupplyTableViewCell.m
//  JingSha
//
//  Created by 周智勇 on 15/12/22.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import "AddSupplyTableViewCell.h"

@interface AddSupplyTableViewCell ()<UITextViewDelegate>


@property (weak, nonatomic) IBOutlet MyTextView *detailTextView;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UILabel *inputLable;


@end
@implementation AddSupplyTableViewCell

- (void)awakeFromNib {
    self.detailTextView.delegate = self;
    [self.selectButton addTarget:self action:@selector(selectedButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
   self.detailTextView.placeholder = @"请输入文字";
    self.detailTextView.placeholderColor = RGBColor(179, 179, 179);
}

- (void)textViewDidChange:(MyTextView *)textView{
    if (self.delegate && [self.delegate respondsToSelector:@selector(getValueFromTextView:cells:)]) {
        [self.delegate getValueFromTextView:textView cells:self];
    }
}

- (void)selectedButtonClick:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(getImage:)]) {
        [self.delegate getImage:sender];
    }
}
- (IBAction)deleteBtnClicked:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(deletePic:cells:)]) {
        [self.delegate deletePic:sender cells:self];
    }
}
#pragma mark -- 
- (void)setModel:(AddSupplyModel *)model{
    _model = model;

    if (_model.detailImage == nil) {
        self.detailImageView.image = [UIImage imageNamed:@"Me_addSupply"];
        self.deleteBtn.hidden = YES;//右上角的删除按钮
        self.selectButton.hidden = NO;//中间的加号按钮
        self.inputLable.hidden = NO;//请输入..的lable
    }else{
        self.detailImageView.image = _model.detailImage;
        self.selectButton.hidden = YES;//中间的加号按钮
        self.inputLable.hidden = YES;//请输入..的lable
        self.deleteBtn.hidden = NO;
    }
    if (_model.detailStr == nil) {
//        self.detailTextView.text = @"ni";
    }else{
        self.detailTextView.text = _model.detailStr;
    }
}

- (void)setAlterModel:(AddSupplyModel *)alterModel{
    _alterModel = alterModel;
    if (_alterModel.backImageStr == nil || _alterModel.detailImage == nil) {
        self.detailImageView.image = [UIImage imageNamed:@"Me_addSupply"];
        self.deleteBtn.hidden = YES;//右上角的删除按钮
        self.selectButton.hidden = NO;//中间的加号按钮
        self.inputLable.hidden = NO;//请输入..的lable
    }
    if (_alterModel.backImageStr){
        [self.detailImageView sd_setImageWithURL:[NSURL URLWithString:_alterModel.backImageStr] placeholderImage:[UIImage imageNamed:@"NetBusy"] completed:nil];
//        _alterModel.detailImage = self.detailImageView.image;
        self.selectButton.hidden = YES;//中间的加号按钮
        self.inputLable.hidden = YES;//请输入..的lable
        self.deleteBtn.hidden = NO;
    }
    if (_alterModel.detailStr == nil) {
        //        self.detailTextView.text = @"ni";
    }else{
        self.detailTextView.text = _alterModel.detailStr;
    }
    if (_alterModel.detailImage) {
        self.detailImageView.image = _alterModel.detailImage;
        self.deleteBtn.hidden = NO;//右上角的删除按钮
        self.selectButton.hidden = YES;//中间的加号按钮
        self.inputLable.hidden = YES;//请输入..的lable
    }
}


@end
