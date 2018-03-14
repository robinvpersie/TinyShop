//
//  KLHomeViewController.m
//  Portal
//
//  Created by 左梓豪 on 2016/12/2.
//  Copyright © 2016年 linpeng. All rights reserved.
//

#import "KLHomeViewController.h"
#import "ZHSCorllHeader.h"
#import "NewPagedFlowView.h"
#import "PGIndexBannerSubiew.h"
#import "KLHomeCollectionView.h"
#import "KLRecommendCollectionView.h"
#import "KLVoteActionView.h"
#import <AFNetworking/AFNetworking.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "KLHttpTool.h"
#import "NSDictionary+Decode.h"
#import "UIImageView+ImageCache.h"

#define kAppScreenWidth     self.view.frame.size.width
#define kAppScreenHeight    self.view.frame.size.height

@interface KLHomeViewController ()<NewPagedFlowViewDelegate, NewPagedFlowViewDataSource>

//@property(nonatomic, strong) UIScrollView *mainScrollView;
//@property(nonatomic, strong) UIImageView *bannerBackGround;
//@property(nonatomic, strong) UIRefreshControl *refresh;
//@property(nonatomic, strong) KLHomeCollectionView *headerCollectionView;
//@property(nonatomic, strong) KLRecommendCollectionView *recommendCollectionView;
//@property(nonatomic, strong) NewPagedFlowView *pageFlowView;
//@property(nonatomic ,strong) KLVoteActionView *voteView;
//@property(nonatomic ,strong) UICollectionView *mainCollectionView;


@end

//@implementation KLHomeViewController
//{
//    UIPageControl *pageControl;
//    NSMutableArray *_bannnerModelArray;
//    NSMutableArray *_moviewModelArray;
//    NSMutableArray *_broadcastModelArray;
//    NSMutableArray *_voteModelArray;
//    MovieData * _live;
//    UIImageView *liveImageView;
//    
//}

//- (void)dealloc {
//    [self.pageFlowView stopTimer];
//}
//
//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    //self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
//}
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    
//    _live = [[MovieData alloc]init];
//
//    
//    [self initNavigation];
//   
//    [self initView];
//    
//    [self requestData];
//    
//    
//    
//    
//    // Do any additional setup after loading the view.
//}
//
//- (void)initNavigation {
//    self.title = @"狂乐传媒";
//    
//    UIBarButtonItem *search = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_search_001"] style:UIBarButtonItemStylePlain target:self action:@selector(goSearch)];
//    search.tintColor = [UIColor blackColor];
//    
//    UIBarButtonItem *downLoad = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_download_001"] style:UIBarButtonItemStylePlain target:self action:@selector(goDownload)];
//    downLoad.tintColor = [UIColor blackColor];
//    self.navigationItem.rightBarButtonItems = @[downLoad,search];
//    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backToHome)];
//    back.tintColor = [UIColor blackColor];
//    self.navigationItem.leftBarButtonItem = back;
//}
//
//- (void)backToHome {
//    [self dismissViewControllerAnimated:YES completion:^{
//        
//    }];
//}
//
//- (void)goDownload {
//    
//}
//
//- (void)initView {
//    
//    _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, APPScreenWidth, self.view.frame.size.height - 64 - 44)];
//    _mainScrollView.backgroundColor = [UIColor whiteColor];
//    _mainScrollView.contentSize = CGSizeMake(kAppScreenWidth, kAppScreenHeight*5);
//    [self.view addSubview:_mainScrollView];
//    
//    _refresh = [[UIRefreshControl alloc] init];
//    [_refresh addTarget:self action:@selector(refreshData:) forControlEvents:UIControlEventValueChanged];
//    [_mainScrollView addSubview:_refresh];
//    
//    //头部广告
//    _pageFlowView = [[NewPagedFlowView alloc] initWithFrame:CGRectMake(0, 0, kAppScreenWidth, (kAppScreenWidth - 74) * 9 / 16 + 24 + 10)];
//    _pageFlowView.backgroundColor = [UIColor whiteColor];
//    _pageFlowView.delegate = self;
////    _pageFlowView.pageSize = CGSizeMake(_pageFlowView.frame.size.width, _pageFlowView.frame.size.height - 200);
//    _pageFlowView.dataSource = self;
//    _pageFlowView.minimumPageAlpha = 0.5;
//    _pageFlowView.minimumPageScale = 0.95;
//    _pageFlowView.orientation = NewPagedFlowViewOrientationHorizontal;
//    
//    //提前告诉有多少页
//    //    pageFlowView.orginPageCount = self.imageArray.count;
//    _pageFlowView.isOpenAutoScroll = YES;
//    [_mainScrollView addSubview:_pageFlowView];
//    [_pageFlowView reloadData];
//    
//    //初始化pageControl
//    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, _pageFlowView.frame.size.height - 15 - 6, kAppScreenWidth, 15)];
//    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
//    pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
//    pageControl.numberOfPages = 4;
//    _pageFlowView.pageControl = pageControl;
//    [_pageFlowView addSubview:pageControl];
//    
//    UICollectionViewFlowLayout *layOut = [[UICollectionViewFlowLayout alloc] init];
//    layOut.minimumInteritemSpacing = 0;
//    layOut.minimumLineSpacing = 0;
//    layOut.itemSize = CGSizeMake(160, 110);
//    layOut.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
//    layOut.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//    
//    //横向滑动视图
//    _headerCollectionView = [[KLHomeCollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_pageFlowView.frame), kAppScreenWidth, 110) collectionViewLayout:layOut];
//    _headerCollectionView.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
//    _headerCollectionView.contentInset = UIEdgeInsetsMake(0, 10, 0, 10);
//    [_mainScrollView addSubview:_headerCollectionView];
//    
//    UIView *recommendBg = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_headerCollectionView.frame), kAppScreenWidth, 40)];
//    recommendBg.backgroundColor = [UIColor whiteColor];
//    [_mainScrollView addSubview:recommendBg];
//    
//    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 20, 20)];
//    icon.image = [UIImage imageNamed:@"icon_vediorecommend"];
//    [recommendBg addSubview:icon];
//    
//    UILabel *recommendLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(icon.frame)+10, icon.frame.origin.y, 100, icon.frame.size.height)];
//    recommendLabel.text = @"视频推荐";
//    recommendLabel.font = [UIFont systemFontOfSize:15];
//    [recommendBg addSubview:recommendLabel];
//    
//    UIButton *moreArrow = [UIButton buttonWithType:UIButtonTypeCustom];
//    moreArrow.frame = CGRectMake(kAppScreenWidth - 20 - 15, icon.frame.origin.y, 20, 20);
//    [moreArrow setImage:[UIImage imageNamed:@"icon_more_001"] forState:UIControlStateNormal];
//    [moreArrow addTarget:self action:@selector(getMoreRecommendVideo) forControlEvents:UIControlEventTouchUpInside];
//    [recommendBg addSubview:moreArrow];
//    
//    UIButton *moreTitle = [UIButton buttonWithType:UIButtonTypeCustom];
//    moreTitle.frame = CGRectMake(CGRectGetMinX(moreArrow.frame) - 30, 7, 30, 25);
//    [moreTitle setTitle:@"更多" forState:UIControlStateNormal];
//    moreTitle.titleLabel.font = [UIFont systemFontOfSize:13];
//    [moreTitle setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//    [recommendBg addSubview:moreTitle];
//    
//    //推荐视频
//    UICollectionViewFlowLayout *layOut2 = [[UICollectionViewFlowLayout alloc] init];
//    layOut2.minimumInteritemSpacing = 0;
//    layOut2.minimumLineSpacing = 0;
//    layOut2.itemSize = CGSizeMake(kAppScreenWidth/2 - 10, kAppScreenWidth/2-20);
//    layOut2.sectionInset = UIEdgeInsetsMake(5, 0, 5, 0);
//    layOut2.scrollDirection = UICollectionViewScrollDirectionVertical;
//
//    _recommendCollectionView = [[KLRecommendCollectionView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(recommendBg.frame), kAppScreenWidth-20, (kAppScreenWidth/2-20)*2+20) collectionViewLayout:layOut2];
//    [_mainScrollView addSubview:_recommendCollectionView];
//    
//    //间隙
//    UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_recommendCollectionView.frame), kAppScreenWidth, 10)];
//    bg.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
//    [_mainScrollView addSubview:bg];
//    
//    UIView *liveBG = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(bg.frame), APPScreenWidth, APPScreenWidth/5*2)];
//    liveBG.backgroundColor = [UIColor whiteColor];
//    
//    liveImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, APPScreenWidth - 30, liveBG.frame.size.height -20)];
//    liveImageView.image = [UIImage imageNamed:@"img_live"];
//    liveImageView.layer.cornerRadius = 3.0f;
//    liveImageView.contentMode = UIViewContentModeScaleAspectFill;
//    liveImageView.clipsToBounds = YES;
//    liveImageView.userInteractionEnabled = YES;
//    [liveBG addSubview:liveImageView];
//    
//    UITapGestureRecognizer *goLive = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goLiveController)];
//    [liveImageView addGestureRecognizer:goLive];
//    
//    UIButton *clickInLive = [UIButton buttonWithType:UIButtonTypeCustom];
//    clickInLive.frame = CGRectMake(liveImageView.frame.size.width - 10 - 95, liveImageView.frame.size.height - 20, 95, 20);
//    [clickInLive setTitle:@"点击进入>>" forState:UIControlStateNormal];
//    clickInLive.titleLabel.font = [UIFont systemFontOfSize:14];
//    [clickInLive setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
////    [liveImageView addSubview:clickInLive];
//    
//    [_mainScrollView addSubview:liveBG];
//    
//    //间隙2
//    UIView *space = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(liveBG.frame), APPScreenWidth, 10)];
//    space.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
//    [_mainScrollView addSubview:space];
//    
//    
//    //投票活动
//    _voteView = [[KLVoteActionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(space.frame), kAppScreenWidth, 0)];
//    [_mainScrollView addSubview:_voteView];
//    
//    _mainScrollView.contentSize = CGSizeMake(kAppScreenWidth, CGRectGetMaxY(_voteView.frame)+20);
//}
//
//
//-(void)goLiveController{
//    
//    NSString *baseurlstr = [NSString stringWithFormat:@"http://222.240.51.144:89/WAP/VideoPlay?videoId=%@&kind=3",_live.uniqueId];
////    KLPlayVideosController * playvideo = [[KLPlayVideosController alloc]initWithUrl:[NSURL URLWithString:baseurlstr]];
////    playvideo.hidesBottomBarWhenPushed = YES;
////    [self.navigationController pushViewController:playvideo animated:YES];
//    
//
//    
//}
//
//#pragma mark - 刷新数据
//- (void)refreshData:(UIRefreshControl *)refreshControl {
//    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"正在刷新"];
//       dispatch_async(dispatch_get_main_queue(), ^{
//            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//            [formatter setDateFormat:@"MMM d, h:mm a"];
//            NSString *lastUpdate = [NSString stringWithFormat:@"上次刷新 %@", [formatter stringFromDate:[NSDate date]]];
//            refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdate];
//            [self requestData];
//        });
//}
//
//#pragma mark - 请求数据
//
//- (void)requestData {
//    
//    
//    [KLHttpTool getHomePageDataWithUrl:nil success:^(id response) {
//        
//        NSNumber *status = response[@"status"];
//        if (status.integerValue == 1) {
//            NSDictionary *data = response[@"data"];
//            NSArray *bannerDataArray = data[@"bannerData"];
//            NSArray *movieDataArray = data[@"movieData"];
//            NSArray *broadCastArray = data[@"broadcastData"];
//            NSArray *voiteDataArray = data[@"voteData"];
//            NSDictionary *liveDic = data[@"live"];
//            _live.uniqueId = liveDic[@"uniqueId"];
//            _live.imgUrl = liveDic[@"imgUrl"];
//            [liveImageView sd_setImageWithURL:[NSURL URLWithString:_live.imgUrl]];
//            
//            _bannnerModelArray = @[].mutableCopy;
//            for (NSDictionary *dic in bannerDataArray) {
//                KLBannerData *data = [NSDictionary getBannerModelWithDic:dic];
//                [_bannnerModelArray addObject:data];
//            }
//            
//            _moviewModelArray = @[].mutableCopy;
//            for (NSDictionary *dic in movieDataArray) {
//                MovieData *data = [NSDictionary getMovieModelWithDic:dic];
//                [_moviewModelArray addObject:data];
//            }
//            
//            _broadcastModelArray = @[].mutableCopy;
//            for (NSDictionary *dic in broadCastArray) {
//                BroadcastData *data = [NSDictionary getBroadCastModelWithDic:dic];
//                [_broadcastModelArray addObject:data];
//            }
//            
//            _voteModelArray = @[].mutableCopy;
//            for (NSDictionary *dic in voiteDataArray) {
//                VoteData *data = [NSDictionary getVoteModelWithDic:dic];
//                [_voteModelArray addObject:data];
//            }
//            [self reloadData];
//
//        }
//    } failure:^(NSError *err) {
//        
//    }];
//     [_refresh endRefreshing];
//}
//
//- (void)reloadData {
//    pageControl.numberOfPages = _bannnerModelArray.count;
//    UIImageView *imageView = _pageFlowView.backGround;
//    [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_bannnerModelArray[0]]]];
//    [_pageFlowView reloadData];
//    
//    _headerCollectionView.dataArray = _moviewModelArray;
//    _recommendCollectionView.dataArray = _broadcastModelArray;
//    _voteView.dataArray = _voteModelArray;
//    
//}
//
///**
// 搜索
// */
//- (void)goSearch {
//    KLSearchVideoController *search = [[KLSearchVideoController alloc] init];
//    search.showTriangle = YES;
//    search.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:search animated:NO];
//}
//
///**
// 获取更多视频
// */
//- (void)getMoreRecommendVideo {
//    
//}
//
//#pragma mark NewPagedFlowView Delegate
//- (CGSize)sizeForPageInFlowView:(NewPagedFlowView *)flowView {
//    return CGSizeMake(kAppScreenWidth - 74, (kAppScreenWidth - 74) * 9 / 16 );
//}
//
//- (void)didSelectCell:(UIView *)subView withSubViewIndex:(NSInteger)subIndex {
//    
//    KLBannerData *data = _bannnerModelArray[subIndex];
//    
//    
//}
//
//#pragma mark NewPagedFlowView Datasource
//- (NSInteger)numberOfPagesInFlowView:(NewPagedFlowView *)flowView {
//    if (_bannnerModelArray.count > 0) {
//        return _bannnerModelArray.count;
//    }
//    return 4;
//}
//
//- (UIView *)flowView:(NewPagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index{
//    PGIndexBannerSubiew *bannerView = (PGIndexBannerSubiew *)[flowView dequeueReusableCell];
//    if (!bannerView) {
//        bannerView = [[PGIndexBannerSubiew alloc] initWithFrame:CGRectMake(0, 0, kAppScreenWidth - 84, (kAppScreenWidth - 84) * 9 / 16)];
//        bannerView.layer.cornerRadius = 4;
//        bannerView.layer.masksToBounds = YES;
//    }
//    
//    //在这里下载网络图片
//    if (_bannnerModelArray.count > 0) {
//        KLBannerData *data = _bannnerModelArray[index];
//        [UIImageView setimageWithImageView:bannerView.mainImageView UrlString:data.imgUrl imageVersion:data.ver];
//    } else {
//        
//    }
//    
//    
//    return bannerView;
//}
//
//- (void)didScrollToPage:(NSInteger)pageNumber inFlowView:(NewPagedFlowView *)flowView {
//    
//    NSLog(@"ViewController 滚动到了第%ld页",pageNumber);
//    UIImageView *imageView = flowView.backGround;
//    if (_bannnerModelArray.count > 0) {
//        KLBannerData *data = _bannnerModelArray[pageNumber];
//        [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",data.imgUrl]]];
//    } else {
//        
//    }
//
//}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}

//@end
