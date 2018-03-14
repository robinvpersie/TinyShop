//
//  AddExpressController.m
//  Portal
//
//  Created by ifox on 2017/3/21.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "AddExpressController.h"
#import "UILabel+CreateLabel.h"
#import "UILabel+WidthAndHeight.h"
#import "UIButton+CreateButton.h"
#import "STPickerSingle.h"

@interface AddExpressController ()<UITableViewDelegate,UITableViewDataSource,STPickerSingleDelegate>

@property(nonatomic, strong) UITableView *tableView;

@property(nonatomic, strong) UITextField *expressCompany;
@property(nonatomic, strong) UITextField *expressNumber;
@property(nonatomic, strong) UITextField *phoneNumber;
@property(nonatomic, strong) STPickerSingle *pickerView;

@end

@implementation AddExpressController {
    UIView *bgImageView;
    UILabel *msg;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"填写物流信息";
    
    self.view.backgroundColor = RGB(242, 242, 242);
    
    [self createView];
    // Do any additional setup after loading the view.
}

- (void)createView {
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPScreenWidth, APPScreenHeight)];
    footer.backgroundColor = RGB(242, 242, 242);
    _tableView.tableFooterView = footer;
    [self.view addSubview:_tableView];
    
    bgImageView = [[UIView alloc] initWithFrame:CGRectMake(15, 10, APPScreenWidth - 30, 50)];
    bgImageView.backgroundColor = [UIColor whiteColor];
    [footer addSubview:bgImageView];
    
    msg = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, APPScreenWidth, bgImageView.frame.size.height)];
    msg.textColor = [UIColor lightGrayColor];
    msg.text = @"上传照片最多三张";
    msg.font = [UIFont systemFontOfSize:15];
    [bgImageView addSubview:msg];
    
    UIButton *camera = [UIButton buttonWithType:UIButtonTypeCustom];
    camera.frame = CGRectMake(bgImageView.frame.size.width - 5 - 40, 15, 40, 40);
    [camera setImage:[UIImage imageNamed:@"camera_gray"] forState:UIControlStateNormal];
    [camera addTarget:self action:@selector(clickCamera) forControlEvents:UIControlEventTouchUpInside];
    [footer addSubview:camera];
    
    UIButton *submit = [UIButton createButtonWithFrame:CGRectMake(15, CGRectGetMaxY(bgImageView.frame)+30, APPScreenWidth - 15*2, 40) title:@"提交退货物流申请" titleColor:[UIColor whiteColor] titleFont:[UIFont systemFontOfSize:17] backgroundColor:RGB(0,207,120)];
    [submit addTarget:self action:@selector(submitCommit) forControlEvents:UIControlEventTouchUpInside];
    submit.layer.cornerRadius = 4.0f;
    [footer addSubview:submit];
    
    _pickerView = [[STPickerSingle alloc] init];
    _pickerView.widthPickerComponent = APPScreenWidth;
    _pickerView.delegate = self;
    _pickerView.arrayData = @[@"顺丰快递",@"圆通快递",@"申通快递",@"韵达快递",@"天天快递",@"百世汇通",@"中通快递",@"EMS邮政快递"].mutableCopy;
}

- (void)clickCamera {
//    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
//    
//    imagePickerVc.pickerDelegate = self;
//    imagePickerVc.maxImagesCount = 3;
//    
//    [self presentViewControer:imagePickerVc animated:YES completion:nil];
    
}

- (void)submitCommit {
    [KLHttpTool supermarketSubmitRefundExpressInfoWithExpressNumber:_expressNumber.text itemCode:_itemCode refundNo:_refundNo success:^(id response) {
        NSLog(@"%@",response);
        NSNumber *status = response[@"status"];
        if (status.integerValue == 1) {
            [MBProgressHUD hideAfterDelayWithView:KEYWINDOW interval:2 text:response[@"message"]];
            [self performSelector:@selector(popController) withObject:nil afterDelay:2];
        }
    } failure:^(NSError *err) {
        
    }];
}

- (void)popController {
    [self.navigationController popViewControllerAnimated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    CGFloat width = [UILabel getWidthWithTitle:@"物流公司" font:[UIFont systemFontOfSize:15]];
    if (indexPath.row == 0) {
        UILabel *companyTitle = [UILabel createLabelWithFrame:CGRectMake(15, 0, width, 50) textColor:[UIColor darkcolor] font:[UIFont systemFontOfSize:15] textAlignment:NSTextAlignmentLeft text:@"物流公司"];
        [cell.contentView addSubview:companyTitle];
        
        UITextField *expressCompany = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(companyTitle.frame)+15, companyTitle.frame.origin.y, APPScreenWidth, companyTitle.frame.size.height)];
        expressCompany.placeholder = @"请选择物流公司";
        expressCompany.font = companyTitle.font;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        expressCompany.userInteractionEnabled = NO;
        [cell.contentView addSubview:expressCompany];
        self.expressCompany = expressCompany;
    } else if (indexPath.row == 1) {
        UILabel *expressNumTitle = [UILabel createLabelWithFrame:CGRectMake(15, 0, width, 50) textColor:[UIColor darkcolor] font:[UIFont systemFontOfSize:15] textAlignment:NSTextAlignmentLeft text:@"物流单号"];
        [cell.contentView addSubview:expressNumTitle];
        
        UITextField *expressNum = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(expressNumTitle.frame)+15, expressNumTitle.frame.origin.y, APPScreenWidth, expressNumTitle.frame.size.height)];
        expressNum.placeholder = @"请输入物流单号";
        expressNum.keyboardType = UIKeyboardTypeNumberPad;
        expressNum.font = expressNumTitle.font;
        [cell.contentView addSubview:expressNum];
        self.expressNumber = expressNum;

    } else if (indexPath.row == 2) {
        UILabel *phoneTitle = [UILabel createLabelWithFrame:CGRectMake(15, 0, width, 50) textColor:[UIColor darkcolor] font:[UIFont systemFontOfSize:15] textAlignment:NSTextAlignmentLeft text:@"联系电话"];
        [cell.contentView addSubview:phoneTitle];
        
        UITextField *phoneNumber = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(phoneTitle.frame)+15, phoneTitle.frame.origin.y, APPScreenWidth, phoneTitle.frame.size.height)];
        phoneNumber.placeholder = @"请输入您的联系电话";
        phoneNumber.font = phoneTitle.font;
        phoneNumber.keyboardType = UIKeyboardTypeNumberPad;
        [cell.contentView addSubview:phoneNumber];
        self.phoneNumber = phoneNumber;

    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [_expressNumber resignFirstResponder];
        [_phoneNumber resignFirstResponder];
        [_pickerView show];
    }
}

- (void)pickerSingle:(STPickerSingle *)pickerSingle selectedTitle:(NSString *)selectedTitle {
    _expressCompany.text = selectedTitle;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
