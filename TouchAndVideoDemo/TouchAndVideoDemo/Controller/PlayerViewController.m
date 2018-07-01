//
//  PlayerViewController.m
//  videoDemo
//
//  Created by liangang zhan on 2018/6/30.
//  Copyright © 2018年 liangang zhan. All rights reserved.
//

#import "PlayerViewController.h"
#import "ZFAVPlayerManager.h"
#import "ZFPlayerControlView.h"
#import "ZFPlayerController.h"
#import "ZFPlayer.h"

#import "LGTableData.h"
#import "LGTableViewCellLayout.h"
#import "ZFTableViewCell.h"


static NSString *kIdentifier = @"kIdentifier";

@interface PlayerViewController ()<UITableViewDelegate,UITableViewDataSource,ZFTableViewCellDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) ZFPlayerController *player;
@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) ZFPlayerControlView *controlView;
@property (nonatomic, strong) NSArray <NSURL *>*assetURLs;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *urls;

@end

@implementation PlayerViewController

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [UIView new];
        _containerView.backgroundColor = [UIColor orangeColor];
    }
    return _containerView;
}

- (UIButton *)playBtn {
    if (!_playBtn) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playBtn setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        [_playBtn addTarget:self action:@selector(playClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playBtn;
}

- (ZFPlayerControlView *)controlView {
    if (!_controlView) {
        _controlView = [ZFPlayerControlView new];
    }
    return _controlView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_tableView registerClass:[ZFTableViewCell class] forCellReuseIdentifier:kIdentifier];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        /// 停止的时候找出最合适的播放
        @weakify(self)
        _tableView.zf_scrollViewDidStopScrollCallback = ^(NSIndexPath * _Nonnull indexPath) {
            @strongify(self)
            [self playTheVideoAtIndexPath:indexPath scrollToTop:NO];
        };
    }
    return _tableView;
}

/// play the video
- (void)playTheVideoAtIndexPath:(NSIndexPath *)indexPath scrollToTop:(BOOL)scrollToTop {
    [self.player playTheIndexPath:indexPath scrollToTop:scrollToTop];
    LGTableViewCellLayout *layout = self.dataSource[indexPath.row];
    [self.controlView showTitle:layout.data.title
                 coverURLString:layout.data.thumbnail_url
                 fullScreenMode:layout.isVerticalVideo?ZFFullScreenModePortrait:ZFFullScreenModeLandscape];
}

- (void)setupTableViewUI {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self requestData];
    /// playerManager
    ZFAVPlayerManager *playerManager = [[ZFAVPlayerManager alloc] init];
    
    /// player
    self.player = [ZFPlayerController playerWithScrollView:self.tableView playerManager:playerManager containerViewTag:100];

//    self.player = [ZFPlayerController playerWithPlayerManager:playerManager containerView:self.containerView];
    self.player.controlView = self.controlView;
    self.player.assetURLs = self.urls;
    
    @weakify(self)
    self.player.playerDidToEnd = ^(id  _Nonnull asset) {
        @strongify(self)
        if (self.player.playingIndexPath.row < self.urls.count - 1 && !self.player.isFullScreen) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.player.playingIndexPath.row+1 inSection:0];
            [self playTheVideoAtIndexPath:indexPath scrollToTop:YES];
        } else if (self.player.isFullScreen) {
            [self.player enterFullScreen:NO animated:YES];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.player.orientationObserver.duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.player stopCurrentPlayingCell];
            });
        }
    };
    
    self.player.orientationWillChange = ^(ZFPlayerController * _Nonnull player, BOOL isFullScreen) {
        @strongify(self)
        [self setNeedsStatusBarAppearanceUpdate];
        self.tableView.scrollsToTop = !isFullScreen;
    };
}

- (void)setupLoadViewUI {
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.containerView];
    [self.containerView addSubview:self.playBtn];
    ZFAVPlayerManager
     *playerManager = [[ZFAVPlayerManager alloc] init];
    self.player = [ZFPlayerController playerWithPlayerManager:playerManager containerView:self.containerView];
    self.player.shouldAutoPlay = YES;
    
    self.player.controlView = self.controlView;
    
    @weakify(self)
    self.player.orientationWillChange = ^(ZFPlayerController * _Nonnull player, BOOL isFullScreen) {
        @strongify(self)
        [self setNeedsStatusBarAppearanceUpdate];
    };
    
    self.player.playerDidToEnd = ^(id  _Nonnull asset) {
        @strongify(self)
        if (self.player.isFullScreen) {
            [self.player enterFullScreen:NO animated:YES];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.player.orientationObserver.duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.player stop];
            });
        } else {
            [self.player stop];
        }
    };
    
    self.assetURLs = @[[NSURL URLWithString:@"http://flv3.bn.netease.com/tvmrepo/2018/6/H/9/EDJTRBEH9/SD/EDJTRBEH9-mobile.mp4"]];//@"http://wvideo.spriteapp.cn/video/2018/0630/f7c63ee6-7bf2-11e8-a53c-0026b938a8ac_wpd.mp4"]];//
    self.player.assetURLs = self.assetURLs;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (_isSingle) {
        [self setupLoadViewUI];
    }else {
        [self setupTableViewUI];
    }
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_isSingle) {
        [self performSelector:@selector(playClick:) withObject:self.playBtn];
        
        if (self.player.currentPlayerManager.isPreparedToPlay) {
            [self.player addDeviceOrientationObserver];
            if(self.player.isPauseByEvent){
                self.player.pauseByEvent = NO;
            }
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.player.currentPlayerManager.isPreparedToPlay) {
        [self.player removeDeviceOrientationObserver];
        if (self.player.currentPlayerManager.isPlaying) {
            self.player.pauseByEvent = YES;
        }
    }
}

- (void)playClick:(UIButton *)sender {
    [self.player playTheIndex:0];
    [self.controlView showTitle:@"" coverURLString:@"" fullScreenMode:ZFFullScreenModeLandscape];
}

- (void)requestData {
    self.urls = @[].mutableCopy;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSDictionary *rootDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
    self.dataSource = @[].mutableCopy;
    NSArray *videoList = [rootDict objectForKey:@"list"];
    for (NSDictionary *dataDic in videoList) {
        LGTableData *data = [[LGTableData alloc] init];
        [data setValuesForKeysWithDictionary:dataDic];
        LGTableViewCellLayout *layout = [[LGTableViewCellLayout alloc] initWithData:data];
        [self.dataSource addObject:layout];
        NSString *URLString = [data.video_url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSURL *url = [NSURL URLWithString:URLString];
        [self.urls addObject:url];
    }
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    if (self.player.isFullScreen) {
        return UIStatusBarStyleLightContent;
    }
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden {
    return self.player.isStatusBarHidden;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    if (_isSingle) {
        [self setupLoadViewFrame];
    }else {
        [self setuptableViewFrame];
    }
}

- (void)setuptableViewFrame {
    CGFloat y = CGRectGetMaxY(self.navigationController.navigationBar.frame);
    CGFloat h = CGRectGetMaxY(self.view.frame);
    self.tableView.frame = CGRectMake(0, y, self.view.frame.size.width, h-y);
}

- (void)setupLoadViewFrame {
    CGFloat x = 0;
    CGFloat y = CGRectGetMaxY(self.navigationController.navigationBar.frame);
    CGFloat w = CGRectGetWidth(self.view.frame);
    CGFloat h = w*9/16;
    self.containerView.frame = CGRectMake(x, y, w, h);
    
    w = 44;
    h = w;
    x = (CGRectGetWidth(self.containerView.frame)-w)/2;
    y = (CGRectGetHeight(self.containerView.frame)-h)/2;
    self.playBtn.frame = CGRectMake(x, y, w, h);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    
    if (_isSingle) {
        
    }else {
        @weakify(self)
        [self.tableView zf_filterShouldPlayCellWhileScrolled:^(NSIndexPath *indexPath) {
            @strongify(self)
            [self playTheVideoAtIndexPath:indexPath scrollToTop:NO];
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ZFTableViewCellDelegate

- (void)zf_playTheVideoAtIndexPath:(NSIndexPath *)indexPath {
    [self playTheVideoAtIndexPath:indexPath scrollToTop:NO];
}
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZFTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kIdentifier];
    [cell setDelegate:self withIndexPath:indexPath];
    cell.layout = self.dataSource[indexPath.row];
    [cell setNormalMode];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self playTheVideoAtIndexPath:indexPath scrollToTop:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    LGTableViewCellLayout *layout = self.dataSource[indexPath.row];
    return layout.height;
}

@end
