//
//  NumDomainView.h
//  demo
//
//  Created by dlwpdlr on 2018/3/21.
//  Copyright © 2018年 wangchengshan. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NumDomainView : UIView<UICollectionViewDelegate,UICollectionViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource,UIScrollViewDelegate,UITextFieldDelegate>

/**
 滑动UICollectView
 */
@property (nonatomic,strong)UICollectionView *topLandScopeCollectView;
@property (nonatomic,strong)UICollectionView *bottomLandScopeCollectView;
@property (nonatomic,strong)UICollectionView *leftPortraitCollectView;
@property (nonatomic,strong)UICollectionView *rightPortraitCollectView;
@property (nonatomic,strong)UICollectionView *centerShowCollectView;

/**
 滑动UIPickerView
 */
@property (nonatomic,strong)UIPickerView *pickerView1;
@property (nonatomic,strong)UIPickerView *pickerView2;
@property (nonatomic,strong)UIPickerView *pickerView3;
@property (nonatomic,strong)UIPickerView *pickerView4;

@property (nonatomic,retain)NSArray *pickerNumbers;


/**
 pickerview上显示的数字
 */
@property(nonatomic,assign)int pickerIndex1;
@property(nonatomic,assign)int pickerIndex2;
@property(nonatomic,assign)int pickerIndex3;

@property (nonatomic,retain)NSArray *showColors;
@property (nonatomic,retain)NSArray *BigCategoresArray;

@property (nonatomic,retain)NSMutableArray *fieldArray;





@end
