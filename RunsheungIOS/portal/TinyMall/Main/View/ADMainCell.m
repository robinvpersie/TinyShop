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
		
		
		self.adView = [[UIImageView alloc] init];
		[self.contentView addSubview:self.adView];
		self.adView.layer.cornerRadius = 5.0f;
		self.adView.layer.masksToBounds = YES;
		[self.adView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(self.contentView).offset(15);
			make.bottom.equalTo(self.contentView).offset(-15);
			make.leading.equalTo(self.contentView).offset(10);
			make.width.mas_equalTo(90);
		}];
		
		self.newtitle = [[UILabel alloc]init];
		self.newtitle.numberOfLines = 0;
		[self.contentView addSubview:self.newtitle];
		[self.newtitle mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(self.contentView).offset(15);
			make.leading.equalTo(self.adView.mas_trailing).offset(15);
			make.trailing.equalTo(self.contentView.mas_trailing).offset(-10);
			
		}];
		
	}
	return self;
}

- (void)setDic:(NSDictionary *)dic {
	[self.adView sd_setImageWithURL: [NSURL URLWithString:dic[@"TitlePic"]]  placeholderImage: [UIImage imageNamed:@"no_search"]];
	
	NSString *titleNews = dic[@"Title"];
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
