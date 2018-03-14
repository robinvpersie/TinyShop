//
//  RSWechatViewController.m
//  Portal
//
//  Created by zhengzeyou on 2018/1/13.
//  Copyright © 2018年 linpeng. All rights reserved.
//

#import "RSApplyViewController.h"

@interface RSApplyViewController ()<UITextFieldDelegate>

@property (nonatomic,strong)UIButton *submit;
@property (nonatomic,retain)NSMutableArray *contentarray;
@end

@implementation RSApplyViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setnavigation];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],
                                                                      NSForegroundColorAttributeName:[UIColor blackColor]}];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@""] forBarMetrics:UIBarMetricsDefault];
}
- (void)setData:(NSMutableArray *)data{
    _data = data;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    [self createSubView:self.data];
    [self createBottom];
    [self addClickaction];
}



- (void)addClickaction{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboardaction:)];
    [self.navigationController.navigationBar addGestureRecognizer:tap];
}
- (void)dismissKeyboardaction:(UITapGestureRecognizer*)tap{
    
    for (int i = 0; i<self.data.count; i++) {
        UIView *backView = (UIView*)[self.view viewWithTag:i];
        UITextField *field = (UITextField*)[backView viewWithTag:1001];
        [field resignFirstResponder];
        if (self.view.frame.origin.y < 0) {
            [UIView animateWithDuration:0.4 animations:^{
                self.view.transform = CGAffineTransformTranslate(self.view.transform, 0, 240);
            }];
        }
    }
}

- (void)createSubView:(NSArray*)data{
    self.view.backgroundColor = [UIColor whiteColor];
    for (int i= 0; i<data.count;i++) {
        NSDictionary *dic = data[i];
        UIView *fieldBg = [[UIView alloc]initWithFrame:CGRectMake(0, i*60, APPScreenWidth, 60)];
        fieldBg.tag = i;
        [self.view addSubview:fieldBg];
        
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(5,59, APPScreenWidth - 10, 1)];
        line.backgroundColor = RGB(237, 237, 237);
        [fieldBg addSubview:line];
        
        UILabel*titleLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 150, 60)];
        titleLab.text = dic.allKeys.firstObject;
        [fieldBg addSubview:titleLab];
        
        UITextField *contentfield = [[UITextField alloc]initWithFrame:CGRectMake(APPScreenWidth - 220, 10, 200, 40)];
        contentfield.tag = 1001;
        contentfield.delegate = self;
        YCAccountModel *model = [YCAccountModel getAccount];
         if (i == 0) {
             
             [KLHttpTool getToken:^(id token) {
                 
                 contentfield.text = model.memid;
                 
             } failure:^(NSError *errToken) {
                 
             }];
         }
        contentfield.placeholder = [dic allValues].firstObject;
        [[UITextField appearance] setTintColor:[UIColor blackColor]];
        [fieldBg addSubview:contentfield];
        
    }
  
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
   
    UIView *backView = (UIView*)textField.superview;
    if (self.view.frame.origin.y >-100 &&backView.tag>3) {
      
            [UIView animateWithDuration:0.4 animations:^{
                self.view.transform = CGAffineTransformTranslate(self.view.transform, 0, -240);
            }];
    }
    return YES;
}
- (void)createBottom{
    if (_submit == nil) {
        
        _submit =[[UIButton alloc]initWithFrame:CGRectMake(30, self.data.count *60+100, APPScreenWidth- 60, 50)];
        _submit.backgroundColor = RGB(34, 193, 67);
        _submit.layer.cornerRadius = 5;
        _submit.layer.masksToBounds = YES;
        [_submit setTitle:@"申请完成" forState:UIControlStateNormal];
        [_submit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_submit addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_submit];
    }
    
}

#pragma mark -- 检验数据填写
- (BOOL)checkContent{
    self.contentarray = [NSMutableArray array];
    for (int i = 0; i<self.data.count; i++) {
        UIView *backView = (UIView*)[self.view viewWithTag:i];
        UITextField *field = (UITextField*)[backView viewWithTag:1001];
        [self.contentarray addObject:field.text];
        if (field.text.length == 0) {
            MBProgressHUD *hude = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hude.mode = MBProgressHUDModeText;
            hude.label.text = @"请认真填写完整资料！";
            [hude hideAnimated:YES afterDelay:1];
            return NO;
            
        }
    }
    return YES;
}

- (void)submit:(UIButton*)sender{

    if (self.data != nil&&[self checkContent]) {
        YCAccountModel *accountModel = [YCAccountModel getAccount];
        NSMutableDictionary *param = @{@"lang_type":@"chn"}.mutableCopy;
        [param setObject:accountModel.customCode forKey:@"custom_code"];
        [param setObject:accountModel.customId forKey:@"custom_id"];
        if (self.data.count == 7) {//学生代理
            NSDictionary *dic = self.data.lastObject;
            if ([[dic allKeys].firstObject containsString:@"学校"] ) {
                [param setObject:self.contentarray[1] forKey:@"school_name"];
                [param setObject:@"122" forKey:@"seller_type"];
                [param setObject:self.contentarray[2] forKey:@"department"];
                [param setObject:self.contentarray[3] forKey:@"name"];
                [param setObject:self.contentarray[4] forKey:@"hp_no"];
                [param setObject:self.contentarray[5] forKey:@"IDNumber"];
                [param setObject:self.contentarray.lastObject forKey:@"addr"];
                [KLHttpTool joinStudentSellerwithwithParams:param success:^(id response) {
                    if ([response[@"status"] intValue] == 1) {
                        YCAccountModel * account = [YCAccountModel getAccount];
                        account.customlev = @"122";
                        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:account];
                        [[NSUserDefaults standardUserDefaults]setObject:data forKey:@"accountModel"];
                        
                    }

                    [self showResultView:response];
                } failure:^(NSError *err) {
                    
                }];

            }else{
              
                [param setObject:@"121" forKey:@"seller_type"];
                [param setObject:self.contentarray[1] forKey:@"hospital_name"];
                [param setObject:self.contentarray[2] forKey:@"tel_no"];
                [param setObject:self.contentarray[3] forKey:@"name"];
                [param setObject:self.contentarray[4] forKey:@"hp_no"];
                [param setObject:self.contentarray[5] forKey:@"addr"];
                [param setObject:self.contentarray.lastObject forKey:@"IDNumber"];
                [KLHttpTool joinDoctorSellerwithwithParams:param success:^(id response) {
                    if ([response[@"status"] intValue] == 1) {
                        YCAccountModel * account = [YCAccountModel getAccount];
                        account.customlev = @"121";
                        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:account];
                        [[NSUserDefaults standardUserDefaults]setObject:data forKey:@"accountModel"];
                    }
                    [self showResultView:response];
                } failure:^(NSError *err) {
                    
                }];

            }
           
        }else if (self.data.count == 3) {//微信代理

            [param setObject:@"123" forKey:@"seller_type"];
            [param setObject:self.contentarray[1] forKey:@"name"];
            [param setObject:self.contentarray[2] forKey:@"hp_no"];
            [KLHttpTool joinWeixinSellerwithwithParams:param success:^(id response) {
                if ([response[@"status"] intValue] == 1) {
                    YCAccountModel * account = [YCAccountModel getAccount];
                    account.customlev = @"123";
                    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:account];
                    [[NSUserDefaults standardUserDefaults]setObject:data forKey:@"accountModel"];
                }

                [self showResultView:response];
            } failure:^(NSError *err) {
                
            }];
        }
    }
   
}

- (void)showResultView:(id)result{
   
    if([result[@"status"] intValue] == 1){
        MBProgressHUD *hude = [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
        hude.mode = MBProgressHUDModeText;
        hude.label.text = result[@"msg"];
        [hude hideAnimated:YES afterDelay:1];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"NSDISMISSNOTIFICATION" object:nil];
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }

}
- (void)setnavigation{
    
    self.title = @"申请";
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    [btn setImage:[UIImage imageNamed:@"back_white"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(pop:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backitem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = backitem;
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],
    NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self.navigationController.navigationBar setBackgroundImage:
    [UIImage imageNamed:@"img_personalcenter_bg"] forBarMetrics:UIBarMetricsDefault];
    
}
- (void)pop:(UIButton*)sender{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
