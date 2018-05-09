//
//  ADMainCell.m
//  Portal
//
//  Created by linpeng on 2018/4/25.
//  Copyright © 2018年 linpeng. All rights reserved.
//

#import "ADMainCell.h"

@interface ADMainCell()

@property (nonatomic, strong) UIImageView *adView;
@property(nonatomic,strong) UILabel *newtitle;


@end

@implementation ADMainCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		self.contentView.backgroundColor = [UIColor whiteColor];
		self.selectionStyle = UITableViewCellSelectionStyleNone;

		self.newtitle = [[UILabel alloc]init];
		self.newtitle.numberOfLines = 0;
		[self.contentView addSubview:self.newtitle];
		[self.newtitle mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(self.contentView).offset(10);
			make.left.equalTo(self.contentView).offset(10);
			make.height.equalTo(@20);
			make.width.mas_equalTo(SCREEN_WIDTH/2.0f);
			
		}];
        
        self.adView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.adView];
        [self.adView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(10);
            make.bottom.equalTo(self.contentView);
            make.leading.equalTo(self.newtitle.mas_trailing).offset(15);
            make.trailing.equalTo(self.contentView).offset(-10);
        }];
		
		
    }
    return self;
}

- (void)setDic:(NSDictionary *)dic {
    [self.adView sd_setImageWithURL: [NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1525864591822&di=3f761b59881211ccfa5e22ff2cf00998&imgtype=0&src=http%3A%2F%2Fd.hiphotos.baidu.com%2Fzhidao%2Fpic%2Fitem%2F48540923dd54564e998c43d1b5de9c82d0584f68.jpg"]  placeholderImage: [UIImage imageNamed:@"no_search"]];

	NSString *titleNews = @"中华人民共和国成立了，中央人民政府成立了！";
	float height = [self getWJHeightwithContent:titleNews withWidth:SCREEN_WIDTH/2.0f withFont:17];
	[self.newtitle mas_updateConstraints:^(MASConstraintMaker *make) {
		make.height.mas_equalTo(height);
	}];
	self.newtitle.text = titleNews;

}

- (float )getWJHeightwithContent:(NSString *)content
					   withWidth:(float)width
						withFont:(float)fontValue {
	
	NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:fontValue]};
	CGSize contentSize = [content boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
	
	return contentSize.height;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
