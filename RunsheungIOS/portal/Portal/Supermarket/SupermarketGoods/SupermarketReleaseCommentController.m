//
//  SupermarketReleaseCommentController.m
//  Portal
//
//  Created by ifox on 2016/12/22.
//  Copyright © 2016年 linpeng. All rights reserved.
//

#import "SupermarketReleaseCommentController.h"
#import "CWStarRateView.h"
#import "YYTextView.h"
#import "TZImagePickerController.h"
#import "SupermarketOrderGoodsData.h"
#import "UIButton+CreateButton.h"

#define ItemWidth (APPScreenWidth - 15*4 - 10)/4
#define Space  15

@interface SupermarketReleaseCommentController ()<CWStarRateViewDelegate, TZImagePickerControllerDelegate>

@property(nonatomic, strong)UIScrollView *scrollView;

@property(nonatomic, strong) NSMutableArray *imageArray;

@property(nonatomic, strong) UIImageView *goosIcon;

@end

@implementation SupermarketReleaseCommentController  {
    UIButton *_good;
    UIButton *_mid;
    UIButton *_bad;
    
    UIButton *releaseButton;
    
    UIView *imageBackground;
    
    UIButton *camera;
    
    CWStarRateView *starView;
    
    YYTextView *textView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"SMCommentTitle", nil);
    
    [self createView];
    
    
    // Do any additional setup after loading the view.
}

- (void)createView {
    NSArray *goodList = _orderData.goodList;
    SupermarketOrderGoodsData *goodsData;
    if (_goodsData != nil) {
        goodsData = _goodsData;
    } else {
        goodsData = goodList[_index];
    }
//    SupermarketOrderGoodsData *goodsData = goodList[_index];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, APPScreenWidth, self.view.frame.size.height)];
    _scrollView.backgroundColor = RGB(241, 242, 243);
    [self.view addSubview:_scrollView];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPScreenWidth, 0)];
    bgView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:bgView];
    
    UIImageView *goodImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 100, 100)];
    goodImageView.image = [UIImage imageNamed:@"11232"];
    goodImageView.clipsToBounds = YES;
    goodImageView.contentMode = UIViewContentModeScaleAspectFill;
    [bgView addSubview:goodImageView];
    [UIImageView setimageWithImageView:goodImageView UrlString:goodsData.image_url imageVersion:nil];
    self.goosIcon = goodImageView;
    
    UILabel *rate = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(goodImageView.frame)+10, goodImageView.frame.origin.y, 100, 25)];
    rate.font = [UIFont systemFontOfSize:15];
    rate.textColor = [UIColor grayColor];
    rate.text = NSLocalizedString(@"SMCommentRate", nil);
    [bgView addSubview:rate];
    
    starView = [[CWStarRateView alloc] initWithFrame:CGRectMake(rate.frame.origin.x, CGRectGetMaxY(rate.frame), 100, 25)];
    starView.scorePercent = 0;
    starView.delegate = self;
    [bgView addSubview:starView];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(rate.frame.origin.x, CGRectGetMaxY(starView.frame)+10, APPScreenWidth - rate.frame.origin.x - 10, 1.0f)];
    line.backgroundColor = BGColor;
    [bgView addSubview:line];
    
    _bad = [UIButton buttonWithType:UIButtonTypeCustom];
    _bad.frame = CGRectMake(line.frame.origin.x, CGRectGetMaxY(line.frame)+10, 22, 22);
    [_bad setImage:[UIImage imageNamed:@"comment_normal"] forState:UIControlStateNormal];
    [_bad setImage:[UIImage imageNamed:@"comment_bad"] forState:UIControlStateSelected];
    [_bad addTarget:self action:@selector(selectButton:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:_bad];
    
    UIButton *badLabel = [UIButton buttonWithType:UIButtonTypeCustom];
    badLabel.frame = CGRectMake(CGRectGetMaxX(_bad.frame)+5, _bad.frame.origin.y, 40, _bad.frame.size.height);
    badLabel.tag = 100;
    [badLabel setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [badLabel setTitle:NSLocalizedString(@"SMCommentBad", nil) forState:UIControlStateNormal];
    [badLabel addTarget:self action:@selector(touchLabel:) forControlEvents:UIControlEventTouchUpInside];
    badLabel.titleLabel.font = [UIFont systemFontOfSize:15];
    [bgView addSubview:badLabel];
    
    _mid = [UIButton buttonWithType:UIButtonTypeCustom];
    _mid.frame = CGRectMake(CGRectGetMidX(line.frame) - 35 ,_bad.frame.origin.y , _bad.frame.size.width, _bad.frame.size.height);
    [_mid setImage:[UIImage imageNamed:@"comment_normal"] forState:UIControlStateNormal];
    [_mid setImage:[UIImage imageNamed:@"comment_mid"] forState:UIControlStateSelected];
    [_mid addTarget:self action:@selector(selectButton:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:_mid];
    
    UIButton *midLabel = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_mid.frame)+5, _mid.frame.origin.y, 40, _mid.frame.size.height)];
    [midLabel setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    midLabel.titleLabel.font = [UIFont systemFontOfSize:15];
    [midLabel setTitle:NSLocalizedString(@"SMCommentMid", nil) forState:UIControlStateNormal];
    [midLabel addTarget:self action:@selector(touchLabel:) forControlEvents:UIControlEventTouchUpInside];
    midLabel.tag = 200;
    [bgView addSubview:midLabel];
    
    _good = [UIButton buttonWithType:UIButtonTypeCustom];
    _good.frame = CGRectMake(APPScreenWidth - 40 - 10 - 22, _mid.frame.origin.y, 22, 22);
    [_good setImage:[UIImage imageNamed:@"comment_normal"] forState:UIControlStateNormal];
    [_good setImage:[UIImage imageNamed:@"comment_good"] forState:UIControlStateSelected];
    [_good addTarget:self action:@selector(selectButton:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:_good];
    
    UIButton *goodLabel = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_good.frame)+5, _good.frame.origin.y, 40, _good.frame.size.height)];
    [goodLabel setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    goodLabel.titleLabel.font = [UIFont systemFontOfSize:15];
    [goodLabel setTitle:NSLocalizedString(@"SMCommentGood", nil) forState:UIControlStateNormal];
    goodLabel.tag = 300;
    [goodLabel addTarget:self action:@selector(touchLabel:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:goodLabel];
    
    bgView.frame = CGRectMake(0, 0, APPScreenWidth, CGRectGetMaxY(goodImageView.frame)+20);
    
    UIView *textViewbg = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(bgView.frame), APPScreenWidth, 80)];
    textViewbg.backgroundColor = RGB(248, 248, 249);
    [_scrollView addSubview:textViewbg];
    
    textView = [[YYTextView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(bgView.frame), APPScreenWidth-25, 80)];
    textView.backgroundColor = RGB(248, 248, 249);
    textView.placeholderText = NSLocalizedString(@"SMCommentPlaceHolder", nil);
    textView.placeholderTextColor = [UIColor grayColor];
    textView.placeholderFont = [UIFont systemFontOfSize:14];
    textView.font = [UIFont systemFontOfSize:15];
    [_scrollView addSubview:textView];
    
    imageBackground = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(textView.frame), APPScreenWidth, 0)];
    imageBackground.backgroundColor = RGB(248, 248, 249);
    [_scrollView addSubview:imageBackground];
    
    camera = [UIButton buttonWithType:UIButtonTypeCustom];
    camera.frame = CGRectMake(ItemWidth*3 + Space*4, 0, ItemWidth, ItemWidth);
    [camera setImage:[UIImage imageNamed:@"camera"] forState:UIControlStateNormal];
    [camera addTarget:self action:@selector(clickCamera:) forControlEvents:UIControlEventTouchUpInside];
    [imageBackground addSubview:camera];
    
    imageBackground.frame = CGRectMake(0, CGRectGetMaxY(textView.frame), APPScreenWidth, ItemWidth + 20);
    imageBackground.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *dismissKeyBoard = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyBoard)];
    [imageBackground addGestureRecognizer:dismissKeyBoard];
    
    releaseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    releaseButton.frame = CGRectMake(15, CGRectGetMaxY(imageBackground.frame)+20, APPScreenWidth - 27, 45);
    releaseButton.backgroundColor = GreenColor;
    [releaseButton setTitle:NSLocalizedString(@"SMCommentReleaseTitle", nil) forState:UIControlStateNormal];
    releaseButton.layer.cornerRadius = 2.0f;
    [releaseButton addTarget:self action:@selector(releaseComment) forControlEvents:UIControlEventTouchUpInside];
    [releaseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_scrollView addSubview:releaseButton];
}

- (void)selectButton:(UIButton *)button {
    button.selected = YES;
    
    if (button == _good) {
        _good.selected = YES;
        _bad.selected = NO;
        _mid.selected = NO;
        
        starView.scorePercent = 1;
    }
    if (button == _mid) {
        _mid.selected = YES;
        _good.selected = NO;
        _bad.selected = NO;
        
        starView.scorePercent = 0.6;
    }
    if (button == _bad) {
        _bad.selected = YES;
        _good.selected = NO;
        _mid.selected = NO;
        
        starView.scorePercent = 0.2;
    }
}

- (void)touchLabel:(UIButton *)button {
    NSInteger tag = button.tag;
    
    if (tag == 300) {
        _good.selected = YES;
        _bad.selected = NO;
        _mid.selected = NO;
        
        starView.scorePercent = 1;
    }
    if (tag == 200) {
        _mid.selected = YES;
        _good.selected = NO;
        _bad.selected = NO;
        
        starView.scorePercent = 0.6;

    }
    if (tag == 100) {
        _bad.selected = YES;
        _good.selected = NO;
        _mid.selected = NO;
        
        starView.scorePercent = 0.2;
    }
}

- (void)starRateView:(CWStarRateView *)starRateView scroePercentDidChange:(CGFloat)newScorePercent {
    NSLog(@"%f",newScorePercent);
    
    if (newScorePercent > 0 && newScorePercent <= 0.4) {
        _bad.selected = YES;
        _good.selected = NO;
        _mid.selected = NO;
    } else if (newScorePercent > 0.4 && newScorePercent <= 0.6) {
        _bad.selected = NO;
        _good.selected = NO;
        _mid.selected = YES;
    } else {
        _bad.selected = NO;
        _mid.selected = NO;
        _good.selected = YES;
    }
}

- (void)clickCamera:(UIButton *)button {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
    
    imagePickerVc.pickerDelegate = self;
    imagePickerVc.maxImagesCount = 6;
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];

}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    
    self.imageArray = photos.mutableCopy;
    
    [self resetPhotosFrame];
}

- (void)resetPhotosFrame {
    NSArray *subViews = imageBackground.subviews;
    
    for (UIView *view in subViews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            [view removeFromSuperview];
        }
    }
    
    if (_imageArray.count == 0) {
        camera.frame = CGRectMake(ItemWidth*3 + Space*4, 0, ItemWidth, ItemWidth);
    }
    
    if (_imageArray.count < 4) {
        for (int i = 0; i<_imageArray.count; i++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(Space * (i+1) + ItemWidth*i, 0, ItemWidth, ItemWidth)];
            imageView.userInteractionEnabled = YES;
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds = YES;
            imageView.image = _imageArray[i];
            
            UIButton *delete = [UIButton createButtonWithFrame:CGRectMake(imageView.frame.size.width - 15, 0, 15, 15) title:@"X" titleColor:[UIColor redColor] titleFont:[UIFont systemFontOfSize:14] backgroundColor:[UIColor whiteColor]];
            delete.tag = i;
            [delete addTarget:self action:@selector(deleteImage:) forControlEvents:UIControlEventTouchUpInside];
            
            [imageView addSubview:delete];
            
            
            [imageBackground addSubview:imageView];
            if (i == (_imageArray.count -1)) {
                camera.frame = CGRectMake(Space*(i+2) + ItemWidth*(i+1), 0, ItemWidth, ItemWidth);
            }
        }
        
        imageBackground.frame = CGRectMake(0, CGRectGetMaxY(textView.frame), APPScreenWidth, ItemWidth + 20);
        releaseButton.frame = CGRectMake(15, CGRectGetMaxY(imageBackground.frame)+20, APPScreenWidth - 27, 45);
    }
    
    if (_imageArray.count >= 4) {
        for (int i = 0; i < 4; i++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(Space*(i+1) + ItemWidth*i, 0, ItemWidth, ItemWidth)];
            imageView.userInteractionEnabled = YES;
            imageView.image = _imageArray[i];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds = YES;
            
            UIButton *delete = [UIButton createButtonWithFrame:CGRectMake(imageView.frame.size.width - 15, 0, 15, 15) title:@"X" titleColor:[UIColor redColor] titleFont:[UIFont systemFontOfSize:14] backgroundColor:[UIColor whiteColor]];
            delete.tag = i;
            [delete addTarget:self action:@selector(deleteImage:) forControlEvents:UIControlEventTouchUpInside];
            
            [imageView addSubview:delete];
            
            [imageBackground addSubview:imageView];
        }
        
        for (int i = 0; i < _imageArray.count - 4; i++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(Space*(i+1 ) + ItemWidth*(i), ItemWidth + Space, ItemWidth, ItemWidth)];
            imageView.userInteractionEnabled = YES;
            imageView.image = _imageArray[i+4];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds = YES;
            
            UIButton *delete = [UIButton createButtonWithFrame:CGRectMake(imageView.frame.size.width - 15, 0, 15, 15) title:@"X" titleColor:[UIColor redColor] titleFont:[UIFont systemFontOfSize:14] backgroundColor:[UIColor whiteColor]];
            delete.tag = 4+i;
            [delete addTarget:self action:@selector(deleteImage:) forControlEvents:UIControlEventTouchUpInside];
            
            [imageView addSubview:delete];
            
            [imageBackground addSubview:imageView];
        }
        
        camera.frame = CGRectMake(Space*(_imageArray.count-4+1) + ItemWidth*(_imageArray.count - 4), ItemWidth+Space, ItemWidth, ItemWidth);
        
        CGRect frame = imageBackground.frame;
        
        frame.size.height = ItemWidth + 20;
        
        frame.size.height += (ItemWidth+Space);
        imageBackground.frame = frame;
        
        releaseButton.frame = CGRectMake(15, CGRectGetMaxY(imageBackground.frame)+20, APPScreenWidth - 27, 45);
    }
    
    if (_imageArray.count == 6) {
        camera.hidden = YES;
    } else {
        camera.hidden = NO;
    }

}

- (void)deleteImage:(UIButton *)delete {
    NSInteger index = delete.tag;
    [self.imageArray removeObjectAtIndex:index];
    [self resetPhotosFrame];
}

- (void)releaseComment {
    NSInteger level = starView.scorePercent*10/2;
    if (level > 0 && level < 3) {
        level = 3;
    } else if (level == 3) {
        level = 2;
    } else if (level > 3) {
        level = 1;
    }
    
    NSArray *goodList = _orderData.goodList;
    SupermarketOrderGoodsData *goodsData;
    if (_goodsData != nil) {
        goodsData = _goodsData;
    } else {
        goodsData = goodList[_index];
    }

    NSString *itemCode = goodsData.item_code;
    
    
    if (textView.text.length == 0) {
        [MBProgressHUD hideAfterDelayWithView:KEYWINDOW interval:2 text:@"请输入评价内容"];
        return;
    }
    
    if (self.controllerType == ControllerTypeDepartmentStores) {
    
        [KLHttpTool sendGoodsCommentWithPic:self.imageArray itemCode:itemCode rate:starView.scorePercent*10/2 level:level content:textView.text orderID:_orderData.order_code divCode:_orderData.divCode success:^(id response) {
            NSNumber *statu = response[@"status"];
            if (statu.integerValue == 1) {
//                [MBProgressHUD hideAfterDelayWithView:KEYWINDOW interval:2 text:response[@"message"]];
                [[NSNotificationCenter defaultCenter] postNotificationName:ReceiveGoodsSucNotification object:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:ReloadWaitCommentGoodsNotification object:nil];
                if (self.isOrderDetail == YES && self.isLastOne == NO) {
                    UIViewController *controller = self.navigationController.viewControllers[1];
                    [self.navigationController popToViewController:controller animated:YES];
                }
                
                else if (self.isOrderDetail == NO && self.isLastOne == YES) {
                    UIViewController *controller = self.navigationController.viewControllers[1];
                    [self.navigationController popToViewController:controller animated:YES];
                }
                
                else if (self.isLastOne == YES && self.isOrderDetail == YES) {
                    UIViewController *controller = self.navigationController.viewControllers[2];
                    [self.navigationController popToViewController:controller animated:YES];
                }
                else {
                    [self.navigationController popViewControllerAnimated:YES];
                }
                
            } else {
                [MBProgressHUD hideAfterDelayWithView:KEYWINDOW interval:2 text:response[@"message"]];
            }
        } failure:^(NSError *err) {
            
        }];

    } else {
        [KLHttpTool sendGoodsCommentWithPic:self.imageArray itemCode:itemCode rate:starView.scorePercent*10/2 level:level content:textView.text orderID:_orderData.order_code divCode:_orderData.divCode success:^(id response) {
            NSNumber *statu = response[@"status"];
            if (statu.integerValue == 1) {
//                [MBProgressHUD hideAfterDelayWithView:KEYWINDOW interval:2 text:response[@"message"]];
                [[NSNotificationCenter defaultCenter] postNotificationName:ReceiveGoodsSucNotification object:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:ReloadWaitCommentGoodsNotification object:nil];
                if (self.isOrderDetail == YES && self.isLastOne == NO) {
                    UIViewController *controller = self.navigationController.viewControllers[1];
                    [self.navigationController popToViewController:controller animated:YES];
                }
                
                else if (self.isOrderDetail == NO && self.isLastOne == YES) {
                    UIViewController *controller = self.navigationController.viewControllers[1];
                    [self.navigationController popToViewController:controller animated:YES];
                }
                
                else if (self.isLastOne == YES && self.isOrderDetail == YES) {
                    UIViewController *controller = self.navigationController.viewControllers[2];
                    [self.navigationController popToViewController:controller animated:YES];
                }
                else {
                    [self.navigationController popViewControllerAnimated:YES];
                }
                
            } else {
                [MBProgressHUD hideAfterDelayWithView:KEYWINDOW interval:2 text:response[@"message"]];
            }
        } failure:^(NSError *err) {
            
        }];

    }
}

- (void)setOrderData:(SupermarketOrderData *)orderData {
    _orderData = orderData;
}

- (void)dismissKeyBoard {
    [textView resignFirstResponder];
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
