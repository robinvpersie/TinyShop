//
//  HotelSpecificTableCell.h
//  
//
//  Created by 王五 on 2017/4/8.
//
//

#import <UIKit/UIKit.h>
@protocol HotelSpecificDelegate<NSObject>

- (void)sumbitAction:(id)viewVC;

@end
@class HotelRoomTypeModel;
@interface HotelSpecificTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImg;
@property (weak, nonatomic) IBOutlet UILabel *roomTypeLab;
@property (weak, nonatomic) IBOutlet UILabel *roomDeviceLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UIButton *upDownBtn;
@property (weak, nonatomic) IBOutlet UIButton *orderbutton;

@property (nonatomic,strong)HotelRoomTypeModel *roommodel;
@property (nonatomic, copy) NSString *hotelID;
@property (nonatomic, copy) NSString *hotelName;

@property (nonatomic, assign)id<HotelSpecificDelegate> delegate;
@end
