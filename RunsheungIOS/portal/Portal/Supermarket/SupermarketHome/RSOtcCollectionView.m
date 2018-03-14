//
//  RSOtcCollectionView.m
//  Portal
//
//  Created by zhengzeyou on 2018/1/9.
//  Copyright © 2018年 linpeng. All rights reserved.
//

#import "RSOtcCollectionView.h"
#import "RSOTCCollectionViewCell.h"
@implementation RSOtcCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
        UINib *nib = [UINib nibWithNibName:@"RSOTCCollectionViewCell" bundle:nil];
        [self registerNib:nib forCellWithReuseIdentifier:@"RSOTCCollectionViewCell"];
        self.showsVerticalScrollIndicator = NO;
        self.backgroundColor = [UIColor whiteColor];
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
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
   
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    RSOTCCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RSOTCCollectionViewCell" forIndexPath:indexPath];
   
    return cell;
}



@end
