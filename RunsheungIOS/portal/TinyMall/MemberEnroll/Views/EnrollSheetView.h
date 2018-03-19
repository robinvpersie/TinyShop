//
//  EnrollSheetView.h
//  Portal
//
//  Created by dlwpdlr on 2018/3/19.
//  Copyright © 2018年 linpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EnrollSheetViewDelegate<NSObject>

- (void)click:(int)index  selfTag:(int)selftag;
@end;
@interface EnrollSheetView : UIView

@property (nonatomic,assign)id<EnrollSheetViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame withBtntitles:(NSArray*)titles;
@end
