//
//  SupermarketNewAddessController.m
//  Portal
//
//  Created by ifox on 2016/12/15.
//  Copyright © 2016年 linpeng. All rights reserved.
//

#import "SupermarketNewAddessController.h"
#import "UILabel+WidthAndHeight.h"
#import "STPickerSingle.h"
#import "STPickerArea.h"
#import <CoreLocation/CoreLocation.h>
#import <AFNetworking/AFNetworking.h>

typedef void (^Coordinate2DBlock)(CLLocationCoordinate2D coordinate);

@interface SupermarketNewAddessController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, STPickerAreaDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSString *region;
@property (nonatomic, assign) NSString *postcd;

@end

@implementation SupermarketNewAddessController {
    UILabel * _addressLabel;
    UILabel * _msg;
    
    UITextField * _nameField;
    UITextField * _phoneField;
    UITextField * _haoaoField;
    UITextField * _gidField;
    NSString    * _isDefualt;
    UIImageView * _defualtIcon;
    
    CGFloat _latitude;
    CGFloat _longtitude;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (!_isMyAddress) {
        self.automaticallyAdjustsScrollViewInsets = YES;
        self.navigationController.navigationBar.translucent = NO;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.addressModel == nil) {
        self.title = NSLocalizedString(@"SMAdressAddTitle", nil);
    } else {
        self.title = NSLocalizedString(@"SMAdressEditTitle", nil);
    }
    self.view.backgroundColor = RGB(241, 242, 243);
    
    [self createTableView];
    
    UIButton *saveAddress = [UIButton buttonWithType:UIButtonTypeCustom];
    saveAddress.frame = CGRectMake(15, self.view.frame.size.height - 15 - 40, APPScreenWidth - 30, 40);
    saveAddress.backgroundColor = RGB(0, 207, 121);
    [saveAddress setTitle:NSLocalizedString(@"SMAdressSaveTitle", nil) forState:UIControlStateNormal];
    [saveAddress addTarget:self action:@selector(saveAddress)];
    saveAddress.layer.cornerRadius = 2.0f;
    [saveAddress setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:saveAddress];
    // Do any additional setup after loading the view.
}

- (void)createTableView {
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = RGB(241, 242, 243);
    [self.view addSubview:_tableView];
    
    UITapGestureRecognizer *dismissKeyboard = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissBoard)];
    
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPScreenWidth, 200)];
    footer.backgroundColor = RGB(241, 242, 243);
    _tableView.tableFooterView = footer;
    
    [footer addGestureRecognizer:dismissKeyboard];
}



-(void)setAddressModel:(MarketModel *)addressModel {
    _addressModel = addressModel;
    _region = addressModel.zip_name;
     
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 && indexPath.row == 0) {
        if (self.region != nil) {
          CGFloat width = [UILabel getWidthWithTitle:NSLocalizedString(@"SMAdressLocation", nil) font:[UIFont systemFontOfSize:15]];
          CGFloat height = [UILabel getHeightByWidth:APPScreenWidth - width - 10 title:self.region font:[UIFont systemFontOfSize:15]];
          return height + 20;
        }
    }
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = NSLocalizedString(@"SMAdressReceiveName", nil);
            CGFloat width = [UILabel getWidthWithTitle:cell.textLabel.text font:cell.textLabel.font];
            _nameField = [[UITextField alloc] initWithFrame:CGRectMake(width + 40, CGRectGetHeight(cell.contentView.frame)/2 - 15, APPScreenWidth - width - 10 , 30)];
            _nameField.placeholder = NSLocalizedString(@"SMAdressReceiveNamePlaceHolder", nil);
            _nameField.text = _addressModel.delivery_name;
            _nameField.font = [UIFont systemFontOfSize:15];
            _nameField.textColor = [UIColor darkGrayColor];
            [cell.contentView addSubview:_nameField];
    
        } else if (indexPath.row == 1) {
            cell.textLabel.text = NSLocalizedString(@"SMAdressPhone", nil);
            CGFloat width = [UILabel getWidthWithTitle:cell.textLabel.text font:cell.textLabel.font];
            
            _phoneField = [[UITextField alloc]initWithFrame:CGRectMake(width + 25, CGRectGetHeight(cell.contentView.frame)/2 - 15, APPScreenWidth - width - 10, 30)];
            _phoneField.textColor = [UIColor darkGrayColor];
            _phoneField.keyboardType = UIKeyboardTypePhonePad;
            _phoneField.placeholder = NSLocalizedString(@"SMAdressPhonePlaceHolder", nil);
            _phoneField.text = _addressModel.mobilepho;
            _phoneField.font =[UIFont systemFontOfSize:15];
            [cell.contentView addSubview:_phoneField];

        } else {
            cell.textLabel.text = NSLocalizedString(@"SMAdressSetDefault", nil);
            UIImageView *defaultAddressIcon = [[UIImageView alloc] initWithFrame:CGRectMake(APPScreenWidth - 35, 15, 20, 20)];
            defaultAddressIcon.image = [UIImage imageNamed:@"icon_selected-s"];
            [cell.contentView addSubview:defaultAddressIcon];
            
            _defualtIcon = defaultAddressIcon;
            if ([_addressModel.default_add isEqualToString:@"1"]) {
                _defualtIcon.hidden = NO;
            }else {
                _defualtIcon.hidden = YES;
            }
       }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.textLabel.text = NSLocalizedString(@"SMAdressLocation", nil);
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
          
            
            CGFloat width = [UILabel getWidthWithTitle:cell.textLabel.text font:cell.textLabel.font];
            
            UILabel *address = [[UILabel alloc] init];
            address.numberOfLines = 0;
            address.textColor = [UIColor darkGrayColor];
            address.font = [UIFont systemFontOfSize:15];
            _addressLabel = address;
            _addressLabel.text = self.region;
            [cell.contentView addSubview:address];
            [address mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(cell.contentView);
                make.leading.equalTo(cell.contentView).offset(width + 25);
                make.width.equalTo(@(APPScreenWidth - width - 40));
            }];
            
        } else if (indexPath.row == 1) {
            cell.textLabel.text = NSLocalizedString(@"SMAdressZipCode", nil);
            CGFloat width = [UILabel getWidthWithTitle:cell.textLabel.text font:cell.textLabel.font];
            
            _gidField = [[UITextField alloc] initWithFrame:CGRectMake(width + 25, CGRectGetHeight(cell.contentView.frame)/2 - 15, APPScreenWidth - width - 45, 30)];
            _gidField.placeholder = NSLocalizedString(@"SMAdressZipCode", nil);
            _gidField.textColor = [UIColor darkGrayColor];
            _gidField.font = [UIFont systemFontOfSize:15];
            _gidField.text = self.postcd;
            [cell.contentView addSubview: _gidField];
            
        } else if (indexPath.row == 2) {
            cell.textLabel.text = NSLocalizedString(@"SMAdressDetail", nil);
            CGFloat width = [UILabel getWidthWithTitle:cell.textLabel.text font:cell.textLabel.font];
            _haoaoField = [[UITextField alloc]initWithFrame:CGRectMake(width + 25, CGRectGetHeight(cell.contentView.frame)/2 - 15, APPScreenWidth - width - 45, 30)];
            _haoaoField.placeholder = NSLocalizedString(@"SMAdressDetailPlaceHolder", nil);
            _haoaoField.font =[UIFont systemFontOfSize:15];
            _haoaoField.textColor = [UIColor darkGrayColor];
            _haoaoField.delegate = self;
            [cell.contentView addSubview:_haoaoField];
            if (_addressModel.to_address.length > 0) {
                _haoaoField.text = _addressModel.to_address;
            }
        } else {
            
        }
    }
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1 && indexPath.row == 0) {
        SearchKoreaAddress *search = [[SearchKoreaAddress alloc] init];
     
        search.selectAction = ^(KoreaPlaceModel * dic) {
//            _addressLabel.hidden = NO;
//            _msg.hidden = YES;
//             _gidField.text = dic[@"postcd"];
//             _addressLabel.text = dic[@"address"];
            self.region = dic.address;
            self.postcd = dic.postcd;
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
        };
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:search];
        [self presentViewController:nav animated:YES completion:nil];
    } else if (indexPath.section == 0 && indexPath.row == 2) {
        _defualtIcon.hidden = !_defualtIcon.hidden;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self dismissBoard];
    return YES;
}


- (void)pickerArea:(STPickerArea *)pickerArea province:(NSString *)province city:(NSString *)city area:(NSString *)area {
    _addressLabel.hidden = NO;
    _msg.hidden = YES;
    _addressLabel.text = [NSString stringWithFormat:@"%@%@%@",province,city,area];
    
    if (area.length == 0) {
        if ([province containsString:@"市"]) {
            NSMutableString *provinceName = [[NSMutableString alloc] initWithString:province];
            province = [provinceName substringWithRange:NSMakeRange(0, provinceName.length - 1)];
        }
        city = province;
    }
    
    _gidField.text = @"";
    [KLHttpTool checkAddressZipcodeWithProviceName:province cityName:city success:^(id response) {
     
        NSNumber *status = response[@"status"];
        if (status.integerValue == 1) {
            id zipCode = response[@"zip_code"];
            _gidField.text = [zipCode isKindOfClass:[NSString class]]?zipCode:@"000000";

            
        } else {
            [self showMessage:response[@"msg"] interval:2 completionAction:nil];
        }
    } failure:^(NSError *err) {
        
    }];
}

- (void)dismissBoard {
    [_nameField resignFirstResponder];
    [_phoneField resignFirstResponder];
    [_haoaoField resignFirstResponder];
}

- (void)saveAddress {
    if (_nameField.text.length == 0) {
        [self showMessage:NSLocalizedString(@"SMAdressNoNameMsg", nil) interval:1 completionAction:nil];
        return ;
    }else if (_phoneField.text.length == 0){
        [self showMessage:NSLocalizedString(@"SMAdressNoPhoneMsg", nil) interval:1 completionAction:nil];
        return ;
    }else if (_addressLabel.text.length == 0){
        [self showMessage:NSLocalizedString(@"SMAdressNoLocationMsg", nil) interval:1 completionAction:nil];
        return ;
    }else if(_haoaoField.text.length == 0){
        [self showMessage:NSLocalizedString(@"SMAdressNoAdressMsg", nil) interval:1 completionAction:nil];
        return ;
    }
    
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    [geoCoder geocodeAddressString:[NSString stringWithFormat:@"%@%@",_addressLabel.text,_haoaoField.text] completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {

        if (placemarks.count != 0) {
            CLPlacemark *placeMark = [placemarks firstObject];
            _longtitude = placeMark.location.coordinate.longitude;
            _latitude = placeMark.location.coordinate.latitude;
        } else {
            _longtitude = 0;
            _latitude = 0;
        }
        [self saveAddressAction];
    }];
    
    
}

- (void)saveAddressAction {
    
    if (self.addressModel == nil) {
        BOOL isDefault = NO;
        if (_defualtIcon.hidden == NO) {
            isDefault = YES;
        }
        
        NSString *zipCode = _gidField.text;
        if (zipCode.length == 0) {
           [self showMessage:NSLocalizedString(@"SMAdressNoZipCodeMsg", nil) interval:2 completionAction:nil];
            return;
        }
        [self showLoading];
        [KLHttpTool superMarketAddNewAddressWithDeliveryName:_nameField.text
                                                     Address:_haoaoField.text
                                                     zipcode:zipCode
                                                     zipName:_addressLabel.text
                                                   mobilepho:_phoneField.text
                                                  defaultAdd:isDefault ? @"1":@"0"
                                                    latitude:[NSString stringWithFormat:@"%f", _latitude]
                                                   longitude:[NSString stringWithFormat:@"%f", _longtitude]
                                                     success:^(id response) {
                                                         [self hideLoading];
                                                         NSString *status = response[@"status"];
                                                         if ([status isEqualToString:@"1"]) {
                                                             [self showMessage:response[@"message"] interval:1.5 completionAction:^{}];
                                                             [[NSNotificationCenter defaultCenter] postNotificationName:RefreshMyAddressListNotification object:nil];
                                                             [self.navigationController popViewControllerAnimated:YES];
                                                         } else {
                                                             [self showMessage:response[@"message"] interval:1.5 completionAction:nil];
                                                         }
                                                      }
                                                     failure:^(NSError *err) {
                                                         [self hideLoading];
                                                     }];

    } else {
        NSString *zipCode = _gidField.text;
        if (zipCode.length == 0) {
            [self showMessage:NSLocalizedString(@"SMAdressNoZipCodeMsg", nil) interval:1 completionAction:nil];
            return;
        }
        
        [self showLoading];
        [KLHttpTool supermaketEditAddresswWithRealName:_nameField.text location:_addressLabel.text address:_haoaoField.text seqNum:self.addressModel.seq_num mobilepho:_phoneField.text zipCode:zipCode zipName:_addressLabel.text defaultAdd: (!_defualtIcon.hidden ? @"1":@"0") success:^(id response) {
                [self hideLoading];
                NSNumber *status = response[@"status"];
                if (status.integerValue == 1) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:RefreshMyAddressListNotification object:nil];
                    [self.navigationController popViewControllerAnimated:YES];
                } else {
                    [self showMessage:response[@"message"] interval:1.5 completionAction:nil];
                }
            } failure:^(NSError *err) {
                    [self hideLoading];
            }];
    
       }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
