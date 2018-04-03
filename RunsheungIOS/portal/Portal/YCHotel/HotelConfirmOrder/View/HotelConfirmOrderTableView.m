//
//  HotelConfirmOrderTableView.m
//  Portal
//
//  Created by ifox on 2017/4/11.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "HotelConfirmOrderTableView.h"
#import "HotelConfirmTableViewCell.h"
#import "HotelConfirmOrderChooseView.h"
#import "HotelConfirmOrderEditTableViewCell.h"
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>

#import "UILabel+CreateLabel.h"
#import "HotelReseveCustomerModel.h"
#import "HotelRetainTimeModel.h"

@interface HotelConfirmOrderTableView ()<UITableViewDelegate, UITableViewDataSource,CNContactPickerDelegate,HotelConfirmOrderChooseViewDelegate,UITextFieldDelegate>

@property(nonatomic, strong) HotelConfirmOrderChooseView *chooseTimeView;
@property(nonatomic, strong) HotelConfirmOrderChooseView *chooseNumbersView;
@property(nonatomic, strong) NSMutableArray<HotelReseveCustomerModel *> *reseveCustomers;
@property(nonatomic, strong) UITextField *phoneField;
@property(nonatomic, strong) NSIndexPath *contactIndexPath;

@property(nonatomic, strong) UISwitch *switchButn;

@property(nonatomic, strong) UILabel *hotelNameLabel;
@property(nonatomic, strong) UILabel *roomTypeNameLabel;
@property(nonatomic, strong) UILabel *timeLabel;

@property(nonatomic, copy) NSString *rooms;//房间数

@end

@implementation HotelConfirmOrderTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self registerCell];
        _roomNumbers = 0;
        _reseveCustomers = @[].mutableCopy;
        _usePoint = NO;
        
        HotelReseveCustomerModel *model = [[HotelReseveCustomerModel alloc] init];
        [_reseveCustomers addObject:model];
        
        _chooseTimeView = [[HotelConfirmOrderChooseView alloc] initWithFrame:CGRectMake(0, 0, APPScreenWidth, APPScreenHeight)];
//        _chooseTimeView.dataSource = @[@"18:00之前",@"20:00之前",@"22:00之前",@"00:00之前",@"次日凌晨6:00之前"];
        _chooseTimeView.title = NSLocalizedString(@"HotelConfirmChooseTime", nil);
        _chooseTimeView.delegate = self;
        
        _chooseNumbersView = [[HotelConfirmOrderChooseView alloc] initWithFrame:CGRectMake(0, 0, APPScreenWidth, APPScreenHeight)];
        _chooseNumbersView.dataSource = @[NSLocalizedString(@"HotelConfirmRoomNumber_1", nil),NSLocalizedString(@"HotelConfirmRoomNumber_2", nil),NSLocalizedString(@"HotelConfirmRoomNumber_3", nil),NSLocalizedString(@"HotelConfirmRoomNumber_4", nil),NSLocalizedString(@"HotelConfirmRoomNumber_5", nil),NSLocalizedString(@"HotelConfirmRoomNumber_6", nil),NSLocalizedString(@"HotelConfirmRoomNumber_7", nil),NSLocalizedString(@"HotelConfirmRoomNumber_8", nil),NSLocalizedString(@"HotelConfirmRoomNumber_9", nil),NSLocalizedString(@"HotelConfirmRoomNumber_10", nil)];
        _chooseNumbersView.title = NSLocalizedString(@"HotelConfirmChooseRoomNumbers", nil);
//        _chooseTimeView.defaultChoose = YES;
        _chooseNumbersView.delegate = self;
        
//        _rooms = @"1间";
        
        [self createFooterHeader];
        self.dataSource = self;
        self.delegate = self;
    }
    return self;
}

- (void)createFooterHeader {
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPScreenWidth, 200)];
    UILabel *msg = [UILabel createLabelWithFrame:CGRectMake(10, 10, 200, 25) textColor:HotelBlackColor font:[UIFont systemFontOfSize:15] textAlignment:NSTextAlignmentLeft text:NSLocalizedString(@"HotelConfirmMsg_0", nil)];
    [footer addSubview:msg];
    UILabel *msgInfo = [UILabel createLabelWithFrame:CGRectMake(msg.frame.origin.x, CGRectGetMaxY(msg.frame), APPScreenWidth, 20) textColor:HotelLightGrayColor font:[UIFont systemFontOfSize:12] textAlignment:NSTextAlignmentLeft text:NSLocalizedString(@"HotelConfirmMsg_1", nil)];
    [footer addSubview:msgInfo];
    
    UILabel *cancel = [UILabel createLabelWithFrame:CGRectMake(msg.frame.origin.x, CGRectGetMaxY(msgInfo.frame)+10, 200, msg.frame.size.height) textColor:msg.textColor font:msg.font textAlignment:NSTextAlignmentLeft text:NSLocalizedString(@"HotelConfirmMsg_2", nil)];
    [footer addSubview:cancel];
    UILabel *cancelInfo = [UILabel createLabelWithFrame:CGRectMake(msg.frame.origin.x, CGRectGetMaxY(cancel.frame), APPScreenWidth, msgInfo.frame.size.height) textColor:msgInfo.textColor font:msgInfo.font textAlignment:NSTextAlignmentLeft text:NSLocalizedString(@"HotelConfirmMsg_3", nil)];
    [footer addSubview:cancelInfo];
    
    self.tableFooterView = footer;
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPScreenWidth, 200)];
    
    UIView *upView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, APPScreenWidth - 20, 120)];
    upView.backgroundColor = [UIColor whiteColor];
    upView.layer.cornerRadius = 5.0f;
    [header addSubview:upView];
    
    UILabel *hotelTitle = [UILabel createLabelWithFrame:CGRectMake(10, 0, APPScreenWidth, 40) textColor:HotelBlackColor font:[UIFont systemFontOfSize:14] textAlignment:NSTextAlignmentLeft text:self.hotelName];
    self.hotelNameLabel = hotelTitle;
    [upView addSubview:hotelTitle];
    
    UILabel *time = [UILabel createLabelWithFrame:CGRectMake(hotelTitle.frame.origin.x, CGRectGetMaxY(hotelTitle.frame), APPScreenWidth, 20) textColor:HotelGrayColor font:[UIFont systemFontOfSize:11] textAlignment:NSTextAlignmentLeft text:@"入住11月11日(今天) 离店11月12日(明天) 共1晚"];
    self.timeLabel = time;
    [upView addSubview:time];
    
    UILabel *roomType = [UILabel createLabelWithFrame:CGRectMake(hotelTitle.frame.origin.x, CGRectGetMaxY(time.frame), APPScreenWidth, time.frame.size.height) textColor:time.textColor font:time.font textAlignment:NSTextAlignmentLeft text:self.roomTypeName];
    self.roomTypeNameLabel = roomType;
    [upView addSubview:roomType];
    
    UILabel *cancelFree = [UILabel createLabelWithFrame:CGRectMake(hotelTitle.frame.origin.x, CGRectGetMaxY(roomType.frame)+2, 50, 15) textColor:PurpleColor font:[UIFont systemFontOfSize:10] textAlignment:NSTextAlignmentCenter text:NSLocalizedString(@"HotelConfirmMsg_4", nil)];
    cancelFree.layer.borderWidth = 0.5f;
    cancelFree.layer.borderColor = PurpleColor.CGColor;
    cancelFree.layer.cornerRadius = 2.0f;
    [upView addSubview:cancelFree];
    
    UIView *downView = [[UIView alloc] initWithFrame:CGRectMake(upView.frame.origin.x, CGRectGetMaxY(upView.frame)+10, upView.frame.size.width, 40)];
    downView.backgroundColor = [UIColor whiteColor];
    downView.layer.cornerRadius = 7.0f;
    [header addSubview:downView];
    
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 20, 20)];
    icon.image = [UIImage imageNamed:@"icon_success"];
    [downView addSubview:icon];
    
    UILabel *info = [UILabel createLabelWithFrame:CGRectMake(CGRectGetMaxX(icon.frame)+10, 0, APPScreenWidth, 40) textColor:PurpleColor font:[UIFont systemFontOfSize:12] textAlignment:NSTextAlignmentLeft text:NSLocalizedString(@"HotelConfirmMsg_5", nil)];
    [downView addSubview:info];
    
    CGRect headerFrame = header.frame;
    headerFrame.size.height = CGRectGetMaxY(downView.frame)+10;
    header.frame = headerFrame;
    
    self.tableHeaderView = header;
}

- (void)registerCell {
    [self registerClass:[HotelConfirmTableViewCell class] forCellReuseIdentifier:@"ChooseCell"];
    [self registerClass:[HotelConfirmOrderEditTableViewCell class] forCellReuseIdentifier:@"EditCell"];
}

- (void)setHotelName:(NSString *)hotelName {
    _hotelName = hotelName;
    self.hotelNameLabel.text = hotelName;
}

- (void)setRoomTypeName:(NSString *)roomTypeName {
    _roomTypeName = roomTypeName;
    self.roomTypeNameLabel.text = roomTypeName;
}

- (void)setLeavedate:(NSString *)leavedate {
    _leavedate = leavedate;
    self.timeLabel.text = [NSString stringWithFormat:@"%@%@ %@%@ %@(%@)%@",NSLocalizedString(@"HotelIn",nil),_arrivedate,NSLocalizedString(@"HotelLeave",nil),NSLocalizedString(@"HotelTotal",nil),_leavedate,_days,NSLocalizedString(@"HotelNight",nil)];
}

- (void)setRetainTimeArray:(NSArray *)retainTimeArray {
    _retainTimeArray = retainTimeArray;
    
    _chooseTimeView.dataSource = retainTimeArray;
}

- (NSArray *)customerPhones {
    NSMutableArray *phones = @[].mutableCopy;
    for (HotelReseveCustomerModel *model in _reseveCustomers) {
        if (model.phoneNum.length == 0) {
            break;
        }
        [phones addObject:model.phoneNum];
    }
    _customerPhones = phones.mutableCopy;
    return _customerPhones;
}

- (NSArray *)customerNames {
    NSMutableArray *names = @[].mutableCopy;
    for (HotelReseveCustomerModel *model in _reseveCustomers) {
        if (model.name.length == 0) {
            break;
        }
        [names addObject:model.name];
    }
    _customerNames = names.mutableCopy;
    return _customerNames;
}

#pragma mark -- UITableViewDataSource & UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == _roomNumbers+1) {
        return 1;
    }
    
    return 2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (_roomNumbers > 0) {
        return _roomNumbers+2;
    }
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        HotelConfirmTableViewCell *cell = [[HotelConfirmTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ChooseCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (indexPath.row == 0) {
            cell.leftLabel.text = NSLocalizedString(@"HotelConfirmCell_0", nil);
            cell.rightLabel.text = _rooms;
        } else if (indexPath.row == 1) {
            cell.leftLabel.text = NSLocalizedString(@"HotelConfirmCell_1", nil);
            cell.rightLabel.text = _arriveTime;
        }
        return cell;

    } else if (indexPath.section == _roomNumbers+1){
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"PointCell"];
        cell.textLabel.text = NSLocalizedString(@"HotelConfirmCell_2", nil);
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        cell.textLabel.textColor = HotelGrayColor;
        UISwitch *swith = [[UISwitch alloc] initWithFrame:CGRectMake(APPScreenWidth - 40 - 20, 8, 25, 25)];
//        swith.on = YES;
        swith.on = _usePoint;
        
        [swith addTarget:self action:@selector(usePoint:) forControlEvents:UIControlEventValueChanged];
        self.switchButn = swith;
        
        [cell.contentView addSubview:swith];
        return cell;
    } else  {
        HotelReseveCustomerModel *model;
        if (_reseveCustomers.count > 0) {
            model = _reseveCustomers[indexPath.section - 1];
        }
        
         HotelConfirmOrderEditTableViewCell *cell = [[HotelConfirmOrderEditTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"EditCell"];
        if (indexPath.row == 0) {
            cell.leftLabel.text = [NSString stringWithFormat:@"%@%ld)",NSLocalizedString(@"HotelConfirmCell_6", nil),(long)(indexPath.section)];
           cell.rightTextField.placeholder = NSLocalizedString(@"HotelConfirmCell_3", nil);
            cell.rightTextField.text = model.name;
        } else {
            cell.leftLabel.text = NSLocalizedString(@"HotelConfirmCell_4", nil);
            cell.rightTextField.placeholder = NSLocalizedString(@"HotelConfirmCell_5", nil);
            cell.rightTextField.delegate = self;
            cell.rightTextField.keyboardType = UIKeyboardTypeNumberPad;
            cell.icon.image = [UIImage imageNamed:@"icon_contact"];
            UITapGestureRecognizer *showContact = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showContact:)];
            [cell.icon addGestureRecognizer:showContact];
            cell.rightTextField.text = model.phoneNum;
        }
         return cell;
        
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [KEYWINDOW endEditing:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [_chooseNumbersView showInView:KEYWINDOW];
        } else if (indexPath.row == 1) {
            [_chooseTimeView showInView:KEYWINDOW];
        }
    }
}

- (void)usePoint:(UISwitch *)swith {
    BOOL usePoint = swith.isOn;
    self.usePoint = usePoint;
    
    NSInteger isOn = usePoint;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:HotelUsePointSwitchChangeNotification object:@(isOn)];
}

- (BOOL)usePoint {
    if (self.switchButn.on == YES) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark -- UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSLog(@"%@",textField.text);
    
    HotelConfirmOrderEditTableViewCell *cell = (HotelConfirmOrderEditTableViewCell *)textField.superview.superview;
    NSIndexPath *indexPath = [self indexPathForCell:cell];
    NSLog(@"%@",indexPath);
    
    HotelReseveCustomerModel *model = _reseveCustomers[indexPath.section - 1];
    if (indexPath.row == 0) {
        model.name = textField.text;
    }
    if (indexPath.row == 1) {
        model.phoneNum = textField.text;
    }
    
}

- (void)showContact:(UITapGestureRecognizer *)tap {
    
    UIView *tapView = tap.view;
    UIView *view = tapView.superview.superview;
    if ([view isKindOfClass:[HotelConfirmOrderEditTableViewCell class]]) {
        HotelConfirmOrderEditTableViewCell *cell = (HotelConfirmOrderEditTableViewCell *)view;
        self.phoneField = cell.rightTextField;
        self.contactIndexPath = [self indexPathForCell:cell];
    }
    
    // 1.创建联系人的界面
    CNContactPickerViewController *cpvc = [[CNContactPickerViewController alloc] init];
    
    // 2.设置代理
    cpvc.delegate = self;
    
    [self.viewController presentViewController:cpvc animated:YES completion:nil];
}

#pragma mark -- HotelConfirmOrderChooseViewDelegate
//选择到店时间或房间数量
- (void)didSelectedRowTitle:(NSString *)title
                  indexPath:(NSIndexPath *)indexPath
                 chooseView:(HotelConfirmOrderChooseView *)chooseView {
    if (chooseView == _chooseTimeView) {
        _arriveTime = title;
        
        for (HotelRetainTimeModel *model in _retainTimeArray) {
            if ([model.dictValue isEqualToString:title]) {
                _retainTimeKey = model.dictKey;
            }
        }
        
        [self reloadData];
    }
    if (chooseView == _chooseNumbersView) {
        _rooms = title;
        _roomNumbers = indexPath.row + 1;
        
        _customerNames = nil;
        _customerNames = [NSMutableArray arrayWithCapacity:_roomNumbers];
        
        _customerPhones = nil;
        _customerPhones = [NSMutableArray arrayWithCapacity:_roomNumbers];
        
        [_reseveCustomers removeAllObjects];
        for (int i = 0; i < _roomNumbers; i++) {
            HotelReseveCustomerModel *model = [[HotelReseveCustomerModel alloc] init];
            model.name = @"";
            model.phoneNum = @"";
            [_reseveCustomers addObject:model];
        }
        [self reloadData];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:HotelChooseRoomNumbersNotification object:@(_roomNumbers)];
    }
}

#pragma mark -- CNContactPickerDelegate

- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact
{
    // 1.获取联系人的姓名
    NSString *lastname = contact.familyName;
    NSString *firstname = contact.givenName;
    NSLog(@"%@ %@", lastname, firstname);
    
    // 2.获取联系人的电话号码
    NSArray *phoneNums = contact.phoneNumbers;
    for (CNLabeledValue *labeledValue in phoneNums) {
        // 2.1.获取电话号码的KEY
        NSString *phoneLabel = labeledValue.label;
        
        // 2.2.获取电话号码
        CNPhoneNumber *phoneNumer = labeledValue.value;
        NSString *phoneValue = phoneNumer.stringValue;
        
        NSLog(@"%@ %@", phoneLabel, phoneValue);
        _phoneField.text = phoneValue;
        
         HotelReseveCustomerModel *model = _reseveCustomers[_contactIndexPath.section - 1];
         model.phoneNum = phoneValue;
    }
}

@end
