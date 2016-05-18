//
//  NewProductTableViewCell.m
//  
//
//  Created by bocweb on 15/11/21.
//
//

#import "NewProductTableViewCell.h"
#import "NewProModel.h"
#define KCellWith kUIScreenWidth
#define KCellHeight (200 * KProportionHeight)
@interface NewProductTableViewCell ()
@property (nonatomic, strong)NSMutableArray * dataAry;
@end


@implementation NewProductTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        [self setupSubViews];
        [self loadData];
    }
    return self;
}

/**
 *  加载数据
 */
- (void)loadData{
    NSString * netPath = @"pro/home_list";
    NSMutableDictionary * allParams = [NSMutableDictionary dictionary];
    [allParams setObject:KUserImfor[@"userid"] forKey:@"userid"];
    [HttpTool getWithPath:netPath params:allParams success:^(id responseObj) {
//        MyLog(@"首页新品推荐数据%@", responseObj);
        [self getDataFromResponseObj:responseObj];
        [self setupSubViews];
    } failure:^(NSError *error) {
        MyLog(@"首页数据加载错误信息%@", error);
    }];
}

/**
 *  分解取得的数据
 */
- (void)getDataFromResponseObj:(id)responseObj{
    self.dataAry = [NSMutableArray array];
    NSDictionary * dict  = responseObj[@"data"];
    for (NSDictionary * smallDict in dict[@"newpro"]) {
        NewProModel * model = [NewProModel objectWithKeyValues:smallDict];
        [self.dataAry addObject:model];
    }
}


- (void)setupSubViews {
    NSMutableArray * titleAry = [NSMutableArray array];
    NSMutableArray * imageAry = [NSMutableArray array];
    NSInteger lineCount;
    for (int i = 0; i < self.dataAry.count; i++) {
        [titleAry addObject:[self.dataAry[i] title]];
        [imageAry addObject:[self.dataAry[i] photo]];
    }
    if (self.dataAry.count <= 3) {
        lineCount = 1;
    }else if (self.dataAry.count > 3 && self.dataAry.count <= 6){
        lineCount = 2;
    }else if (self.dataAry.count > 6 && self.dataAry.count <= 9){
        lineCount = 3;
    }
    for (int i = 0 ; i < lineCount; i++) {
        for (int j = 0; j < 3 ; j++) {
            CGFloat viewX = j * (KCellWith / 3);
            CGFloat viewY = i * (KCellHeight / 2);
            CGFloat viewW = KCellWith / 3;
            CGFloat viewH = KCellHeight / 2 ;
            
            UIView *view = [[UIView alloc] init];//
            view.frame = CGRectMake(viewX, viewY, viewW, viewH);
            view.tag = 1000 + i * 3 + j;
            [self.contentView addSubview:view];
            
            if (i * 3 + j == self.dataAry.count) {
                return;
            }
            //加线(横线 竖线)
            UIView * view1 = [[UIView alloc] initWithFrame:CGRectMake(0, (i + 1) *viewH, kUIScreenWidth, 1)];
            view1.backgroundColor = RGBColor(218, 218, 218);
            [self.contentView addSubview:view1];
//
            UIView * view2 = [[UIView alloc] initWithFrame:CGRectMake(KCellWith/3 - 1, 15, 1, viewH - 30)];
            view2.backgroundColor = RGBColor(218, 218, 218);
            [view addSubview:view2];
            
            
            
            //titleLabel
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5,viewH - 20, viewW - 10, 15)];
            label.font = [UIFont systemFontOfSize:12];
            label.userInteractionEnabled = YES;
//            label.backgroundColor = [UIColor blueColor];(viewH - viewH/3*2 -20)/2 + viewH/3*2 + 5    viewH - 20
            label.text = titleAry[i*3+j];
            label.textAlignment = NSTextAlignmentCenter;
//            CGRect rect = [label.text boundingRectWithSize: CGSizeMake(viewW/5*4, 0)  options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil];
           
//            label.frame = CGRectMake(5, 5, viewW/5*4, rect.size.height);
            label.textColor = RGBColor(159, 159, 159);
            label.numberOfLines = 0;
            [view addSubview:label];
            
            //imageView
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5 , 5, viewW- 10, viewH/3*2)];
            imageView.backgroundColor = [UIColor whiteColor];
            imageView.userInteractionEnabled = YES;
            [imageView sd_setImageWithURL:[NSURL URLWithString:[self.dataAry[i * 3 + j] photo]] placeholderImage:[UIImage imageNamed:@"NetBusy"] completed:nil];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            [view addSubview:imageView];
            //给每个视图加上手势，以便对应跳转
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
            
            [view addGestureRecognizer:tap];
        }
    }
}
- (void)tapClick:(UITapGestureRecognizer *)gesture{
    UIView *selectView = gesture.view;
    NSInteger index =selectView.tag - 1000;
    NewProModel * model = _dataAry[index];
    NSString * ID = model.Id;
    if (_delegate && [_delegate respondsToSelector:@selector(pushToDetailVCFromCell:)]) {
        [_delegate pushToDetailVCFromCell:ID];
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
