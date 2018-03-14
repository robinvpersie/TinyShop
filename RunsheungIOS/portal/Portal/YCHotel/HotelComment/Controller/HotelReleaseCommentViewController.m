//
//  HotelReleaseCommentViewController.m
//  Portal
//
//  Created by ifox on 2017/4/28.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "HotelReleaseCommentViewController.h"
#import "HotelPaymentRoomCell.h"
#import "TPKeyboardAvoidingTableView.h"
#import "UIButton+CreateButton.h"
#import "HotelCommentStarTableViewCell.h"
#import "HotelCommentFaceTableViewCell.h"
#import "YYTextView.h"

#define ItemWidth (APPScreenWidth - 15*4 - 10)/4
#define Space  15

@interface HotelReleaseCommentViewController ()<UITableViewDataSource, UITableViewDelegate, TZImagePickerControllerDelegate, HotelCommentFaceTableViewCellDelegate,HotelCommentStarTableViewCellDelegate>

@property(nonatomic, strong) TPKeyboardAvoidingTableView *tableView;

@property(nonatomic, strong) UIView *footerView;
@property(nonatomic, strong) UIButton *camera;
@property(nonatomic, strong) NSMutableArray *imageArr;
@property(nonatomic, strong) NSMutableArray *imageURLs;
@property(nonatomic, strong) YYTextView *textView;

@property(nonatomic, assign) NSInteger hygieneScore;//卫生评分
@property(nonatomic, assign) NSInteger environmentalScore;//环境评分
@property(nonatomic, assign) NSInteger serviceScore;//服务评分
@property(nonatomic, assign) NSInteger facilitiesProportion;//设施评分

@property(nonatomic, assign) float totalScore;


@end

@implementation HotelReleaseCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _hygieneScore = 5;
    _environmentalScore = 5;
    _serviceScore = 5;
    _facilitiesProportion = 5;
    _totalScore = 5.0;
    
    _imageURLs = @[].mutableCopy;
    
    self.view.backgroundColor = BGColor;
    self.title = NSLocalizedString(@"HotelReleaseCommentTitle", nil);
   
    [self createView];
}

- (void)createView {
     [self.view addSubview:self.tableView];
    
    UIButton *releaseNow = [UIButton createButtonWithFrame:CGRectMake(0, self.view.frame.size.height - 45, APPScreenWidth, 45) title:NSLocalizedString(@"SMCommentReleaseTitle", nil) titleColor:[UIColor whiteColor] titleFont:[UIFont boldSystemFontOfSize:15] backgroundColor:PurpleColor];
    [releaseNow addTarget:self action:@selector(releaseComment) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:releaseNow];
    
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPScreenWidth, ItemWidth + 15)];
    footer.backgroundColor = [UIColor whiteColor];
    
    _camera = [UIButton buttonWithType:UIButtonTypeCustom];
    _camera.frame = CGRectMake(Space, 0, ItemWidth, ItemWidth);
    [_camera setImage:[UIImage imageNamed:@"camera"] forState:UIControlStateNormal];
    [_camera addTarget:self action:@selector(clickCamera:) forControlEvents:UIControlEventTouchUpInside];
    [footer addSubview:_camera];
    self.footerView = footer;
    _tableView.tableFooterView = footer;
}

- (void)clickCamera:(UIButton *)button {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
    
    imagePickerVc.pickerDelegate = self;
    imagePickerVc.maxImagesCount = 3;
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
    
}

- (void)releaseComment {
    [MBProgressHUD showWithView:self.view];
    if (self.imageArr.count > 0) {
        [YCHotelHttpTool hotelUpLoadImages:self.imageArr success:^(id response) {
            NSLog(@"%@",response);
            NSArray *uploadList = response[@"UploadImageList"];
            if (uploadList.count > 0) {
                for (NSDictionary *dic in uploadList) {
                    NSString *imageFileName = dic[@"imageFileName"];
                    [_imageURLs addObject:imageFileName];
                }
            }
            [self sendComment];
            
        } failure:^(NSError *err) {
            
        }];
    } else {
        [self sendComment];
    }
 
}

- (void)sendComment {
    [YCHotelHttpTool hotelSendCommentWithOrderID:self.orderID content:self.textView.text score:self.totalScore hygieneScore:self.hygieneScore environmentalScore:self.environmentalScore serviceScore:self.serviceScore facilitiesProportion:self.facilitiesProportion hotelID:self.hotelID imagePaths:self.imageURLs success:^(id response) {
        NSLog(@"%@",response);
        NSNumber *status = response[@"status"];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (status.integerValue == 1) {
            [MBProgressHUD hideAfterDelayWithView:self.view interval:1.5f text:response[@"msg"]];
            [self performSelector:@selector(popController) withObject:nil afterDelay:2];
        }
    } failure:^(NSError *err) {
        
    }];
}

- (void)popController {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 120;
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            return 60;
        } else if (indexPath.row < 5) {
            return 40;
        }
    }
    return 120;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 12.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return 6;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        HotelPaymentRoomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RoomCell"];
        [UIImageView hotelSetImageWithImageView:cell.roomIcon UrlString:_orderDetail.imageUrl imageVersion:nil];
        cell.hotelNameLabel.text = _orderDetail.hotelName;
        cell.roomTypeName.text = _orderDetail.roomTypeName;
        cell.priceLabel.text = [NSString stringWithFormat:@"￥%@",_orderDetail.orderPrice];
        cell.timeLabel.text = [NSString stringWithFormat:@"%@ - %@",_orderDetail.arriveTime,_orderDetail.leaveTime];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            HotelCommentStarTableViewCell *cell = [[HotelCommentStarTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"StarCell"];
            cell.delegate = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        } else if (indexPath.row < 5) {
            HotelCommentFaceTableViewCell *cell = [[HotelCommentFaceTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FaceCell"];
            cell.delegate = self;
            if (indexPath.row == 1) {
                cell.cellTitle = NSLocalizedString(@"HotelCommentHygiene", nil);
            }
            if (indexPath.row == 2) {
                cell.cellTitle = NSLocalizedString(@"HotelCommentEnv", nil);
            }
            if (indexPath.row == 3) {
                cell.cellTitle = NSLocalizedString(@"HotelCommentService", nil);
            }
            if (indexPath.row == 4) {
                cell.cellTitle = NSLocalizedString(@"HotelCommentFacility", nil);
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPScreenWidth, 0.5f)];
    line.backgroundColor = BorderColor;
    [cell.contentView addSubview:line];
    YYTextView *textView = [[YYTextView alloc] initWithFrame:CGRectMake(10, 0.5, APPScreenWidth - 20, 120)];
    textView.font = [UIFont systemFontOfSize:13];
    textView.placeholderText = NSLocalizedString(@"HotelReleaseCommentPlaceHolder", nil);
    [cell.contentView addSubview:textView];
    self.textView = textView;
    return cell;
}

#pragma mark - HotelCommentFaceTableViewCellDelegate

- (void)cellRating:(NSInteger)rating andCell:(HotelCommentFaceTableViewCell *)cell {
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    NSInteger row = indexPath.row;
    if (row == 1) {
        _hygieneScore = rating;
    } else if (row == 2) {
        _environmentalScore = rating;
    } else if (row == 3) {
        _serviceScore = rating;
    } else if (row == 4) {
        _facilitiesProportion = rating;
    }
}

- (void)HotelCommentStarTableViewCellScore:(float)score {
    self.totalScore = score;
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    
    self.imageArr = photos.mutableCopy;
    
    [self resetImageFrame];

}

- (void)resetImageFrame {
    NSArray *subViews = _tableView.tableFooterView.subviews;
    
    for (UIView *view in subViews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            [view removeFromSuperview];
        }
    }
    
    if (_imageArr.count == 0) {
        _camera.frame = CGRectMake(Space, 0, ItemWidth, ItemWidth);
    }
    
    if (_imageArr.count < 4) {
        for (int i = 0; i<_imageArr.count; i++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(Space * (i+1) + ItemWidth*i, 0, ItemWidth, ItemWidth)];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds = YES;
            imageView.image = _imageArr[i];
            imageView.userInteractionEnabled = YES;
            UIButton *delete = [UIButton createButtonWithFrame:CGRectMake(imageView.frame.size.width - 15, 0, 15, 15) title:@"X" titleColor:[UIColor redColor] titleFont:[UIFont systemFontOfSize:14] backgroundColor:[UIColor whiteColor]];
            delete.tag = i;
            [delete addTarget:self action:@selector(deleteImage:) forControlEvents:UIControlEventTouchUpInside];
            [imageView addSubview:delete];
            [self.footerView addSubview:imageView];
            if (i == (_imageArr.count -1)) {
                _camera.frame = CGRectMake(Space*(i+2) + ItemWidth*(i+1), 0, ItemWidth, ItemWidth);
            }
        }
    }
}

- (void)deleteImage:(UIButton *)delete {
    NSInteger index = delete.tag;
    [_imageArr removeObjectAtIndex:index];
    [self resetImageFrame];
}

- (TPKeyboardAvoidingTableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[TPKeyboardAvoidingTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 45) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorColor = [UIColor clearColor];
        UINib *nib = [UINib nibWithNibName:@"HotelPaymentRoomCell" bundle:nil];
        [_tableView registerNib:nib forCellReuseIdentifier:@"RoomCell"];
        
        [_tableView registerClass:[HotelCommentStarTableViewCell class] forCellReuseIdentifier:@"StarCell"];
        
        [_tableView registerClass:[HotelCommentFaceTableViewCell class] forCellReuseIdentifier:@"FaceCell"];
    }
    return _tableView;
}


@end
