//
//  LSVersionUpdateVIew.h
//
//  Created by ArthurShuai on 16/10/31.
//  Copyright © 2016年 ArthurShuai. All rights reserved.
//

#import "LSVersionUpdateVIew.h"
#import "Masonry.h"

#define WIDTH  kScreenW * 580/2/375
#define SPACE  kScreenH * 50/667
#define TITLEFONT 24*kScreenH/667
#define VERSIONFONT 15*kScreenH/667
#define WIDTHSPACE kScreenW * 15/375

@interface LSVersionUpdateVIew()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic)CGFloat V_Height;//弹出框高度

/**
 *  标题
 */
@property(nonatomic, strong)UILabel *titleLabel;

/**
 *  版本
 */
@property(nonatomic, strong)UILabel *VersionLabel;


/**
 *  描述tableView
 */
@property(nonatomic, strong)UITableView *describeTableView;

/**
 *  描述内容
 */
@property(nonatomic, strong)NSArray *DescribeArr;

/**
 *  稍后提醒
 */
@property(nonatomic, strong)UIButton *laterBt;

/**
 *  立即更新
 */
@property(nonatomic, strong)UIButton *rightNowBt;

/**
 *  蒙版
 */
@property(nonatomic, strong)UIView *backView;

@end

@implementation LSVersionUpdateVIew

-(instancetype)initWith:(NSString *)version Describe:(NSArray *)describeArr{
    if (self = [super init]) {
        self.DescribeArr = describeArr;
        self.frame = [self getViewFrame];
        self.backgroundColor = [UIColor whiteColor];
        [self loadData:version];
        [self show];
        self.layer.cornerRadius = 10;
        [self addSubview:self.titleLable];
        [self addSubview:self.VersionLable];
        [self addSubview:self.describeTableView];
        [self addSubview:self.rightNowBt];
        [self addSubview:self.laterBt];
        [kAppDelegate.window addSubview:self.backView];
        [kAppDelegate.window bringSubviewToFront:self];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(20);
        make.left.equalTo(self.mas_left);
        make.size.mas_equalTo(CGSizeMake(WIDTH, 20));
    }];
    [self.VersionLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLable.mas_bottom).offset(10);
        make.left.equalTo(self.mas_left);
        make.size.mas_equalTo(CGSizeMake(WIDTH, 20));
    }];
    [self.describeTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.VersionLabel.mas_bottom).offset(10);
        make.left.equalTo(self.mas_left);
        make.bottom.equalTo(self.mas_bottom).offset(-SPACE);
        make.width.equalTo(self.mas_width);
    }];
    [self.laterBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(WIDTHSPACE);
        make.top.equalTo(self.describeTableView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake((WIDTH - 3*WIDTHSPACE)/2, SPACE/1.3));
    }];
    [self.rightNowBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.laterBt.mas_right).offset(WIDTHSPACE);
        make.top.equalTo(self.describeTableView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake((WIDTH - 3*WIDTHSPACE)/2, SPACE/1.3));
    }];
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(kAppDelegate.window);
    }];
}

-(CGRect)getViewFrame{
    CGFloat height = 0;
    for (int i=0; i<self.DescribeArr.count; i++) {
        height += [self calculateSizeWithWidth:WIDTH-40 font:[UIFont systemFontOfSize:VERSIONFONT] content:self.DescribeArr[i]];
    }
    if (height < 200) {
        _V_Height = 200;
    }else if(height > kScreenH * 627/2/667){
        _V_Height = kScreenH * 627/2/667;
    }else{
        _V_Height = height;
    }
    CGRect frame = CGRectZero;
    frame.size.height = _V_Height;
    frame.size.width = WIDTH;
    frame.origin.x = (kScreenW - WIDTH)/2;
    frame.origin.y = -_V_Height;
    return frame;
}

- (void)loadData:(NSString *)versionStr{
    self.titleLable.text = @"软件更新提示";
    self.VersionLable.text = versionStr;
}
-(UILabel *)titleLable{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:TITLEFONT];
        _titleLabel.textColor = kColorFromRGBValue(0x3c3c3c);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}


-(UILabel *)VersionLable{
    if (_VersionLabel == nil) {
        _VersionLabel = [[UILabel alloc] init];
        _VersionLabel.font = [UIFont systemFontOfSize:VERSIONFONT];
        _VersionLabel.textColor = kColorFromRGBValue(0xaeaeae);
        _VersionLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _VersionLabel;
}

-(UITableView *)describeTableView{
    if (_describeTableView == nil) {
        _describeTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _describeTableView.delegate = self;
        _describeTableView.dataSource = self;
        _describeTableView.showsHorizontalScrollIndicator = NO;
        _describeTableView.showsVerticalScrollIndicator = NO;
        _describeTableView.scrollEnabled = [self IfScrollEnabled];
        _describeTableView.layer.cornerRadius = 10;
        _describeTableView.backgroundColor = [UIColor whiteColor];
        _describeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _describeTableView;
}

-(UIButton *)laterBt{
    if (_laterBt == nil) {
        _laterBt = [UIButton buttonWithType:UIButtonTypeCustom];
        [_laterBt setTitle:@"稍后更新" forState:UIControlStateNormal];
        [_laterBt setTitleColor:kColorFromRGBValue(0xaeaeae) forState:UIControlStateNormal];
        [_laterBt setTitleColor:kColorFromRGBValue(0xd4d4d4) forState:UIControlStateHighlighted];
        _laterBt.layer.borderColor = kColorFromRGBValue(0xaeaeae).CGColor;
        _laterBt.layer.borderWidth = 0.5;
        _laterBt.layer.cornerRadius = 5;
        _laterBt.titleLabel.font = [UIFont systemFontOfSize:VERSIONFONT + 2];
        [_laterBt addTarget:self action:@selector(removeView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _laterBt;
}

-(UIButton *)rightNowBt{
    if (_rightNowBt == nil) {
        _rightNowBt = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightNowBt setTitle:@"立即更新" forState:UIControlStateNormal];
        [_rightNowBt setTitleColor:kColorFromRGBValue(0xffffff) forState:UIControlStateNormal];
        [_rightNowBt setTitleColor:kColorFromRGBValue(0x716fd7) forState:UIControlStateHighlighted];
        _rightNowBt.titleLabel.font = [UIFont systemFontOfSize:VERSIONFONT + 2];
        _rightNowBt.backgroundColor = [UIColor orangeColor];
        _rightNowBt.layer.cornerRadius = 5;
        [_rightNowBt addTarget:self action:@selector(goToAppStore) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightNowBt;
}

- (UIView *)backView{
    if (_backView == nil) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = [UIColor blackColor];
        _backView.alpha = 0.5f;
        _backView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }
    return _backView;
}

- (void)show{
    [kAppDelegate.window addSubview:self];
    WeakObj(self)
    [UIView animateWithDuration:0.25 animations:^{
        weakself.frame = CGRectMake((kScreenW - WIDTH)/2, (kScreenH - _V_Height)/2 - SPACE, WIDTH, _V_Height);
    }];
    CAKeyframeAnimation *animation = [[CAKeyframeAnimation alloc] init];
    [animation setDelegate:(id)self];
    animation.values = @[@(M_PI/64),@(-M_PI/64),@(M_PI/64),@(0)];
    animation.duration = 0.5;
    [animation setKeyPath:@"transform.rotation"];
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    [self.layer addAnimation:animation forKey:@"shake"];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.DescribeArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat rowHight = [self calculateSizeWithWidth:WIDTH - 40 font:[UIFont systemFontOfSize:VERSIONFONT] content:self.DescribeArr[indexPath.row]];
    return rowHight;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"statusCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    [self configCellSubViews:cell Index:indexPath.row];
    return cell;
}

/**
 *  计算高度
 *
 *  @param width   label width
 *  @param font    label font
 *  @param content label content
 *
 *  @return hight
 */
- (float)calculateSizeWithWidth:(float)width font:(UIFont *)font content:(NSString *)content{
    CGSize maximumSize =CGSizeMake(width,9999);
    NSDictionary *textDic = @{NSFontAttributeName : font};
    CGSize contentSize = [content boundingRectWithSize:maximumSize options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:textDic context:nil].size;
    CGSize oneLineSize = [@"test" boundingRectWithSize:CGSizeMake(MAXFLOAT,MAXFLOAT) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:textDic context:nil].size;
    return (contentSize.height/oneLineSize.height) * 10 + contentSize.height;
}

- (void)configCellSubViews:(UITableViewCell *)cell Index:(NSInteger)index{
    NSString *contentStr = self.DescribeArr[index];
    UILabel *DescribeLabel = [[UILabel alloc] init];
    DescribeLabel.font = [UIFont systemFontOfSize:VERSIONFONT];
    DescribeLabel.textAlignment = NSTextAlignmentLeft;
    DescribeLabel.numberOfLines = 0;
    DescribeLabel.text = contentStr;
    DescribeLabel.textColor = kColorFromRGBValue(0x3c3c3c);
    [cell.contentView addSubview:DescribeLabel];
    
    CGFloat rowHight = [self calculateSizeWithWidth:WIDTH - 40 font:[UIFont systemFontOfSize:VERSIONFONT] content:contentStr];
    [DescribeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cell.contentView);
        make.height.mas_equalTo(rowHight);
        make.left.equalTo(cell.contentView).offset(20);
        make.right.equalTo(cell.contentView).offset(-20);
    }];
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:contentStr];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:10];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [contentStr length])];
    
    [DescribeLabel setAttributedText:attributedString];
    
}

-(BOOL)IfScrollEnabled{
    BOOL ee;
    float height;
    height = [self returnRowHight:0 Index:0];
    ee = height < _V_Height - 80 - SPACE || height == _V_Height - 80 - SPACE ? NO : YES;
    return ee;
}

- (float)returnRowHight:(float)height Index:(NSInteger)index{
    if (index > self.DescribeArr.count - 1) {
        return height;
    }else{
        height = height + [self calculateSizeWithWidth:WIDTH - 40 font:[UIFont systemFontOfSize:VERSIONFONT] content:self.DescribeArr[index]];
        index ++;
        return [self returnRowHight:height Index:index];
    }
    return 0;
}

- (void)removeView{
    WeakObj(self)
    [UIView animateWithDuration:0.25 animations:^{
        [weakself setFrame:CGRectMake((kScreenW - WIDTH)/2, kScreenH, WIDTH, weakself.V_Height)];
    } completion:^(BOOL finished) {
        [weakself.backView removeFromSuperview];
        weakself.backView = nil;
        [weakself removeFromSuperview];
        if (weakself.removeUpdateViewBlock) {
            weakself.removeUpdateViewBlock();
        }
    }];
    
}
- (void)goToAppStore{
    if (self.GoTOAppstoreBlock) {
        self.GoTOAppstoreBlock();
    }
}

@end
