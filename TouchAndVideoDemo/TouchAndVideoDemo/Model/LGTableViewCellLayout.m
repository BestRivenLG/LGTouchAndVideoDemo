//
//  LGTableViewCellLayout.m
//  videoDemo
//
//  Created by liangang zhan on 2018/7/1.
//  Copyright © 2018年 liangang zhan. All rights reserved.
//

#import "LGTableViewCellLayout.h"

@interface LGTableViewCellLayout ()
@property (nonatomic, assign) CGRect headerRect;
@property (nonatomic, assign) CGRect nickNameRect;
@property (nonatomic, assign) CGRect videoRect;
@property (nonatomic, assign) CGRect playBtnRect;
@property (nonatomic, assign) CGRect titleLabelRect;
@property (nonatomic, assign) CGRect maskViewRect;
@property (nonatomic, assign) BOOL isVerticalVideo;
@property (nonatomic, assign) CGFloat height;
@end

@implementation LGTableViewCellLayout
- (instancetype)initWithData:(LGTableData *)data {
    self = [super init];
    if (self) {
        _data = data;
        
        CGFloat min_x = 0;
        CGFloat min_y = 0;
        CGFloat min_w = 0;
        CGFloat min_h = 0;
        CGFloat min_view_w = [UIScreen mainScreen].bounds.size.width;
        CGFloat margin = 10;
        
//        min_x = 10;
//        min_y = 10;
//        min_w = 30;
//        min_h = min_w;
        self.headerRect = CGRectMake(min_x, min_y, min_w, min_h);
        
//        min_x = CGRectGetMaxX(self.headerRect) + 10;
//        min_y = 18;
//        min_w = [self textSizeWithString:data.nick_name Font:[UIFont systemFontOfSize:15] limitWidth:min_view_w-2*margin-min_x].width;
//        min_h = 15;
        self.nickNameRect = CGRectMake(min_x, min_y, min_w, min_h);
        
        min_x = 0;
        min_y = CGRectGetMaxY(self.headerRect)+margin;
        min_w = min_view_w;
        min_h = self.videoHeight;
        self.videoRect = CGRectMake(min_x, min_y, min_w, min_h);
        
        min_w = 44;
        min_h = min_w;
        min_x = (CGRectGetWidth(self.videoRect)-min_w)/2;
        min_y = (CGRectGetHeight(self.videoRect)-min_h)/2;
        self.playBtnRect = CGRectMake(min_x, min_y, min_w, min_h);
        
//        min_x = margin;
//        min_y = CGRectGetMaxY(self.videoRect) + margin;
//        min_w = CGRectGetWidth(self.videoRect) - 2*margin;
//        min_h = [self textSizeWithString:data.title Font:[UIFont systemFontOfSize:15] numberOfLines:0 constrainedWidth:min_w].height;
        self.titleLabelRect = CGRectMake(min_x, min_y, min_w, min_h);
        
//        self.height = CGRectGetMaxY(self.titleLabelRect)+margin;
        
        min_x = 0;
        min_y = 0;
        min_w = min_view_w;
        min_h = self.height;
        self.maskViewRect = CGRectMake(min_x, min_y, min_w, min_h);
        self.height = CGRectGetMaxY(self.videoRect);

        
    }
    return self;
}

- (CGSize)textSizeWithString:(NSString *)string Font:(UIFont*)font
             numberOfLines:(NSInteger)numberOfLines
          constrainedWidth:(CGFloat)constrainedWidth{
    
    if (string.length == 0) {
        return CGSizeZero;
    }
    CGFloat oneLineHeight = font.lineHeight;
    CGSize textSize = [string boundingRectWithSize:CGSizeMake(constrainedWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    //  行数
    CGFloat rows = textSize.height / oneLineHeight;
    CGFloat realHeight = oneLineHeight;
    // 0 不限制行数，真实高度加上行间距
    if (numberOfLines == 0) {
        if (rows >= 1) {
            realHeight = (rows * oneLineHeight) + (rows - 1) ;
        }
    } else {
        //  行数超过指定行数的时候，限制行数
        if (rows > numberOfLines) {
            rows = numberOfLines;
        }
        realHeight = (rows * oneLineHeight) + (rows - 1) ;
    }
    //  返回真实的宽高
    return CGSizeMake(constrainedWidth, realHeight);
}

/// 计算字符串长度（一行时候）
- (CGSize)textSizeWithString:(NSString *)string Font:(UIFont*)font
                limitWidth:(CGFloat)maxWidth {
    CGSize size = [string boundingRectWithSize:CGSizeMake(MAXFLOAT, 36)options:(NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)  attributes:@{ NSFontAttributeName : font} context:nil].size;
    size.width = size.width > maxWidth ? maxWidth : size.width;
    size.width = ceil(size.width);
    size.height = ceil(size.height);
    return size;
}


- (BOOL)isVerticalVideo {
    return _data.video_width < _data.video_height;
}

- (CGFloat)videoHeight {
    CGFloat videoHeight;
    if (self.isVerticalVideo) {
        videoHeight = [UIScreen mainScreen].bounds.size.width * 0.6 * self.data.video_height/self.data.video_width;
    } else {
        videoHeight = [UIScreen mainScreen].bounds.size.width * self.data.video_height/self.data.video_width;
    }
    return videoHeight;
}
@end
