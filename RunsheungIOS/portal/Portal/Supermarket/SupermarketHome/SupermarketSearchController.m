//
//  SupermarketSearchController.m
//  Portal
//
//  Created by 左梓豪 on 2016/12/7.
//  Copyright © 2016年 linpeng. All rights reserved.
//

#import "SupermarketSearchController.h"
#import "AMTagListView.h"
#import "NSUserDefaults+YCAddition.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface SupermarketSearchController ()<UITextFieldDelegate,UIAlertViewDelegate, AMTagListDelegate>

@property (nonatomic,retain)UITextField *fieldText;
@property (nonatomic,retain)AMTagListView *tagListView;
@property (nonatomic,retain)NSMutableArray *historyData;

@end

@implementation SupermarketSearchController {
    UIImageView *navBarHairlineImageView;
    UIView *naviBackView;
    UIView *BigbackView;
    UIView *delebackview;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.historyData = [NSUserDefaults GetSearchhistoryData];
    if (self.historyData == nil) {
        
        self.historyData = @[].mutableCopy;
    }
    
    NSLog(@"%@",self.historyData);
    [self setNavi];
    
    [self initUI];

    // Do any additional setup after loading the view.
}

#pragma mark -- 自定义的方法
//设置导航栏
- (void)setNavi{
    [self.navigationItem setHidesBackButton:YES];
    navBarHairlineImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationItem.hidesBackButton = YES;
    
    naviBackView = [[UIView alloc]initWithFrame:CGRectMake(10, 10, APPScreenWidth-60, 24)];
    naviBackView.backgroundColor = RGB(227, 227, 227);
    [self.navigationController.navigationBar addSubview:naviBackView];
    
    UIButton*baobei = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, CGRectGetHeight(naviBackView.frame))];
    [baobei setTitle:@"宝贝名:" forState:UIControlStateNormal];
    [baobei setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [baobei setFont:[UIFont systemFontOfSize:14]];
    [naviBackView addSubview:baobei];
    
    UITextField *searchText = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(baobei.frame)+ 10, 0, CGRectGetWidth(naviBackView.frame)-CGRectGetMaxX(baobei.frame) - 10, CGRectGetHeight(naviBackView.frame))];
    self.fieldText = searchText;
    searchText.placeholder = @"输入宝贝名字";
    searchText.returnKeyType = UIReturnKeySearch;//变为搜索按钮
    [searchText setFont: [UIFont systemFontOfSize:14]];
    searchText.delegate = self;
    [naviBackView addSubview:searchText];
    
    UIButton *backBtn =[[UIButton alloc]initWithFrame:CGRectMake(APPScreenWidth - 55, 0, 40, CGRectGetHeight(naviBackView.frame))];
    [backBtn setTitle:@"取消" forState:UIControlStateNormal];
    backBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [backBtn setFont:[UIFont systemFontOfSize:14]];
    [backBtn setTitleColor:RGB(145, 145, 145) forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backaction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.rightBarButtonItem = backItem;
}
//界面
- (void)initUI{
    
    BigbackView = [[UIView alloc]initWithFrame:self.view.bounds];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:BigbackView];
    
    
    self.tagListView = [[AMTagListView alloc]initWithFrame:CGRectMake(6, 40, APPScreenWidth - 12, APPScreenHeight - 104)];
    [BigbackView addSubview:self.tagListView];
    
    [[AMTagView appearance] setTagLength:10];
    [[AMTagView appearance] setTextPadding:CGPointMake(14, 14)];
    [[AMTagView appearance] setTextFont:[UIFont fontWithName:@"Futura" size:14]];
    [[AMTagView appearance] setTagColor:UIColorFromRGB(0x1f8dd6)];
    if (self.historyData.count > 0) {
        NSLog(@"%@",self.historyData);
        
        [self.tagListView addTags:self.historyData];
        
    }
    
    self.tagListView.tagListDelegate = self;
    
    [self.tagListView setTapHandler:^(AMTagView *view) {
        //        view.tag++;
        //        NSString *text = [[view.tagText componentsSeparatedByString:@" +"] firstObject];
        //        [view setTagText:[NSString stringWithFormat:@"%@ +%ld", text, view.tag]];
    }];
    
    delebackview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, APPScreenWidth, 40)];
    delebackview.hidden = YES;
    if (self.historyData.count != 0) {
        delebackview.hidden = NO;
    }
    
    [BigbackView addSubview:delebackview];
    
    UILabel *histroyLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, 60, 20)];
    histroyLab.text = @"历史搜索";
    histroyLab.font = [UIFont systemFontOfSize:14];
    histroyLab.textColor = [UIColor grayColor];
    [delebackview addSubview:histroyLab];
    
    UIButton *delehistoryBtn = [[UIButton alloc]initWithFrame:CGRectMake(APPScreenWidth - 30, 22, 12, 12)];
    [delehistoryBtn setImage:[UIImage imageNamed:@"truCan"] forState:UIControlStateNormal];
    [delehistoryBtn addTarget:self action:@selector(deleteHistroy:) forControlEvents:UIControlEventTouchUpInside];
    [delebackview addSubview:delehistoryBtn];
    
    
}

//删除搜索历史记录
- (void)deleteHistroy:(UIButton *)sender{
    
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确认删除全部历史记录"
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确认", nil];
    [alert show];
    
}
//实现找出底部横线的函数
- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

//返回按钮
- (void)backaction:(UIButton *)sender{
    
    NSLog(@"返回");
    [NSUserDefaults SetSearchhistoryData:self.historyData];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -- UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [self.historyData addObject:textField.text];
    
    NSLog(@"%@",self.historyData);
    [self.tagListView addTag:textField.text];
    [self.fieldText setText:@""];
    if (self.tagListView.tags.count >0) {
        
        delebackview.hidden = NO;
    }
    
    return YES;
}
//输入框结束编辑代理
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    NSLog(@"开始编辑文字");
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"结束编辑文字");
}


#pragma mark-- AMTagListDelegate
- (BOOL)tagList:(AMTagListView *)tagListView shouldAddTagWithText:(NSString *)text resultingContentSize:(CGSize)size {
    // Don't add a 'bad' tag
    return ![text isEqualToString:@"bad"];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex > 0) {
        
        delebackview.hidden = YES;
        if (self.historyData.count>0) {
            
            [self.historyData removeAllObjects];
            
        }
        [self.tagListView removeAllTags];
        
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
