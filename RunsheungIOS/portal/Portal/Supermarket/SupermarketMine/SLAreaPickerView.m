//
//  SLAreaPickerView.m
//  areapicker
//
//  Created by Sealy on 15-05-20.
//  Copyright (c) 2012年 clouddai.com. All rights reserved.
//

#import "SLAreaPickerView.h"
#import <QuartzCore/QuartzCore.h>
//#import "Gobal.h"

#define kDuration 0.3

@interface SLAreaPickerView ()
{
    NSArray *_arrProvinces, *_arrCitys, *_arrAreas;
    UIPickerView *_pckSelect;
    SLAreaLocation *_locState;
}

@end

@implementation SLAreaPickerView

-(id)initWithCoder:(NSString*)sProvinceCode
          cityCode:(NSString*)sCityCode
          areaCode:(NSString*)sAreaCode
{
    self =[super initWithFrame:CGRectMake(0, 0, APPScreenWidth, APPScreenHeight)];
    if (self) {
        self.backgroundColor = RGB(236, 237, 238);
        _pckSelect=[[UIPickerView alloc] initWithFrame:CGRectZero];
        _pckSelect.backgroundColor=[UIColor whiteColor];
        _pckSelect.dataSource=self;
        _pckSelect.delegate=self;
        _pckSelect.autoresizingMask = UIViewAutoresizingNone;
        _locState=[[SLAreaLocation alloc] init];
        
        NSInteger nProvince=0;
        NSInteger nCity=0;
        NSInteger nArea=0;
        
        _arrProvinces = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"SLArea.plist" ofType:nil]];
        if(sCityCode.length){
            for (nProvince=0; nProvince<_arrProvinces.count; nProvince++) {
                NSString *sPCode=[[_arrProvinces objectAtIndex:nProvince] objectForKey:@"code"];
                if ([sPCode isEqualToString:sProvinceCode]){
                    //城市
                    if(sCityCode.length){
                        NSArray *arrCitys = [[_arrProvinces objectAtIndex:nProvince] objectForKey:@"cities"];
                        
                        for (nCity=0; nCity<arrCitys.count; nCity++) {
                            NSString *sCCode=[[arrCitys objectAtIndex:nCity] objectForKey:@"code"];
                            if ([sCityCode isEqualToString:sCCode]) {
                                //区
                                if(sAreaCode.length>0){
                                    NSArray *arrAreas= [[arrCitys objectAtIndex:nCity] objectForKey:@"areas"];
                                    
                                    for (nArea=0;nArea<arrAreas.count; nArea++) {
                                        NSString *sACode=[[arrAreas objectAtIndex:nArea] objectForKey:@"code"];
                                        if([sAreaCode isEqualToString:sACode]){
                                            break;
                                        }
                                    }
                                }
                                
                                break;
                            }
                        }
                        
                    }
                    break;
                }
            }
        }
        
        NSLog(@"Province:%d City:%d Area:%d %@",nProvince,nCity,nArea,sAreaCode);
        if (nProvince>=_arrProvinces.count) {
            nProvince=0;
        }
        
        
        
        _locState.sProvinceName = [[_arrProvinces objectAtIndex:nProvince] objectForKey:@"state"];
        _locState.sProvinceCode = [[_arrProvinces objectAtIndex:nProvince] objectForKey:@"code"];
        _arrCitys = [[_arrProvinces objectAtIndex:nProvince] objectForKey:@"cities"];
        if (nCity>=_arrCitys.count) {
            nCity=0;
        }
        _locState.sCityName = [[_arrCitys objectAtIndex:nCity] objectForKey:@"city"];
        _locState.sCityCode = [[_arrCitys objectAtIndex:nCity] objectForKey:@"code"];
        _arrAreas= [[_arrCitys objectAtIndex:nCity] objectForKey:@"areas"];
        
        if (nArea>=_arrAreas.count) {
            nArea=0;
        }
        NSLog(@"Province:%d City:%d Area:%d",nProvince,nCity,nArea);
        if(_arrAreas.count>0){
            _locState.sAreaName = [[_arrAreas objectAtIndex:nArea] objectForKey:@"area"];
            _locState.sAreaCode = [[_arrAreas objectAtIndex:nArea] objectForKey:@"code"];
        }else{
            _locState.sAreaName = @"";
            _locState.sAreaCode =@"";
        }
        
        [self addSubview:_pckSelect];
        
        [_pckSelect selectRow:nProvince inComponent:0 animated:NO];
        [_pckSelect selectRow:nCity inComponent:1 animated:NO];
        if(_arrAreas.count>0){
            [_pckSelect selectRow:nArea inComponent:2 animated:NO];
        }
        
        //触摸事件
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]  initWithTarget:self action:@selector(dismissPickerView:)];
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}

#pragma mark - PickerView lifecycle

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return [_arrProvinces count];
            break;
        case 1:
            return [_arrCitys count];
            break;
        case 2:
            return [_arrAreas count];
            break;
        default:
            return 0;
            break;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return [[_arrProvinces objectAtIndex:row] objectForKey:@"state"];
            break;
        case 1:
            return [[_arrCitys objectAtIndex:row] objectForKey:@"city"];
            break;
        case 2:
            return [[_arrAreas objectAtIndex:row] objectForKey:@"area"];
            break;
        default:
            return  @"";
            break;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            _arrCitys = [[_arrProvinces objectAtIndex:row] objectForKey:@"cities"];
            [_pckSelect selectRow:0 inComponent:1 animated:YES];
            [_pckSelect reloadComponent:1];
            
            _arrAreas = [[_arrCitys objectAtIndex:0] objectForKey:@"areas"];
            
            [_pckSelect selectRow:0 inComponent:2 animated:YES];
            [_pckSelect reloadComponent:2];
            
            _locState.sProvinceName = [[_arrProvinces objectAtIndex:row] objectForKey:@"state"];
            _locState.sProvinceCode = [[_arrProvinces objectAtIndex:row] objectForKey:@"code"];
            
            _locState.sCityName = [[_arrCitys objectAtIndex:0] objectForKey:@"city"];
            _locState.sCityCode = [[_arrCitys objectAtIndex:0] objectForKey:@"code"];
            
            if(_arrAreas.count>0){
                _locState.sAreaName = [[_arrAreas objectAtIndex:0] objectForKey:@"area"];
                _locState.sAreaCode = [[_arrAreas objectAtIndex:0] objectForKey:@"code"];
            }else{
                _locState.sAreaName = @"";
                _locState.sAreaCode =@"";
            }
            
            break;
        case 1:
            
            _arrAreas = [[_arrCitys objectAtIndex:row] objectForKey:@"areas"];
            
            [_pckSelect selectRow:0 inComponent:2 animated:YES];
            [_pckSelect reloadComponent:2];
            
            _locState.sCityName = [[_arrCitys objectAtIndex:row] objectForKey:@"city"];
            _locState.sCityCode = [[_arrCitys objectAtIndex:row] objectForKey:@"code"];
            if(_arrAreas.count>0){
                _locState.sAreaName = [[_arrAreas objectAtIndex:0] objectForKey:@"area"];
                _locState.sAreaCode = [[_arrAreas objectAtIndex:0] objectForKey:@"code"];
            }
            else{
                _locState.sAreaName = @"";
                _locState.sAreaCode =@"";
            }

            break;
        case 2:
            _locState.sAreaName = [[_arrAreas objectAtIndex:row] objectForKey:@"area"];
            _locState.sAreaCode = [[_arrAreas objectAtIndex:row] objectForKey:@"code"];
            break;
        default:
            break;
    }
    if (self.delegate!=nil) {
        if([self.delegate respondsToSelector:@selector(doSLAreaPickerView:)]) {
            [self.delegate doSLAreaPickerView:_locState];
        }
    }
    
}


#pragma mark - animation

- (void)show
{
    UIView *view = [UIApplication sharedApplication].keyWindow;
    CGFloat viewHeight = view.frame.size.height;
    CGFloat viewWidth = view.frame.size.width;
    self.frame = CGRectMake(0, 0, viewWidth, viewHeight);
    self.alpha = 0;
    
    CGFloat height = 216;
    _pckSelect.frame = CGRectMake(0, viewHeight, viewWidth, height);
    [view addSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
        _pckSelect.frame = CGRectMake(0, viewHeight-height, viewWidth, height);
    }];
    
}


#pragma mark - event
//响应添加用户事件
-(void)dismissPickerView:(id)sender
{
    UIView *view = self.window;
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.alpha = 0;
                         _pckSelect.frame = CGRectMake(0, view.frame.size.height, _pckSelect.frame.size.width, _pckSelect.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         [self removeFromSuperview];
                         
                     }];
}


@end
