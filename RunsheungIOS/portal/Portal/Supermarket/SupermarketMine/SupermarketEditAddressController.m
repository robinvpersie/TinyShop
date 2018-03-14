//
//  SupermarketEditAddressController.m
//  Portal
//
//  Created by 左梓豪 on 2016/12/13.
//  Copyright © 2016年 linpeng. All rights reserved.
//

#import "SupermarketEditAddressController.h"
#import "SLAreaPickerView.h"

@interface SupermarketEditAddressController ()<UITableViewDelegate,UITableViewDataSource,SLAreaPickerViewDelegate,UITextFieldDelegate>{
    UITextField *addressfield;//地区
    UITextField *Namefield;
    UITextField *phonefield;
    UITextField *Haofield;
    NSString    *isDefualt;
}

@property (nonatomic,copy)NSString *address;//当前选择的地址

@end

@implementation SupermarketEditAddressController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavi];
    [self createTableView];
    // Do any additional setup after loading the view.
}

- (void)createTableView{
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource  = self;
    self.tableView.userInteractionEnabled = YES;
    [self.view addSubview:self.tableView];
}

- (void)setNavi{
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_navigationbar_back"] style:UIBarButtonItemStylePlain target:self action:@selector(popController)];
    back.tintColor = [UIColor blackColor];
    self.navigationItem.leftBarButtonItem = back;
    
    
    //保存
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(Save)];
    saveItem.tintColor = [UIColor blackColor];
    [saveItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:14],NSFontAttributeName, nil] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = saveItem;
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 30)];
    titleLab.text = @"编辑地址";
    titleLab.textColor = [UIColor blackColor];
    titleLab.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titleLab;
    
}

//获取地区
- (void)pickerArea{
    SLAreaPickerView *locPicker = [[SLAreaPickerView alloc] initWithCoder:@"湖南省" cityCode:@"长沙市" areaCode:@"雨花区"] ;
    [locPicker setDelegate:self];
    [self.view addSubview:locPicker];
    [locPicker show];
}

//保存编辑的地址
- (void)Save{
    if (Namefield.text.length ==0) {

        [MBProgressHUD hideAfterDelayWithView:self.view interval:1 text:@"请填写收货人姓名！"];
        return ;
    }else if (phonefield.text.length == 0){

        [MBProgressHUD hideAfterDelayWithView:self.view interval:1 text:@"请填写收货人联系电话号码！"];
        return ;
    }else if (addressfield.text.length == 0){

        [MBProgressHUD hideAfterDelayWithView:self.view interval:1 text:@"请选择收货人的地区!"];
        return ;
    }else if(Haofield.text.length == 0){

        [MBProgressHUD hideAfterDelayWithView:self.view interval:1 text:@"请填写收货人具体地址!"];
        return ;
    }
//    NSArray *arr = [self.address componentsSeparatedByString:@" "];
//    [RYHttpTool AddNewDeliveryAddressWithUrl:@"user/Index/action" Action:@"addaddress" uid:@"1" realname:Namefield.text mobile:phonefield.text province:arr.firstObject city:arr[1] area:arr.lastObject address:Haofield.text isdefault:isDefualt zipcode:nil success:^(id response) {
//        if ([[response objectForKey:@"error"] intValue] == 0) {
//            [[NSNotificationCenter defaultCenter]postNotificationName:AddNewAddressNotice object:nil];
//            [self.navigationController popViewControllerAnimated:YES];
//        }
//    } failure:^(NSError *err) {
//        
//    }];
}
-(void) switchAction:(id)sender
{
    UISwitch * swit = (UISwitch *)sender;
    if (swit.on) {
        isDefualt = @"1";
    }else{
        
        isDefualt = @"0";
    }
}
#pragma mark- -UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return 4;
    }
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            
            UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetHeight(cell.contentView.frame)/2 - 15, 60, 30)];
            titleLab.text = @"收货人";
            titleLab.font =[UIFont systemFontOfSize:14];
            [cell.contentView addSubview:titleLab];
            
            
            Namefield = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titleLab.frame) +10, CGRectGetHeight(cell.contentView.frame)/2 - 15, APPScreenWidth - CGRectGetMaxX(titleLab.frame)- 10 , 30)];
            Namefield.placeholder = @"请填写收货人姓名";
            Namefield.font =[UIFont systemFontOfSize:14];
            [cell.contentView addSubview:Namefield];
            
        }else if (indexPath.row == 1){
            
            UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetHeight(cell.contentView.frame)/2 - 15, 60, 30)];
            titleLab.text = @"联系电话";
            titleLab.font =[UIFont systemFontOfSize:14];
            [cell.contentView addSubview:titleLab];
            
            
            phonefield = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titleLab.frame) + 10, CGRectGetHeight(cell.contentView.frame)/2 - 15, APPScreenWidth - CGRectGetMaxX(titleLab.frame) - 10, 30)];
            phonefield.placeholder = @"请填写收货人联系电话";
            phonefield.font =[UIFont systemFontOfSize:14];
            [cell.contentView addSubview:phonefield];
        }else if (indexPath.row == 2){
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetHeight(cell.contentView.frame)/2 - 15, 60, 30)];
            titleLab.text = @"所在地区";
            titleLab.font =[UIFont systemFontOfSize:14];
            [cell.contentView addSubview:titleLab];
            
            addressfield = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titleLab.frame) + 10, CGRectGetHeight(cell.contentView.frame)/2 - 15, APPScreenWidth - CGRectGetMaxX(titleLab.frame) - 40, 30)];
            addressfield.placeholder = @"请选择收货人所在地区";
            addressfield.userInteractionEnabled = NO;
            addressfield.font =[UIFont systemFontOfSize:14];
            [cell.contentView addSubview:addressfield];
            
            
        }
        else if (indexPath.row == 3){
            Haofield = [[UITextField alloc]initWithFrame:CGRectMake(15, CGRectGetHeight(cell.contentView.frame)/2 - 15, APPScreenWidth - 30, 30)];
            Haofield.placeholder = @"请填写具体地址";
            Haofield.font =[UIFont systemFontOfSize:14];
            Haofield.delegate = self;
            [cell.contentView addSubview:Haofield];
        }
    }else if (indexPath.section == 1){
        
        UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetHeight(cell.contentView.frame)/2 - 15, 60, 30)];
        titleLab.text = @"设为默认";
        titleLab.font =[UIFont systemFontOfSize:14];
        [cell.contentView addSubview:titleLab];
        
        UISwitch *SwitchOn = [[UISwitch alloc]initWithFrame:CGRectMake(APPScreenWidth - 60, 8 , 40, 0)];
        SwitchOn.on = NO;
        isDefualt = @"0";
        if (_model.isdefault) {
            isDefualt = @"1";
            SwitchOn.on = YES;
        }
        
        [SwitchOn addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        [cell.contentView addSubview:SwitchOn];
    }
//    else if (indexPath.section == 2){
//        
//        UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetHeight(cell.contentView.frame)/2 - 15, 60, 30)];
//        titleLab.text = @"删除地址";
//        titleLab.textColor = [UIColor redColor];
//        titleLab.font =[UIFont systemFontOfSize:14];
//        [cell.contentView addSubview:titleLab];
//    }
    if (_model) {
        Namefield.text = _model.realname;
        phonefield.text = [NSString stringWithFormat:@"%0.0f",[_model.mobile floatValue]];
        addressfield.text = [NSString stringWithFormat:@"%@ %@ %@",_model.province,_model.city,_model.area];
        self.address = addressfield.text;
        Haofield.text = _model.address;
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 2) {
        [self dismissKeyBoard];
        [self pickerArea];
    }
    
    
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 8;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.1;
    }
    return 8;
}

- (void)doSLAreaPickerView:(SLAreaLocation *)locArea{
    NSLog(@"%@",locArea);
    self.address = [NSString stringWithFormat:@"%@ %@ %@",locArea.sProvinceName,locArea.sCityName,locArea.sAreaName];
    addressfield.text = self.address;
    
}
//隐藏键盘
-(void)dismissKeyBoard{
    [Namefield resignFirstResponder];
    [phonefield resignFirstResponder];
    [Haofield resignFirstResponder];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self dismissKeyBoard];
    return YES;
}


- (void)setModel:(SupermarketAddressModel *)model{
    _model = model;
    [self.tableView reloadData];
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
