//
//  SupermarketMyAddressViewController.m
//  Portal
//
//  Created by 左梓豪 on 2016/12/13.
//  Copyright © 2016年 linpeng. All rights reserved.
//

#import "SupermarketMyAddressViewController.h"
#import "SupermarketEditAddressController.h"
#import "SupermarketAddressModel.h"
#import "SupermarketNewAddessController.h"
#import "MJRefresh.h"
#import "UILabel+CreateLabel.h"
#import "UILabel+WidthAndHeight.h"

@interface SupermarketMyAddressViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic,retain)MBProgressHUD *loadHud;//加载地址数据是的提示

@end

@implementation SupermarketMyAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(239, 239, 244);
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(requestData) name:RefreshMyAddressListNotification object:nil];
    
//    [self createData];
    
    [self setNavi];
    [self createTableView];
    [self createBottom];
    
    [self requestData];
    // Do any additional setup after loading the view.
}

//- (void)createData {
//    NSMutableArray *data = @[].mutableCopy;
//    for (int i = 0; i < 10; i++) {
//        SupermarketAddressModel *addressModel = [[SupermarketAddressModel alloc] init];
//        addressModel.realname = @"左梓豪";
//        addressModel.area = @"天心区";
//        addressModel.city = @"长沙市";
//        addressModel.province = @"湖南省";
//        addressModel.isdefault = @"1";
//        addressModel.mobile = @"18390802762";
//        addressModel.address = @"人民东路宇成酒店人民东路宇成酒店人民东路宇成酒店";
//        [data addObject:addressModel];
//    }
//    self.data = data;
//
//}

- (void)requestData {
    if (_loadHud == nil) {
        _loadHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        _loadHud.tintColor = [UIColor lightGrayColor];
    }
    
    if (_isCreateOrder == YES) {
        [KLHttpTool getSupermarketUserAddressListWithDivCode:@"2" success:^(id response) {
            NSLog(@"%@",response);
            NSMutableArray *array = @[].mutableCopy;
            NSNumber *status = response[@"status"];
            if (status.integerValue == 1) {
                [_loadHud hideAnimated:YES];
                NSArray *data = response[@"data"];
                for (NSDictionary *dic in data) {
                    SupermarketAddressModel *model = [NSDictionary getAddressDataWithDic:dic];
                    [array addObject:model];
                }
                self.data = array;
                [self.tableView.mj_header endRefreshing];
            }
        } failure:^(NSError *err) {
            
        }];

    } else {
        [KLHttpTool getSupermarketUserAddressListWithDivCode:@"0" success:^(id response) {
            NSLog(@"%@",response);
            NSMutableArray *array = @[].mutableCopy;
            NSNumber *status = response[@"status"];
            if (status.integerValue == 1) {
                [_loadHud hideAnimated:YES];
                NSArray *data = response[@"data"];
                for (NSDictionary *dic in data) {
                    SupermarketAddressModel *model = [NSDictionary getAddressDataWithDic:dic];
                    [array addObject:model];
                }
                self.data = array;
                [self.tableView.mj_header endRefreshing];
            }
        } failure:^(NSError *err) {
            
        }];

    }
}

- (void)setNavi{
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"shengqing_back"] style:UIBarButtonItemStylePlain target:self action:@selector(popController)];
    back.tintColor = [UIColor blackColor];
    self.navigationItem.leftBarButtonItem = back;
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 30)];
    titleLab.text = @"我的地址";
    titleLab.textColor = [UIColor blackColor];
    titleLab.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titleLab;

}

- (void)popController{
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)createTableView{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, APPScreenWidth, self.view.frame.size.height ) style:UITableViewStyleGrouped];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
    self.tableView.delegate = self;
    self.tableView.dataSource  = self;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requestData];
    }];
    
    [self.view addSubview:self.tableView];
    
    if (_isPageView) {
        self.tableView.frame = CGRectMake(0, 0, APPScreenWidth, self.view.frame.size.height - 55);
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 100, 0);
    }
    
}

- (void)createBottom{
    UIButton *button =[[UIButton alloc]initWithFrame:CGRectMake(15, self.view.frame.size.height - 45, APPScreenWidth - 30, 35)];
    button.backgroundColor = RGB(23, 206, 116);
    if (_isPageView) {
        button.frame = CGRectMake(15, self.view.frame.size.height - 45 - 110, APPScreenWidth - 30, 35);
    }
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitle:@"+ 新增地址" forState:UIControlStateNormal];
    button.layer.cornerRadius = 2.0f;
    [button addTarget:self action:@selector(addNewAddress:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

#pragma mark- -UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    SupermarketAddressModel *model = self.data[indexPath.section];
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        UILabel *nameLab =[[UILabel alloc]initWithFrame:CGRectMake(15, 10 , 100, 30)];
        nameLab.font = [UIFont systemFontOfSize:14];
        nameLab.textColor = [UIColor darkGrayColor];
        nameLab.text = [NSString stringWithFormat:@"%@",model.realname];
        [cell.contentView addSubview:nameLab];
        
        UILabel *telephoneLab =[[UILabel alloc]initWithFrame:CGRectMake(APPScreenWidth - 115, 10 , 100, 30)];
        telephoneLab.font = [UIFont systemFontOfSize:14];
        telephoneLab.textColor = [UIColor darkGrayColor];
        telephoneLab.text = model.mobile;
        telephoneLab.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:telephoneLab];
        
        UIView *maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPScreenWidth, 35)];
        maskView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.7];
        maskView.hidden = YES;
//        [cell.contentView addSubview:maskView];
        if (model.hasDelivery.integerValue == 0) {
            maskView.hidden = NO;
        }
        
    }else if (indexPath.row == 1){
        
        UILabel *addressLab =[[UILabel alloc]initWithFrame:CGRectMake(15, 0 , APPScreenWidth - 30 , CGRectGetHeight(cell.frame))];
        addressLab.textColor = [UIColor darkGrayColor];
        addressLab.font = [UIFont systemFontOfSize:14];
        addressLab.text = [NSString stringWithFormat:@"%@%@",model.location,model.address];
        
        addressLab.numberOfLines = 2;
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 43, APPScreenWidth, 1)];
        line.backgroundColor = RGB(241, 242, 243);
        
        [cell.contentView addSubview:line];
        [cell.contentView addSubview:addressLab];
        
        CGFloat maskWidth = [UILabel getWidthWithTitle:@"地址超出配送范围" font:[UIFont systemFontOfSize:12]];
        
        UILabel *maskLabel = [UILabel createLabelWithFrame:CGRectMake(APPScreenWidth - maskWidth - 10, 44 - 12, maskWidth, 12) textColor:[UIColor redColor] font:[UIFont systemFontOfSize:12] textAlignment:NSTextAlignmentCenter text:@"地址超出配送范围"];
        maskLabel.backgroundColor = [UIColor colorWithWhite:1 alpha:0.7];
        maskLabel.hidden = YES;
        
        UIImageView *maskImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(maskLabel.frame)-15, maskLabel.frame.origin.y, 12, 12)];
        maskImageView.image = [UIImage imageNamed:@"icon_warning"];
        maskImageView.hidden = YES;
        maskImageView.contentMode = UIViewContentModeScaleAspectFit;
        [cell.contentView addSubview:maskImageView];
        
        [cell.contentView addSubview:maskLabel];
        if (model.hasDelivery.integerValue == 0) {
            maskLabel.hidden = NO;
            maskImageView.hidden = NO;
        }
        
    }else if (indexPath.row == 2){
        
        UIButton *defaultBtn = [[UIButton alloc]initWithFrame:CGRectMake(15,5, 100 ,20)];
        
        [defaultBtn addTarget:self action:@selector(DefaultBtnaction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:defaultBtn];
        
        UIImageView *imagview1;
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 120, 20)];
        if (model.isdefault.integerValue == 1) {
            
            defaultBtn.selected = !defaultBtn.selected;
            imagview1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cart_selected_btn"]];
            title.text = @"默认地址";
            title.textColor = RGB(23, 206, 116);
            
        }else{
            
            imagview1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cart_unSelect_btn"]];
            title.text = @"设置为默认地址";
            title.textColor = [UIColor grayColor];
            
        }
        
        if (model.isdefault.integerValue == 1) {
            defaultBtn.userInteractionEnabled = NO;
        } else {
            defaultBtn.userInteractionEnabled = YES;
        }
        
        
        imagview1.tag = 1002;
        imagview1.frame = CGRectMake(0, 3, 14,14);
        [defaultBtn addSubview:imagview1];
        
        title.tag = 1001;
        title.font = [UIFont systemFontOfSize:12];
        [defaultBtn addSubview:title];
        
        
        
        UIButton *deleBtn = [[UIButton alloc]initWithFrame:CGRectMake(APPScreenWidth - 60, 5, 60 ,20)];
        [cell.contentView addSubview:deleBtn];
        [deleBtn addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
        UIImageView *imagview2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"deletebtn"]];
        imagview2.frame = CGRectMake(0, 3, 14,14);
        [deleBtn addSubview:imagview2];
        
        UILabel *title2 = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 40, 20)];
        title2.text = @"删除";
        title2.font = [UIFont systemFontOfSize:12];
        title2.textColor = [UIColor grayColor];
        [deleBtn addSubview:title2];
        
        
        UIButton *editBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMinX(deleBtn.frame) - 65, 5, 60 ,20)];
        [editBtn addTarget:self action:@selector(editBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        editBtn.tag = indexPath.section;
        [cell.contentView addSubview:editBtn];
        
        UIImageView *imagview3 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"editbtn"]];
        imagview3.frame = CGRectMake(0, 3, 14,14);
        [editBtn addSubview:imagview3];
        
        UILabel *title3 = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 40, 20)];
        title3.text = @"编辑";
        title3.font = [UIFont systemFontOfSize:12];
        title3.textColor = [UIColor grayColor];
        [editBtn addSubview:title3];
        
        UIView *maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPScreenWidth, 30)];
        maskView.hidden = YES;
        maskView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.7];
//        [cell.contentView addSubview:maskView];
        if (model.hasDelivery.integerValue == 0) {
            maskView.hidden = NO;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.delegate respondsToSelector:@selector(selectedAddress:)]) {
        SupermarketAddressModel *model = self.data[indexPath.section];
        if (model.hasDelivery.integerValue == 1) {
            [_delegate selectedAddress:model];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [MBProgressHUD hideAfterDelayWithView:KEYWINDOW interval:2.0f text:@"地址超出配送范围"];
        }
       
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 1) {
        return 44;
    } else if (indexPath.row == 0) {
        return 35;
    }
    return 30;
    
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

- (void)setData:(NSArray *)data{
    _data = data;
    [self.tableView reloadData];
}

//设置默认地址
- (void)DefaultBtnaction:(UIButton *)sender{
    
    sender.selected = !sender.selected;
    UILabel*label1 = (UILabel*)[sender viewWithTag:1001];
    UIImageView*imageview = (UIImageView*)[sender viewWithTag:1002];
    if (sender.selected) {
        
        label1.text = @"默认地址";
        label1.textColor = RGB(23, 206, 116);
        imageview.image = [UIImage imageNamed:@"cart_selected_btn"];
        
    }else{
        
        label1.text = @"设置为默认地址";
        label1.textColor = [UIColor grayColor];
        imageview.image = [UIImage imageNamed:@"cart_unSelect_btn"];
    }
    
    UIView * view = sender.superview.superview;
    if ([view isKindOfClass:[UITableViewCell class]]) {
        UITableViewCell *cell = (UITableViewCell *)view;
        NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
        NSInteger section = indexPath.section;
        
        for (SupermarketAddressModel *model in _data) {
            model.isdefault = @0;
        }
        
        SupermarketAddressModel *model = _data[section];
        model.isdefault = @1;
        
        [KLHttpTool setSupermarketDefaultAddressWithAddressID:model.addressID.stringValue success:^(id response) {
            NSNumber *status = response[@"status"];
            if (status.integerValue == 1) {
                [_tableView reloadData];
                [MBProgressHUD hideAfterDelayWithView:self.view interval:2 text:response[@"message"]];
            }
            
        } failure:^(NSError *err) {
            
        }];
    }
}

- (void)editBtnAction:(UIButton *)sender{
    
//    SupermarketEditAddressController *EditVC = [[SupermarketEditAddressController alloc]init];
//    EditVC.model = self.data[sender.tag];
//    [self.navigationController pushViewController:EditVC animated:YES];
    SupermarketNewAddessController *newAddress = [[SupermarketNewAddessController alloc] init];
    newAddress.addressModel = self.data[sender.tag];
    if (_isPageView) {
        newAddress.isMyAddress = NO;
    } else {
        newAddress.isMyAddress = YES;
    }
    [self.navigationController pushViewController:newAddress animated:YES];
    
    if ([self.delegate respondsToSelector:@selector(editAddressButtonPressed:)]) {
        [self.delegate editAddressButtonPressed:self.data[sender.tag]];
    }
}


- (void)addNewAddress:(UIButton*)sender{
//    SupermarketEditAddressController *EditVC = [[SupermarketEditAddressController alloc]init];
//    [self.navigationController pushViewController:EditVC animated:YES];
    SupermarketNewAddessController *newAddress = [[SupermarketNewAddessController alloc] init];
    if (_isPageView) {
        newAddress.isMyAddress = NO;
    } else {
        newAddress.isMyAddress = YES;
    }

    [self.navigationController pushViewController:newAddress animated:YES];
    
    if ([self.delegate respondsToSelector:@selector(addNewAddressButtonPreessed)]) {
        [_delegate addNewAddressButtonPreessed];
    }
}

- (void)deleteAction:(UIButton *)sender {
    UIAlertController *deleteAlert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确认删除该地址?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIView *view = sender.superview.superview;
        if ([view isKindOfClass:[UITableViewCell class]]) {
            UITableViewCell *cell = (UITableViewCell *)view;
            NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
            SupermarketAddressModel *model = _data[indexPath.section];
            
            [KLHttpTool deleteSupermarketAddressWithAddressID:model.addressID.stringValue success:^(id response) {
                NSNumber *status = response[@"status"];
                if (status.integerValue == 1) {
                    if ([_data containsObject:model]) {
                        [_data removeObject:model];
                    }
                    [_tableView reloadData];
                    [MBProgressHUD hideAfterDelayWithView:self.view interval:2 text:response[@"message"]];
                }
            } failure:^(NSError *err) {
                
            }];
        }
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [deleteAlert addAction:ok];
    [deleteAlert addAction:cancel];
    
    [self presentViewController:deleteAlert animated:YES completion:nil];
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
