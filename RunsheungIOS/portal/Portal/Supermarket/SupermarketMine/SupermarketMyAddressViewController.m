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
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>


@interface SupermarketMyAddressViewController ()<UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource>

@property (nonatomic, strong)MBProgressHUD *loadHud;//加载地址数据是的提示
@property (nonatomic, assign)NSInteger offset;
@property (nonatomic, strong)UIButton *bottomBtn;

@end

@implementation SupermarketMyAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(239, 239, 244);
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(requestData) name:RefreshMyAddressListNotification object:nil];
    [self commonInit];
//    [self createData];
    
    [self setNavi];
    [self createTableView];
    [self createBottom];
    
    [self requestData];
    // Do any additional setup after loading the view.
}

-(void)commonInit {
    self.offset = 1;
    
}


- (void)requestData {
    [self showLoading];
    __weak typeof(self) weakself = self;
    [KLHttpTool getSupermarketUserAddressListWithOffset:[NSString stringWithFormat:@"%ld", (long)self.offset] success:^(id response) {
        [weakself hideLoading];
        NSNumber *status = response[@"status"];
        if (status.integerValue == 1) {
            NSMutableArray *array = [NSMutableArray array];
            NSArray *data = response[@"bcm100ts"];
            for (NSDictionary *dic in data) {
                MarketModel *model = [[MarketModel alloc]initWithDic:dic];
                [array addObject:model];
            }
            self.data = array;
            [self.tableView.mj_header endRefreshing];
        }
    } failure:^(NSError *err) {
        [weakself hideLoading];
    }];
}

- (void)setNavi{
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"shengqing_back"] style:UIBarButtonItemStylePlain target:self action:@selector(popController)];
    back.tintColor = [UIColor blackColor];
    self.navigationItem.leftBarButtonItem = back;
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 30)];
    titleLab.text = @"나의 주소";
    titleLab.textColor = [UIColor blackColor];
    titleLab.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titleLab;

}

- (void)popController{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createTableView{
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource  = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.estimatedRowHeight = 20;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.emptyDataSetSource = self;
    self.tableView.mj_header = [MJRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)createBottom{
    self.bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.bottomBtn.backgroundColor = RGB(23, 206, 116);
    [self.bottomBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.bottomBtn setTitle:@"+ 주소 추가" forState:UIControlStateNormal];
    self.bottomBtn.layer.cornerRadius = 2.0f;
    [self.bottomBtn addTarget:self action:@selector(addNewAddress:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.bottomBtn];
}

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (@available(iOS 11.0, *)) {
        CGRect safeArea = self.view.safeAreaLayoutGuide.layoutFrame;
        CGFloat y = CGRectGetMaxY(safeArea);
        self.bottomBtn.frame = CGRectMake(15, y - 45 , self.view.frame.size.width - 30, 35);
    } else {
        self.bottomBtn.frame = CGRectMake(15, self.view.frame.size.height - self.bottomLayoutGuide.length - 45, self.view.frame.size.width - 30, 35);
    }
}

#pragma mark- -UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MarketModel *model = self.data[indexPath.section];
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        UILabel *nameLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 10 , 100, 30)];
        nameLab.font = [UIFont systemFontOfSize:14];
        nameLab.textColor = [UIColor darkGrayColor];
        nameLab.text = [NSString stringWithFormat:@"%@", model.delivery_name];
        [cell.contentView addSubview:nameLab];
        
        UILabel *telephoneLab =[[UILabel alloc]initWithFrame:CGRectMake(APPScreenWidth - 115, 10 , 100, 30)];
        telephoneLab.font = [UIFont systemFontOfSize:14];
        telephoneLab.textColor = [UIColor darkGrayColor];
        telephoneLab.text = model.mobilepho;
        telephoneLab.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:telephoneLab];
        
        UIView *maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPScreenWidth, 35)];
        maskView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.7];
        maskView.hidden = YES;
    
    }else if (indexPath.row == 1){
        
        UILabel *addressLab =[[UILabel alloc]initWithFrame:CGRectMake(15, 0 , APPScreenWidth - 30 , CGRectGetHeight(cell.frame))];
        addressLab.textColor = [UIColor darkGrayColor];
        addressLab.font = [UIFont systemFontOfSize:14];
        addressLab.text = model.to_address;
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

    }else if (indexPath.row == 2){
        
        UIButton *defaultBtn = [[UIButton alloc]initWithFrame:CGRectMake(15,5, 100 ,20)];
        
        [defaultBtn addTarget:self action:@selector(DefaultBtnaction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:defaultBtn];
        
        UIImageView *imagview1;
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 120, 20)];
        if ([model.default_add isEqualToString:@"True"]) {
            defaultBtn.selected = !defaultBtn.selected;
            imagview1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cart_selected_btn"]];
            title.text = @"기본 배송지";
            title.textColor = RGB(23, 206, 116);
        }else{
            imagview1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cart_unSelect_btn"]];
            title.text = @"디폴트 주소 설정";
            title.textColor = [UIColor grayColor];
        }
        
        if ([model.default_add isEqualToString:@"True"]) {
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
        title2.text = @"삭제";
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
        title3.text = @"편집";
        title3.font = [UIFont systemFontOfSize:12];
        title3.textColor = [UIColor grayColor];
        [editBtn addSubview:title3];
        
        UIView *maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPScreenWidth, 30)];
        maskView.hidden = YES;
        maskView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.7];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.delegate respondsToSelector:@selector(selectedAddress:)]) {
        MarketModel *model = self.data[indexPath.section];
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(selectedAddress:)]) {
            [self.delegate selectedAddress:model];
            [self.navigationController popViewControllerAnimated:YES];
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


-(void)setData:(NSMutableArray *)data {
    _data = data;
    [self.tableView reloadData];
}

//设置默认地址
- (void)DefaultBtnaction:(UIButton *)sender{
    
    sender.selected = !sender.selected;
    UILabel*label1 = (UILabel*)[sender viewWithTag:1001];
    UIImageView*imageview = (UIImageView*)[sender viewWithTag:1002];
    if (sender.selected) {
        
        label1.text = @"기본 배송지";
        label1.textColor = RGB(23, 206, 116);
        imageview.image = [UIImage imageNamed:@"cart_selected_btn"];
        
    }else{
        
        label1.text = @"디폴트 주소 설정";
        label1.textColor = [UIColor grayColor];
        imageview.image = [UIImage imageNamed:@"cart_unSelect_btn"];
    }
    
    UIView * view = sender.superview.superview;
    if ([view isKindOfClass:[UITableViewCell class]]) {
        UITableViewCell *cell = (UITableViewCell *)view;
        NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
        NSInteger section = indexPath.section;
        
        for (MarketModel *model in self.data) {
            model.default_add = @"No";
        }
        MarketModel *model = self.data[section];
        model.default_add = @"True";
        

        [KLHttpTool setSupermarketDefaultAddressWithAddressID:model.seq_num success:^(id response) {
            
        } failure:^(NSError *err) {
            
        }];
        
        [self.tableView reloadData];
    }
}

- (void)editBtnAction:(UIButton *)sender{
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
    UIAlertController *deleteAlert = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Are you sure to delete the place?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIView *view = sender.superview.superview;
        if ([view isKindOfClass:[UITableViewCell class]]) {
            UITableViewCell *cell = (UITableViewCell *)view;
            NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
            MarketModel *model = self.data[indexPath.section];
            [self showLoading];
            [KLHttpTool deleteSuperMarketAddressWithSeqNum:model.seq_num success:^(id response) {
                [self hideLoading];
                NSString *status = response[@"status"];
                if ([status isEqualToString:@"1"]) {
                    if ([self.data containsObject:model]) {
                          [self.data removeObject:model];
                        }
                        [self.tableView reloadData];
                   }
                } failure:^(NSError *err) {
                
            }];
         }
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancle" style:UIAlertActionStyleDefault handler:nil];
    [deleteAlert addAction:ok];
    [deleteAlert addAction:cancel];
    
    [self presentViewController:deleteAlert animated:YES completion:nil];
}

-(NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    return [[NSAttributedString alloc] initWithString:@"Add a place"];
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
