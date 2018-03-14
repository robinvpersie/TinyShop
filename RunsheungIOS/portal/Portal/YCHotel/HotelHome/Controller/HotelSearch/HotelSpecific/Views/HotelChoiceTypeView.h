//
//  HotelChoiceTypeView.h
//  Portal
//
//  Created by 王五 on 2017/4/9.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol choiceHotelDelegate<NSObject>

- (void)choiceHotelType:(UIButton*)sender;
@end

@interface HotelChoiceTypeView : UIView
@property(nonatomic,retain)NSMutableArray *data;
@property(nonatomic,assign)id<choiceHotelDelegate> delegate;
@end
