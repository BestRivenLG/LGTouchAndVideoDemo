//
//  LGTableData.h
//  videoDemo
//
//  Created by liangang zhan on 2018/7/1.
//  Copyright © 2018年 liangang zhan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LGTableData : NSObject
@property (nonatomic, copy) NSString *nick_name;
@property (nonatomic, copy) NSString *head;
@property (nonatomic, assign) NSInteger agree_num;
@property (nonatomic, assign) NSInteger share_num;
@property (nonatomic, assign) NSInteger post_num;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) CGFloat thumbnail_width;
@property (nonatomic, assign) CGFloat thumbnail_height;
@property (nonatomic, assign) CGFloat video_duration;
@property (nonatomic, assign) CGFloat video_width;
@property (nonatomic, assign) CGFloat video_height;
@property (nonatomic, assign) long video_length;
@property (nonatomic, assign) long video_size;
@property (nonatomic, copy) NSString *thumbnail_url;
@property (nonatomic, copy) NSString *video_url;
@end
