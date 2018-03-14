//
//  KLTabOnlineVideoView.m
//  Portal
//
//  Created by PENG LIN on 2017/1/16.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "KLTabOnlineVideoView.h"

#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenWidth [UIScreen mainScreen].bounds.size.width


@interface KLTabOnlineVideoView()

@property (nonatomic,strong)UIView * containerView;
@property (nonatomic,assign)BOOL isFirstAdd;
@property (nonatomic,strong)UIView *onlineVideoView;


@end

@implementation KLTabOnlineVideoView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        self.isFirstAdd = YES;
    }
    return self;
}


-(void)didMoveToSuperview{
    [super didMoveToSuperview];
    if (self.isFirstAdd){
        [self makeUI];
        self.isFirstAdd = NO;
    }

}

-(void)hide{
   [UIView animateWithDuration:0.2 animations:^{
       self.containerView.backgroundColor = [UIColor clearColor];
   } completion:^(BOOL finished) {
       [self removeFromSuperview];
   }];
    
   [UIView animateWithDuration:0.2 animations:^{
       self.containerView.backgroundColor = [UIColor clearColor];
   } completion:^(BOOL finished) {
       [self removeFromSuperview];
   }];
}

-(void)hideAnddo:(int)type{
    
      [UIView animateWithDuration:0.2 animations:^{
          self.containerView.alpha  = 0;
      } completion:^(BOOL finished) {
          [self removeFromSuperview];
      }];
    double delayInSeconds = 0.1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^{
        if (_afterHideAction) {
             _afterHideAction(type);
        }
    });

}

-(void)showInView:(UIView *)view {
    self.frame = view.frame;
    [view addSubview:self];
}


-(void)makeUI{
    [self addSubview:self.containerView];
    [self addSubview:self.onlineVideoView];

}

-(UIView *)containerView{
    if (!_containerView){
        UIView * container = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        container.backgroundColor = [UIColor blackColor];
        container.alpha = 0.2;
        container.userInteractionEnabled = YES;
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hide)];
        [container addGestureRecognizer:gesture];
        gesture.cancelsTouchesInView = YES;
        return container;
    }
    return _containerView;
}

-(UIView *)onlineVideoView {
    if (!_onlineVideoView){
       UIView *onlineVideo = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height*2/3 ,self.frame.size.width , self.frame.size.height/3)];
        onlineVideo.backgroundColor = [UIColor whiteColor];
       UIImageView *showTicket = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth/4 - kScreenWidth/8, 30, kScreenWidth/4, kScreenWidth/4)];
            showTicket.contentMode = UIViewContentModeScaleAspectFit;
            showTicket.image = [UIImage imageNamed:@"icon_entertainments-"];
            showTicket.userInteractionEnabled = YES;
            [onlineVideo addSubview:showTicket];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didclickShow)];
        [showTicket addGestureRecognizer:tap];

        UIButton *showTicketButton = [UIButton buttonWithType:UIButtonTypeCustom];
        showTicketButton.frame = CGRectMake(showTicket.frame.origin.x, CGRectGetMaxY(showTicket.frame), showTicket.frame.size.width, 20);
        [showTicketButton setTitle:@"演出门票" forState:UIControlStateNormal];
        showTicketButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [showTicketButton addTarget:self action:@selector(didclickShow) forControlEvents:UIControlEventTouchUpInside];
        [showTicketButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [onlineVideo addSubview:showTicketButton];

        UIImageView *moviewTicket = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - kScreenWidth/4 -kScreenWidth/8, showTicket.frame.origin.y, showTicket.frame.size.width, showTicket.frame.size.height)];
        moviewTicket.contentMode = UIViewContentModeScaleAspectFit;
        moviewTicket.userInteractionEnabled = YES;
        moviewTicket.image = [UIImage imageNamed:@"icon_movie"];
        UITapGestureRecognizer *movietap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didclickMovie)];
        [moviewTicket addGestureRecognizer:movietap];
        [onlineVideo addSubview:moviewTicket];
//
        UIButton *movieTicketButton = [UIButton buttonWithType:UIButtonTypeCustom];
        movieTicketButton.frame = CGRectMake(moviewTicket.frame.origin.x, CGRectGetMaxY(moviewTicket.frame), moviewTicket.frame.size.width, 20);
        [movieTicketButton setTitle:@"电影票" forState:UIControlStateNormal];
        [movieTicketButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        movieTicketButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [movieTicketButton addTarget:self action:@selector(didclickMovie) forControlEvents:UIControlEventTouchUpInside];
        [onlineVideo addSubview:movieTicketButton];
//
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, onlineVideo.frame.size.height - 40, kScreenWidth, 0.7f)];
        line.backgroundColor = [UIColor lightGrayColor];
        [onlineVideo addSubview:line];
//
        UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
        cancel.frame = CGRectMake(kScreenWidth/2-15, CGRectGetMaxY(line.frame)+5, 30, 30);
        [cancel setImage:[UIImage imageNamed:@"icon_ticketoff"] forState:UIControlStateNormal];
        [cancel addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
        [onlineVideo addSubview:cancel];


          return onlineVideo;
    }
    return _onlineVideoView;
}

-(void)didclickMovie{
    [self hideAnddo:1];
}

-(void)didclickShow{
    [self hideAnddo:0];
}

@end


