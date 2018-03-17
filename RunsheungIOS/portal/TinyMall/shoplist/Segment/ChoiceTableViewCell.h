//
//  ChoiceTableViewCell.h
//  GigaProject
//
//  Created by dlwpdlr on 2018/3/8.
//  Copyright © 2018年 GIGA Korea. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChoiceTableViewCell : UITableViewCell
@property (nonatomic,assign)CGFloat starValue;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIImageView *Headavor;
@property (weak, nonatomic) IBOutlet UILabel *starView;
@property (weak, nonatomic) IBOutlet UIButton *unkownBtn;
@property (nonatomic,retain)NSDictionary *dic;
@property (weak, nonatomic) IBOutlet UILabel *detailedLab;

@end
