//
//  MemberEnrollController.m
//  Portal
//
//  Created by zhengzeyou on 2017/12/27.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "RSLoginContainerController.h"
#include <CommonCrypto/CommonDigest.h>
#import "SegmentView.h"
#define LoginPhoneTag 1001
#define LoginPWDTag 1002
#define AddMemberPhoneTag 2001
#define AddMemberCodeTag 2002
#define AddMemberPwdTag 2003
#define LoginBtnTag 3001
#define AddMemberBtnTag 3002
#define AddMemberCodeBtnTag 3003
#define ForgetPwdBtnTag 3004
#define AddMemberRefTag 3005
@interface RSLoginContainerController ()<SegmentDelegate,UIScrollViewDelegate,UITextFieldDelegate>{
    UIView *loginBG;
    UIView *addmemberBG;
    MBProgressHUD *hud;
    
}

@property (nonatomic,retain)UIImageView *tableViewheadView;
@property (nonatomic,retain)UIScrollView *scrollview;
@property (nonatomic,retain)SegmentView *segment;
@property (nonatomic,retain)NSTimer *timer;
@property (nonatomic,assign)int count;

@end

@implementation RSLoginContainerController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setNavigation];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTableHeadView];
    [self createScrollView];
    
}
#pragma mark -- 登录注册
- (void)btnAction:(UIButton*)sender{
   
   
    if (sender.tag == LoginBtnTag) {//登录
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [hud showAnimated:YES];
        [self loginMember];
    }else if (sender.tag == AddMemberBtnTag) {//注册
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
      
        [hud showAnimated:YES];
        [self addNewMember];
    }else if (sender.tag == AddMemberCodeBtnTag){//获取验证码
      
        [self getCode];
    }else if (sender.tag == ForgetPwdBtnTag){//忘记密码
        
        [self forgetBtn];
    }
}
//忘记密码
- (void)forgetBtn{
    ForgetPassWotdController *vc = [[ForgetPassWotdController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
//登录
- (void)loginMember{
    __weak typeof(self) weakself = self;
    UITextField *phone = (UITextField*)[loginBG viewWithTag:LoginPhoneTag];
    UITextField *pwd = (UITextField*)[loginBG viewWithTag:LoginPWDTag];
   
    if (phone.text.length&&pwd.text.length) {
        MBProgressHUD *showloading = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [showloading showAnimated:YES];
        [KLHttpTool LoginMemberWithMemid:phone.text withMempwd:[self sha512: pwd.text] withDeviceNo:UUID success:^(id response) {
            if ([response[@"status"] intValue] == 1) {
                [hud hideAnimated:NO];
                YCAccountModel *accountModel = [[YCAccountModel alloc] init];
                accountModel.memid = response[@"memid"];
                accountModel.token =[NSString stringWithFormat:@"%@|%@",response[@"token"],UUID] ;
                accountModel.customId = response[@"custom_id"];
                accountModel.mall_home_id = response[@"mall_home_id"];
                accountModel.customCode = response[@"custom_code"];
                accountModel.ssoId = response[@"ssoId"];
                accountModel.pointCardNo = response[@"point_card_no"];
                accountModel.parentId = response[@"parent_id"];
                accountModel.customlev = response[@"custom_lev1"];
                accountModel.password = pwd.text;
                NSData *objectTodata = [NSKeyedArchiver archivedDataWithRootObject:accountModel];
                [[NSUserDefaults standardUserDefaults] setObject:objectTodata forKey:@"accountModel"];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"YCAccountIsLogin" object:nil];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakself dismissViewControllerAnimated:YES completion:^{
                        [showloading hideAnimated:YES afterDelay:0.3f];
                    }];
                });
                
            }
        } failure:^(NSError *err) {
            [hud hideAnimated:NO];
        }];
    }else{
        MBProgressHUD *hude = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hude.mode = MBProgressHUDModeText;
        hude.label.text = @"请输入账号和密码！";
        [hude hideAnimated:YES afterDelay:1.0f];
    }
    
}

//注册
- (void)addNewMember{
   
    UITextField *phone = (UITextField*)[addmemberBG viewWithTag:AddMemberPhoneTag];
    UITextField *code = (UITextField*)[addmemberBG viewWithTag:AddMemberCodeTag];
    UITextField *pwd = (UITextField*)[addmemberBG viewWithTag:AddMemberPwdTag];
    UITextField *refree = (UITextField*)[addmemberBG viewWithTag:AddMemberRefTag];
    
    [KLHttpTool registerwithMemberId:phone.text withMemberPwd:[self sha512:pwd.text] withAuthNum:code.text withParentId:refree.text  success:^(id response) {
        if ([response[@"status"] intValue] == 1) {
            [hud hideAnimated:NO];
            MBProgressHUD *hudd = [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
            hudd.mode = MBProgressHUDModeText;
            hudd.label.text = @"注册成功！";
            [hudd hideAnimated:YES afterDelay:1];
            [self moveToleft];
            [self moveToBottom];
        }
    } failure:^(NSError *err) {
        
    }];
}
//获取验证码
- (void)getCode{
    UITextField *phone = (UITextField*)[addmemberBG viewWithTag:AddMemberPhoneTag];
    [KLHttpTool getVerCodeWithHPnum:phone.text success:^(id response) {
        
    } failure:^(NSError *err) {
        
    }];
   
    _count = 60;
    if (_timer == nil) {

        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeraction) userInfo:nil repeats:YES];
        [_timer fire];
    }
    
}
#pragma mark -- SegmentDelegate代理
- (void)click:(int)tag{
    [self rsKeyboardDismiss];
    if (tag == 1001) {//登录
        [self moveToleft];
        [self moveToBottom];
    } else {//注册
        [self moveToright];
    }
    
}

- (void)createTableHeadView{
  
    self.view.backgroundColor = [UIColor whiteColor];
    _tableViewheadView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"img_login_bg"]];
    _tableViewheadView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*0.4);
    [self.view addSubview:_tableViewheadView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImg:)];
    [_tableViewheadView addGestureRecognizer:tap];
    [_tableViewheadView setUserInteractionEnabled: YES];
    _segment = [[SegmentView alloc]initWithFrame:CGRectMake(0,SCREEN_HEIGHT*0.4 - 60 , APPScreenWidth, 60)];
    _segment.delegate = self;
    [_tableViewheadView addSubview:_segment];

}

- (void)tapImg:(UITapGestureRecognizer*)tap{
   
    [self moveToBottom];
    [self rsKeyboardDismiss];
}

#pragma mark -- 设置导航栏
- (void)setNavigation{
    
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    leftBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 10);
    [leftBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;

    //设置导航栏背景图片为一个空的image，这样就透明了
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
}

#pragma mark -- 界面部分
- (void)createSubviews{
    //登录
    loginBG =[[UIView alloc]initWithFrame:CGRectMake(35, 50, APPScreenWidth- 70, 100)];
    loginBG.layer.borderColor = RGB(204, 204, 204).CGColor;
    loginBG.layer.borderWidth = 1.0f;
    loginBG.layer.cornerRadius = 3;
    loginBG.layer.masksToBounds = YES;
    [self.scrollview addSubview:loginBG];
    
    UILabel *line1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 49.5f, APPScreenWidth- 70, 1)];
    line1.backgroundColor = RGB(204, 204, 204);
    [loginBG addSubview:line1];
    
    UIImageView *loginPhoneIcon = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 30, 30)];
    loginPhoneIcon.image = [UIImage imageNamed:@"icon_telnumber"];
    [loginBG addSubview:loginPhoneIcon];
    
    UIImageView *loginpwdIcon = [[UIImageView alloc]initWithFrame:CGRectMake(10, 60, 30, 30)];
    loginpwdIcon.image = [UIImage imageNamed:@"rsicon_password"];
    [loginBG addSubview:loginpwdIcon];
    
    UITextField *loginPhonefield = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(loginPhoneIcon.frame) + 5, CGRectGetMinY(loginPhoneIcon.frame), CGRectGetWidth(loginBG.frame) - CGRectGetMaxX(loginPhoneIcon.frame) - 10, CGRectGetHeight(loginPhoneIcon.frame))];
    loginPhonefield.placeholder = @"请输入电话号码";
    loginPhonefield.keyboardType = UIKeyboardTypeDecimalPad;
    loginPhonefield.tag = LoginPhoneTag;
    [loginBG addSubview:loginPhonefield];
    
    UITextField *loginPwdfield = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(loginpwdIcon.frame) + 5, CGRectGetMinY(loginpwdIcon.frame), CGRectGetWidth(loginBG.frame) - CGRectGetMaxX(loginpwdIcon.frame) - 10, CGRectGetHeight(loginpwdIcon.frame))];
    loginPwdfield.placeholder = @"请输密码";
    loginPwdfield.keyboardType = UIKeyboardTypeDecimalPad;
    loginPwdfield.secureTextEntry = YES;
    loginPwdfield.tag = LoginPWDTag;
    [loginBG addSubview:loginPwdfield];
    
    UIButton *loginBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMinX(loginBG.frame), CGRectGetMaxY(loginBG.frame)+ 30, CGRectGetWidth(loginBG.frame), 50)];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    loginBtn.tag = LoginBtnTag;
    loginBtn.backgroundColor = RGB(33, 192, 67);
    loginBtn.layer.cornerRadius = 5.0f;
    loginBtn.layer.masksToBounds = YES;
    [self.scrollview addSubview:loginBtn];
    
    //忘记密码
    UIButton *forgetBtn = [[UIButton alloc]initWithFrame:CGRectMake(APPScreenWidth/2 - 50, CGRectGetMaxY(loginBtn.frame)+ 10, 100, 50)];
    forgetBtn.tag = ForgetPwdBtnTag;
    forgetBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    NSMutableAttributedString* tncString = [[NSMutableAttributedString alloc] initWithString:@"忘记密码?"];
    [tncString addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:(NSRange){0,[tncString length]}];
    [tncString addAttribute:NSUnderlineColorAttributeName value:RGB(33, 192, 67) range:(NSRange){0,[tncString length]}];
    [tncString addAttribute:NSForegroundColorAttributeName value:RGB(33, 192, 67) range:(NSRange){0,[tncString length]}];
    [forgetBtn setAttributedTitle:tncString forState:UIControlStateNormal];
    [forgetBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollview addSubview:forgetBtn];
    
    //注册
    addmemberBG =[[UIView alloc]initWithFrame:CGRectMake(APPScreenWidth+35, 50, APPScreenWidth- 70, 200)];
    addmemberBG.layer.borderColor = RGB(204, 204, 204).CGColor;
    addmemberBG.layer.borderWidth = 1.0f;
    addmemberBG.layer.cornerRadius = 3;
    addmemberBG.layer.masksToBounds = YES;
    [self.scrollview addSubview:addmemberBG];
    
    UITapGestureRecognizer *tap11 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImg:)];
    [_scrollview addGestureRecognizer:tap11];
    
    UILabel *line2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 49.5f, APPScreenWidth- 70, 1)];
    line2.backgroundColor = RGB(204, 204, 204);
    [addmemberBG addSubview:line2];
    
    UILabel *line3 = [[UILabel alloc]initWithFrame:CGRectMake(0, 99.5f, APPScreenWidth- 70, 1)];
    line3.backgroundColor = RGB(204, 204, 204);
    [addmemberBG addSubview:line3];
   
    UILabel *line4 = [[UILabel alloc]initWithFrame:CGRectMake(0, 149.5f, APPScreenWidth- 70, 1)];
    line4.backgroundColor = RGB(204, 204, 204);
    [addmemberBG addSubview:line4];
    
    UIImageView *addPhoneIcon = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 30, 30)];
    addPhoneIcon.image = [UIImage imageNamed:@"icon_telnumber"];
    [addmemberBG addSubview:addPhoneIcon];
    
    UIImageView *addcodeIcon = [[UIImageView alloc]initWithFrame:CGRectMake(10, 60, 30, 30)];
    addcodeIcon.image = [UIImage imageNamed:@"icon_verification_code"];
    [addmemberBG addSubview:addcodeIcon];
    
    UIImageView *addpwdIcon = [[UIImageView alloc]initWithFrame:CGRectMake(10, 110, 30, 30)];
    addpwdIcon.image = [UIImage imageNamed:@"rsicon_password"];
    [addmemberBG addSubview:addpwdIcon];
    
    UIImageView *refreedIcon = [[UIImageView alloc]initWithFrame:CGRectMake(10, 160, 30, 30)];
    refreedIcon.image = [UIImage imageNamed:@"icon_telnumber"];
    [addmemberBG addSubview:refreedIcon];
    
    UITextField *addPhonefield = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(addPhoneIcon.frame) + 5, CGRectGetMinY(addPhoneIcon.frame), CGRectGetWidth(addmemberBG.frame) - CGRectGetMaxX(addPhoneIcon.frame) - 10, CGRectGetHeight(addPhoneIcon.frame))];
    addPhonefield.placeholder = @"请输入电话号码";
    addPhonefield.keyboardType = UIKeyboardTypeDecimalPad;
    addPhonefield.tag = AddMemberPhoneTag;
    [addmemberBG addSubview:addPhonefield];
    
    UITextField *addcodefield = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(addcodeIcon.frame) + 5, CGRectGetMinY(addcodeIcon.frame), CGRectGetWidth(addmemberBG.frame) - CGRectGetMaxX(addcodeIcon.frame) - 90, CGRectGetHeight(addcodeIcon.frame))];
    addcodefield.placeholder = @"请输入验证码";
    addcodefield.keyboardType = UIKeyboardTypeDecimalPad;
    addcodefield.tag = AddMemberCodeTag;
    [addmemberBG addSubview:addcodefield];
    
    UIButton *addcodeBtn = [[UIButton alloc]initWithFrame: CGRectMake(CGRectGetMaxX(addcodefield.frame) + 5, CGRectGetMinY(addcodeIcon.frame), 80, CGRectGetHeight(addcodeIcon.frame))];
    [addcodeBtn setTitle:@"获取验证码" forState: UIControlStateNormal];
    addcodeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [addcodeBtn setTitleColor: RGB(33, 192, 67) forState: UIControlStateNormal];
    addcodeBtn.tag = AddMemberCodeBtnTag;
    [addcodeBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [addmemberBG addSubview:addcodeBtn];
    
    
    UITextField *addPwdfield = [[UITextField alloc]initWithFrame: CGRectMake(CGRectGetMaxX(addpwdIcon.frame) + 5, CGRectGetMinY(addpwdIcon.frame), CGRectGetWidth(addmemberBG.frame) - CGRectGetMaxX(addpwdIcon.frame) - 10, CGRectGetHeight(addpwdIcon.frame))];
    addPwdfield.placeholder = @"请输入密码";
    addPwdfield.keyboardType = UIKeyboardTypeDecimalPad;
    addPwdfield.tag = AddMemberPwdTag;
    addPwdfield.delegate = self;
    [addmemberBG addSubview:addPwdfield];
    
    UITextField *refreefield = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(refreedIcon.frame) + 5, CGRectGetMinY(refreedIcon.frame), CGRectGetWidth(addmemberBG.frame) - CGRectGetMaxX(refreedIcon.frame) - 10, CGRectGetHeight(refreedIcon.frame))];
    refreefield.placeholder = @"请输入推荐人号码";
    refreefield.keyboardType = UIKeyboardTypeDecimalPad;
    refreefield.tag = AddMemberRefTag;
    refreefield.delegate = self;
    [addmemberBG addSubview:refreefield];
    
    
    UIButton *addmemberBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMinX(addmemberBG.frame), CGRectGetMaxY(addmemberBG.frame)+ 30, CGRectGetWidth(addmemberBG.frame), 50)];
    [addmemberBtn setTitle:@"注册" forState:UIControlStateNormal];
    [addmemberBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addmemberBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    addmemberBtn.tag = AddMemberBtnTag;
    addmemberBtn.backgroundColor = RGB(33, 192, 67);
    addmemberBtn.layer.cornerRadius = 5.0f;
    addmemberBtn.layer.masksToBounds = YES;
    [self.scrollview addSubview:addmemberBtn];
    
}
- (void)createScrollView{
    if (self.scrollview == nil) {
        self.scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, APPScreenHeight *0.4, APPScreenWidth, APPScreenHeight *0.6)];
        self.scrollview.delegate = self;
        self.scrollview.pagingEnabled = YES;
        self.scrollview.contentSize = CGSizeMake(2*APPScreenWidth, APPScreenHeight *0.6);
        [self createSubviews];
        self.scrollview.showsHorizontalScrollIndicator = NO;
        [self.view addSubview:self.scrollview];
    }
}
//UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [self moveToTop];
    return YES;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
  
    float offX = scrollView.contentOffset.x;
    int index = (int)(offX/APPScreenWidth);
    if ((offX - APPScreenWidth*index) > (APPScreenWidth/2.0) ) {
        index = index+1;
    }
    scrollView.contentOffset = CGPointMake(index*APPScreenWidth, 0 );
    
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    _segment.disoffx = scrollView.contentOffset.x;
}
- (void)dismiss{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)timeraction{
     UIButton *getVerCode = (UIButton*)[addmemberBG viewWithTag:AddMemberCodeBtnTag];
    if (_count>0) {
        [getVerCode setTitle:[NSString stringWithFormat:@"还剩%ds",_count] forState:UIControlStateNormal];
        _count--;
    }else{
        [_timer invalidate];
        _timer = nil;
        [getVerCode setTitle:@"获取验证码" forState:UIControlStateNormal];
    }
   
    
}

- (NSString*)sha512:(NSString*)input {
    const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:input.length];
    
    uint8_t digest[CC_SHA512_DIGEST_LENGTH];
    
    CC_SHA512(data.bytes, (CC_LONG)data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA512_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA512_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
    
}

#pragma mark -- 移动的方法
//上移
- (void)moveToTop{
    if (self.view.frame.origin.y == 0) {
        [UIView animateWithDuration:0.4 animations:^{
            self.view.transform = CGAffineTransformTranslate(self.view.transform, 0, -174);
        }];
    }
}

//下移
- (void)moveToBottom{
    if (self.view.frame.origin.y < 0) {
        [UIView animateWithDuration:0.4 animations:^{
            self.view.transform = CGAffineTransformTranslate(self.view.transform, 0, 174);
            
        }];
    }
}
//左移
- (void)moveToleft{
    if (self.scrollview.contentOffset.x > APPScreenWidth/2) {
        [UIView animateWithDuration:0.4 animations:^{
            self.scrollview.contentOffset = CGPointMake(0, 0);
        }];
    };
}

//右移
- (void)moveToright{
    if (self.scrollview.contentOffset.x < APPScreenWidth/2) {
        
        [UIView animateWithDuration:0.4 animations:^{
            self.scrollview.contentOffset = CGPointMake(APPScreenWidth, 0);
        }];
    }
}


- (void)rsKeyboardDismiss{
    UITextField *field1 = (UITextField*)[loginBG viewWithTag:LoginPhoneTag];
    UITextField *field2 = (UITextField*)[loginBG viewWithTag:LoginPWDTag];
    UITextField *field3 = (UITextField*)[addmemberBG viewWithTag:AddMemberPhoneTag];
    UITextField *field4 = (UITextField*)[addmemberBG viewWithTag:AddMemberCodeTag];
    UITextField *field5 = (UITextField*)[addmemberBG viewWithTag:AddMemberPwdTag];
    UITextField *field6 = (UITextField*)[addmemberBG viewWithTag:AddMemberRefTag];
    
    [field1 resignFirstResponder];
    [field2 resignFirstResponder];
    [field3 resignFirstResponder];
    [field4 resignFirstResponder];
    [field5 resignFirstResponder];
    [field6 resignFirstResponder];
}
@end
