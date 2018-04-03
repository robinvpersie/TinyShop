//
//  HotelReseveResultInfoTableViewCell.m
//  Portal
//
//  Created by ifox on 2017/4/14.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "HotelReseveResultInfoTableViewCell.h"
#import "UILabel+CreateLabel.h"
#import "UIButton+CreateButton.h"
#import "UILabel+WidthAndHeight.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface HotelReseveResultInfoTableViewCell ()

@property (nonatomic, strong) NSString *urlScheme;
@property (nonatomic, strong) NSString *appName;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@end

@implementation HotelReseveResultInfoTableViewCell {
    UIButton *_checkRoute;
    UIButton *_checkHotel;
    UIButton *_contactHotel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubView];
    }
    return self;
}

- (void)createSubView {
    if (_hotelName == nil) {
        _hotelName = [UILabel createLabelWithFrame:CGRectMake(10, 10, 250, 40) textColor:HotelBlackColor font:[UIFont systemFontOfSize:15] textAlignment:NSTextAlignmentLeft text:@"长沙宇成国际酒店"];
    }
    [self.contentView addSubview:_hotelName];
    
    if (_hotelLocation == nil) {
        _hotelLocation = [UILabel createLabelWithFrame:CGRectMake(_hotelName.frame.origin.x, CGRectGetMaxY(_hotelName.frame), APPScreenWidth - 20, 40) textColor:HotelLightGrayColor font:[UIFont systemFontOfSize:12] textAlignment:NSTextAlignmentLeft text:@"人民东路139号(地铁2号线万家丽广场1出口步行8分钟) 近芙蓉区政府"];
        _hotelLocation.numberOfLines = 0;
    }
    [self.contentView addSubview:_hotelLocation];
    
    if (_checkRoute == nil) {
        _checkRoute = [UIButton createButtonWithFrame:CGRectMake(0, CGRectGetMaxY(_hotelLocation.frame)+10, APPScreenWidth/2, 40) title:NSLocalizedString(@"HotelCheckRoute", nil) titleColor:PurpleColor titleFont:[UIFont systemFontOfSize:15] backgroundColor:[UIColor whiteColor]];
        [_checkRoute setImage:[UIImage imageNamed:@"icon_mapsmall"] forState:UIControlStateNormal];
        [_checkRoute addTarget:self action:@selector(checkRoute) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.contentView addSubview:_checkRoute];
    
    if (_checkHotel == nil) {
        CGFloat width = [UILabel getWidthWithTitle:@"查看商家 >" font:[UIFont systemFontOfSize:14]];
        _checkHotel = [UIButton createButtonWithFrame:CGRectMake(APPScreenWidth - 10 - width, _hotelName.frame.origin.y, width, 40) title:@"查看商家 >" titleColor:PurpleColor titleFont:[UIFont systemFontOfSize:14] backgroundColor:[UIColor whiteColor]];
        [_checkHotel addTarget:self action:@selector(checkHotel) forControlEvents:UIControlEventTouchUpInside];
        _checkHotel.hidden = YES;
    }
    [self.contentView addSubview:_checkHotel];
    
    if (_contactHotel == nil) {
        _contactHotel = [UIButton createButtonWithFrame:CGRectMake(APPScreenWidth - APPScreenWidth/2, _checkRoute.frame.origin.y, APPScreenWidth/2, _checkRoute.frame.size.height) title:NSLocalizedString(@"HotelContactHotel", nil) titleColor:PurpleColor titleFont:[UIFont systemFontOfSize:15] backgroundColor:[UIColor whiteColor]];
        [_contactHotel setImage:[UIImage imageNamed:@"icon_hoteltelesmall"] forState:UIControlStateNormal];
        [_contactHotel addTarget:self action:@selector(contactHotel) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.contentView addSubview:_contactHotel];
    
    UIView *upLine = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(_contactHotel.frame)-0.7f, APPScreenWidth, 0.7f)];
    upLine.backgroundColor = BorderColor;
    [self.contentView addSubview:upLine];
    
    UIView *downLine = [[UIView alloc] initWithFrame:CGRectMake(APPScreenWidth/2, upLine.frame.origin.y + 5, 0.7f, 30)];
    downLine.backgroundColor = BorderColor;
    [self.contentView addSubview:downLine];
}

- (void)checkHotel {
    [MBProgressHUD hideAfterDelayWithView:KEYWINDOW interval:1.5f text:@"暂未开放"];
}

- (void)contactHotel {
    UIAlertAction *call = [UIAlertAction actionWithTitle:NSLocalizedString(@"HotelCallTitle", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",self.oderDetail.hotelPhoneNum];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"SMAlertCancelTitle", nil) style:UIAlertActionStyleCancel handler:nil];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"HotelCallMsg", nil) message:self.oderDetail.hotelPhoneNum preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:call];
    [alert addAction:cancel];
    
    [self.viewController presentViewController:alert animated:YES completion:nil];
}

- (void)checkRoute {
//    [MBProgressHUD hideAfterDelayWithView:KEYWINDOW interval:1.5f text:@"暂未开放"];
    self.coordinate = CLLocationCoordinate2DMake([self.oderDetail.latitude floatValue],[ self.oderDetail.longtitude floatValue]);
    [self startDaoHang];
}

- (void)startDaoHang
{
    
    __block NSString *urlScheme = self.urlScheme;
    __block NSString *appName = self.appName;
    __block CLLocationCoordinate2D coordinate = self.coordinate;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"HotelMapChoose", nil) message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    
    if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"http://maps.apple.com/"]])
    {
        UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"HotelMapApple", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
            MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:coordinate addressDictionary:nil]];
            
            [MKMapItem openMapsWithItems:@[currentLocation, toLocation]
                           launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]}];
        }];
        
        [alert addAction:action];
    }
    
    if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]])
    {
        UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"HotelMapBaidu", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name=目的地&mode=driving&coord_type=gcj02",coordinate.latitude, coordinate.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
            
        }];
        
        [alert addAction:action];
    }
    
    
    if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]])
    {
        UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"HotelMapGaode", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            NSString *urlString = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&lat=%f&lon=%f&dev=0&style=3",appName,urlScheme,coordinate.latitude, coordinate.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
            
        }];
        
        [alert addAction:action];
    }
    
    if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]])
    {
        UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"HotelMapGoogle", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            NSString *urlString = [[NSString stringWithFormat:@"comgooglemaps://?x-source=%@&x-success=%@&saddr=&daddr=%f,%f&directionsmode=driving",appName,urlScheme,coordinate.latitude, coordinate.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
            
        }];
        
        [alert addAction:action];
    }
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"SMAlertCancelTitle", nil) style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action];
    
    [self.viewController presentViewController:alert animated:YES completion:^{
        
    }];
}


@end
