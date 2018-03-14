//
//  SupermarketAllKindsCollectionView.m
//  Portal
//
//  Created by ifox on 2016/12/29.
//  Copyright © 2016年 linpeng. All rights reserved.
//

#import "SupermarketAllKindsCollectionView.h"
#import "AllKindsCollectionViewCell.h"
#import "SupermarketKindsViewController.h"
#import "UIView+ViewController.h"
#import "SupermarketKindModel.h"

@interface SupermarketAllKindsCollectionView ()<UICollectionViewDelegate, UICollectionViewDataSource>

@end

@implementation SupermarketAllKindsCollectionView {
    NSArray *_imageNames;
    NSArray *_titles;
    NSArray *_englishTitles;
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.scrollEnabled = NO;
        self.backgroundColor = BGColor;
        _imageNames = @[@"seafood",@"vegetable",@"fresh_fruit",@"fresh_meat",@"frozen_goods",@"milk",@"drinks",@"oil",@"lmported_food",@"kitchen_stuff"];
        _titles = @[@"水产海鲜.",@"蔬菜豆菇.",@"新鲜水果.",@"鲜肉蛋禽.",@"速食冻品.",@"牛奶面点.",@"酒水零食.",@"粮油副食.",@"进口食品.",@"厨房用品."];
        _englishTitles = @[@"Seafood",@"Vegetable",@"Fresh fruit",@"Fresh meat",@"Frozen goods",@"The milk",@"Drinks",@"Grain and oil",@"Lmported food",@"Kitchen stuff"];
        UINib *nib = [UINib nibWithNibName:@"AllKindsCollectionViewCell" bundle:nil];
        [self registerNib:nib forCellWithReuseIdentifier:@"AllKindsCollectionViewCell"];
        self.dataSource = self;
        self.delegate = self;
    }
    return self;
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
    if (self.dataArray.count > 0) {
        return self.dataArray.count+1;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    AllKindsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AllKindsCollectionViewCell" forIndexPath:indexPath];
    cell.englishTitleLabel.hidden = YES;
    cell.backgroundColor = [UIColor whiteColor];
    if ((indexPath.row +indexPath.section*3) != self.dataArray.count) {
        if (self.dataArray.count > 0) {
            SupermarketKindModel *model = self.dataArray[indexPath.item];
            cell.titleLabel.text = model.category_name;
            cell.englishTitleLabel.text = model.category_name_en;
            [UIImageView setimageWithImageView:cell.iconImageView UrlString:model.icon_url imageVersion:nil];
        }
        
        return cell;
    }else{
        return cell;
    }
   
    

}


#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    SupermarketKindsViewController *kinds = [[SupermarketKindsViewController alloc] init];
    if ((indexPath.row +indexPath.section*3) != self.dataArray.count) {
        if (self.dataArray.count > 0) {
            SupermarketKindModel *model = self.dataArray[indexPath.item];
            kinds.category_code = model.category_code;
            kinds.level = model.level;
        }
        kinds.hidesBottomBarWhenPushed = YES;
        [self.viewController.navigationController pushViewController:kinds animated:YES];
        NSLog(@"点击单元格");
        NSLog(@"%@",indexPath);

    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender {
    
    return YES;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 1;
}

- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
    [NSOperationQueue.mainQueue addOperationWithBlock:^{
        [self reloadData];
    }];
}


@end
