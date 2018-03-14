//
//  RSSpecialGoodsMedicine.m
//  Portal
//
//  Created by zhengzeyou on 2018/1/9.
//  Copyright © 2018年 linpeng. All rights reserved.
//

#import "RSSpecialGoodsMedicineView.h"
#import "RSSpecialGoodsMedicineCell.h"
@implementation RSSpecialGoodsMedicineView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self initView];
        
        
    }
    return self;
}
//创建子视图
- (void)initView{
  
    //特价好药
    UILabel *titlelabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, 80, 30)];
    titlelabel.text = @"特价好药";
    titlelabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titlelabel];
    
    //查看更多的按钮
    UIButton *morebtn = [[UIButton alloc]initWithFrame:CGRectMake(APPScreenWidth- 80, 5, 80, 30)];
    [morebtn setTitle:@"查看更多" forState:UIControlStateNormal];
    [morebtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [morebtn setTitleColor:RGB(160, 160, 160) forState:UIControlStateNormal];
    [self addSubview:morebtn];
    
    [self createCollectionView];
    
}

//创建表视图
- (void)createCollectionView{
    
    UICollectionViewFlowLayout *layOut = [[UICollectionViewFlowLayout alloc] init];
    layOut.minimumInteritemSpacing = 4;
    layOut.minimumLineSpacing = 4;
    layOut.itemSize = CGSizeMake(APPScreenWidth /2 -10, APPScreenWidth/2 -10);
    layOut.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    layOut.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 30, APPScreenWidth, self.frame.size.height- 30) collectionViewLayout:layOut];
    [_collectionView registerNib:[UINib nibWithNibName:@"RSSpecialGoodsMedicineCell" bundle:nil] forCellWithReuseIdentifier:@"RSSpecialGoodsMedicineCell"];
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_collectionView];
}

#pragma mark - UICollectionViewDataSource

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath {
    NSLog(@"移动单元格");
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    RSSpecialGoodsMedicineCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RSSpecialGoodsMedicineCell" forIndexPath:indexPath];
    
    return cell;
}

@end
