//
//  SupermarketApplyRefundController.m
//  Portal
//
//  Created by ifox on 2017/1/13.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "SupermarketApplyRefundController.h"
#import "TPKeyboardAvoidingTableView.h"
#import "YYTextView.h"
#import "TZImagePickerController.h"
#import "SupermarketApplyRefundCell.h"
#import "SupermarketOrderGoodsData.h"
#import "SupermarketRefundResaonModel.h"
#import "UIImageView+ImageCache.h"

@interface SupermarketApplyRefundController ()<UITableViewDelegate, UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource,TZImagePickerControllerDelegate>

@property(nonatomic, strong) TPKeyboardAvoidingTableView *tableView;

@property(nonatomic, strong) NSMutableArray *goodList;

@property(nonatomic, strong) UIPickerView *pickerView;

@property(nonatomic, assign) NSInteger type;//0为退货退款 1为换货 2为仅退款
@property(nonatomic, strong) NSArray *refundReasons;

@end

@implementation SupermarketApplyRefundController {
    YYTextView *textView;
    NSArray *_pickerTitles;
    NSString *_reason;
    UITextField *textField;
    UITapGestureRecognizer *_hidePicker;
    UIView *bgImageView;
    UILabel *msg;
    UITextField *moneyField;
    NSString *refundSubCode;//退款原因编号
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"SMApplyRefundTitle", nil);
    
    if (_orderDetail != nil) {
     _goodList = [NSMutableArray arrayWithArray:self.orderDetail.goodList];
    } else {
        _goodList = [NSMutableArray arrayWithArray:self.orderData.goodList];
    }
    
    [self createTableView];
    
    _pickerTitles = @[@"质量问题",@"大小不合适",@"不想要了",@"就是垃圾"];
    
    [self createPicker];
    
    [self requestData];
    
    // Do any additional setup after loading the view.
}

- (void)createTableView {
    _tableView = [[TPKeyboardAvoidingTableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UINib *nib = [UINib nibWithNibName:@"SupermarketApplyRefundCell" bundle:nil];
    [_tableView registerNib:nib forCellReuseIdentifier:@"applyRefundCell"];
    [self.view addSubview:_tableView];
}

- (void)confirmSubmmit {
    if (_reason.length == 0) {
        [MBProgressHUD hideAfterDelayWithView:KEYWINDOW interval:2 text:NSLocalizedString(@"SMApplyRefundMsg", nil)];
        return;
    }
//    if (moneyField.text.length == 0) {
//        [MBProgressHUD hideAfterDelayWithView:KEYWINDOW interval:2 text:@"请输入退款金额"];
//        return;
//    }
    if (refundSubCode.length == 0) {
        return;
    }
    
    [KLHttpTool supermarketApplayRefundWithOrderNumber:self.orderNum itemCode:_goods.item_code reason:refundSubCode refundNo:nil isCancel:NO success:^(id response) {
        NSLog(@"%@",response);
        NSNumber *status = response[@"status"];
        if (status.integerValue == 1) {
            [MBProgressHUD hideAfterDelayWithView:KEYWINDOW interval:2.0 text:response[@"message"]];
            [self performSelector:@selector(pop) withObject:nil afterDelay:2.0f];
        }
    } failure:^(NSError *err) {
        
    }];
    NSLog(@"确认提交");
}

- (void)pop {
    [[NSNotificationCenter defaultCenter] postNotificationName:SubmitRefundReloadDataNotification object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createPicker {
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, APPScreenHeight - APPScreenHeight/4, APPScreenWidth, APPScreenHeight/4)];
    _pickerView.showsSelectionIndicator = YES;
    _pickerView.backgroundColor = BGColor;
    _pickerView.dataSource = self;
    _pickerView.delegate = self;
    [KEYWINDOW addSubview:_pickerView];
    _pickerView.hidden = YES;

}

- (void)requestData {
    [KLHttpTool supermarketGetRefundReasonListsuccess:^(id response) {
        NSLog(@"%@",response);
        NSNumber *status = response[@"status"];
        if (status.integerValue == 1) {
            NSArray *data = response[@"data"];
            if (data.count > 0) {
                NSMutableArray *refundReasons = @[].mutableCopy;
                for (NSDictionary *dic in data) {
                    SupermarketRefundResaonModel *reason = [NSDictionary getRefundReasonWithDic:dic];
                    [refundReasons addObject:reason];
                }
                self.refundReasons = refundReasons;
                [_pickerView reloadAllComponents];
            }
        }
    } failure:^(NSError *err) {
        
    }];
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return NSLocalizedString(@"SMDeleteTitle", nil);
    }
    return nil;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            [self.goodList removeObjectAtIndex:indexPath.row];
            [self.tableView reloadData];
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
       return 1;
    }
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {

        SupermarketApplyRefundCell *refundCell = [_tableView dequeueReusableCellWithIdentifier:@"applyRefundCell"];
        SupermarketOrderGoodsData *data = _goods;
        [UIImageView setimageWithImageView:refundCell.goodIconImageView UrlString:data.image_url imageVersion:data.ver];
        refundCell.goodsTitleLabel.text = data.title;
        refundCell.buyAmountLabel.text = [NSString stringWithFormat:@"x%@",data.amount];
        return refundCell;
    }
    if (indexPath.section == 1) {
//        UIButton *moneyGoods = [self createButtonWithFrame:CGRectMake(15, 15, 75, 30) title:@"退货退款"];
//        [moneyGoods addTarget:self action:@selector(moneyGoodsPressed:) forControlEvents:UIControlEventTouchUpInside];
//        [cell.contentView addSubview:moneyGoods];
//        
//        UIButton *goods = [self createButtonWithFrame:CGRectMake(CGRectGetMaxX(moneyGoods.frame)+10, moneyGoods.frame.origin.y, moneyGoods.frame.size.width, moneyGoods.frame.size.height) title:@"换货"];
//        [goods addTarget:self action:@selector(goodsPressed:) forControlEvents:UIControlEventTouchUpInside];
//        [cell.contentView addSubview:goods];
//        
//        UIButton *money = [self createButtonWithFrame:CGRectMake(CGRectGetMaxX(goods.frame)+10, moneyGoods.frame.origin.y, moneyGoods.frame.size.width, moneyGoods.frame.size.height) title:@"仅退款"];
//        [money addTarget:self action:@selector(moneyPressed:) forControlEvents:UIControlEventTouchUpInside];
//        [cell.contentView addSubview:money];
//        
//        switch (self.type) {
//            case 0:
//                moneyGoods.selected = YES;
//                [moneyGoods setTitleColor:GreenColor forState:UIControlStateSelected];
//                moneyGoods.layer.borderColor = GreenColor.CGColor;
//                break;
//            case 1:
//                goods.selected = YES;
//                [goods setTitleColor:GreenColor forState:UIControlStateSelected];
//                goods.layer.borderColor = GreenColor.CGColor;
//                break;
//            case 2:
//                money.selected = YES;
//                [money setTitleColor:GreenColor forState:UIControlStateSelected];
//                money.layer.borderColor = GreenColor.CGColor;
//                break;
//            default:
//                break;
//        }
        
    }
    if (indexPath.section == 1) {
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, APPScreenWidth, 25)];
        title.font = [UIFont systemFontOfSize:16];
        title.textColor = [UIColor darkcolor];
        title.text = @"退货原因";
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(title.frame), APPScreenWidth, 1)];
        line.backgroundColor = BGColor;
        [cell.contentView addSubview:title];
        [cell.contentView addSubview:line];
        
        textField = [[UITextField alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(title.frame)+10, APPScreenWidth-15-10, 25)];
        textField.layer.borderWidth = 1;
        textField.layer.borderColor = BGColor.CGColor;
        textField.placeholder = @"请选择退货原因";
        textField.textColor = [UIColor darkcolor];
        textField.userInteractionEnabled = NO;
        textField.font = [UIFont systemFontOfSize:14];
        [cell.contentView addSubview:textField];
        if (_reason.length > 0) {
            textField.text = _reason;
        }
        
        switch (self.type) {
            case 0:
                title.text = @"退货原因";
                textField.placeholder = @"请选择退货原因";
                break;
            case 1:
                title.text = @"换货原因";
                textField.placeholder = @"请选择换货原因";
                break;
            case 2:
                title.text = @"退款原因";
                textField.placeholder = @"请选择退款原因";
                break;
            default:
                break;
        }
        
        UIButton *down = [UIButton buttonWithType:UIButtonTypeCustom];
        down.frame = CGRectMake(textField.frame.size.width - 10 - 20, CGRectGetMaxY(title.frame)+12, 20, 20);
//        down.backgroundColor = [UIColor redColor];
        [down setImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateNormal];
        [down addTarget:self action:@selector(choseReason) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:down];
        
    }
    if (indexPath.section == 2) {

        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, APPScreenWidth, 25)];
        title.font = [UIFont systemFontOfSize:16];
        title.text = @"退货说明";
        title.textColor = [UIColor darkcolor];
        [cell.contentView addSubview:title];
        
        textView = [[YYTextView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(title.frame), APPScreenWidth - 15- 10, 130)];
        textView.layer.borderWidth = 1;
        textView.layer.borderColor = BGColor.CGColor;
        textView.placeholderFont = [UIFont systemFontOfSize:14];
        textView.font = [UIFont systemFontOfSize:14];
        textView.placeholderText = @"请输入退货说明";
        [cell.contentView addSubview:textView];
        
        switch (self.type) {
            case 0:
                title.text = @"退货说明";
                textView.placeholderText = @"请输入退货说明";
                break;
            case 1:
                title.text = @"换货说明";
                textView.placeholderText = @"请输入换货说明";
                break;
            case 2:
                title.text = @"退款说明";
                textView.placeholderText = @"请输入退款说明";
                break;
            default:
                break;
        }

    }
    if (indexPath.section == 3) {

        cell.contentView.backgroundColor = BGColor;
        bgImageView = [[UIView alloc] initWithFrame:CGRectMake(15, 0, APPScreenWidth - 30, 50)];
        bgImageView.backgroundColor = [UIColor whiteColor];
        [cell.contentView addSubview:bgImageView];
        
        msg = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, APPScreenWidth, bgImageView.frame.size.height)];
        msg.textColor = [UIColor lightGrayColor];
        msg.text = @"上传照片最多三张";
        msg.font = [UIFont systemFontOfSize:15];
        [bgImageView addSubview:msg];
        
        UIButton *camera = [UIButton buttonWithType:UIButtonTypeCustom];
        camera.frame = CGRectMake(bgImageView.frame.size.width - 5 - 40, 5, 40, 40);
        [camera setImage:[UIImage imageNamed:@"camera_gray"] forState:UIControlStateNormal];
        [camera addTarget:self action:@selector(clickCamera) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:camera];

    }
    if (indexPath.section == 4) {

        UIButton *confirmSubmmit = [UIButton buttonWithType:UIButtonTypeCustom];
        confirmSubmmit.frame = CGRectMake(15, 0, APPScreenWidth - 30, 40);
        [confirmSubmmit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [confirmSubmmit setTitle:@"确认提交" forState:UIControlStateNormal];
        confirmSubmmit.backgroundColor = GreenColor;
        confirmSubmmit.layer.cornerRadius = 4.0f;
        confirmSubmmit.titleLabel.font = [UIFont systemFontOfSize:17];
        [confirmSubmmit addTarget:self action:@selector(confirmSubmmit) forControlEvents:UIControlEventTouchUpInside];
        cell.contentView.backgroundColor = BGColor;
        [cell.contentView addSubview:confirmSubmmit];

    }

    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 80;
    }
//    if (indexPath.section == 1) {
//        return 60;
//    }
    if (indexPath.section == 1) {
        return 80;
    }
    if (indexPath.section == 2) {
//        return 80;
        return 160;
    }
    if (indexPath.section == 3) {
//        return 160;
        return 70;
    }
    if (indexPath.section == 4) {
        return 70;
    }
    return 80;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [textView resignFirstResponder];
}

- (UIButton *)createButtonWithFrame:(CGRect)frame
                              title:(NSString *)title {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    button.layer.borderColor = BGColor.CGColor;
    button.layer.borderWidth = 1;
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    return button;
}

- (void)moneyGoodsPressed:(UIButton *)button {
    button.selected = YES;
    self.type = 0;
    [_tableView reloadData];
}

- (void)goodsPressed:(UIButton *)button {
    button.selected = YES;
    self.type = 1;
    [_tableView reloadData];
}

- (void)moneyPressed:(UIButton *)button {
    button.selected = YES;
    self.type = 2;
    [_tableView reloadData];
}

- (void)choseReason {
    _pickerView.hidden = NO;
    if (_hidePicker == nil) {
        _hidePicker = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidePicker:)];
    }
    [_tableView addGestureRecognizer:_hidePicker];
}

- (void)hidePicker:(UITapGestureRecognizer *)sender {
    _pickerView.hidden = YES;
    [_tableView removeGestureRecognizer:_hidePicker];
    if (_reason.length > 0) {
        textField.text = _reason;
    }
}

- (void)clickCamera {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
    
    imagePickerVc.pickerDelegate = self;
    imagePickerVc.maxImagesCount = 3;
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];

}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    for (UIView *view in bgImageView.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            [view removeFromSuperview];
        }
    }
    
    if (photos.count > 0) {
        msg.hidden = YES;
        for (int i = 0; i < photos.count; i++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((i+1)*10 + 40*i, 5, 40, 40)];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds = YES;
            imageView.image = photos[i];
            [bgImageView addSubview:imageView];
        }

    } else {
        msg.hidden = NO;
    }
  
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _refundReasons.count;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    SupermarketRefundResaonModel *model = _refundReasons[row];
    return model.codeName;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    SupermarketRefundResaonModel *model = _refundReasons[row];
    _reason = model.codeName;
    refundSubCode = model.subCode;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    _pickerView.hidden = YES;
}


@end
