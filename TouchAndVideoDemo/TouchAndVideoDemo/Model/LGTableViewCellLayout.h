//
//  LGTableViewCellLayout.h
//  videoDemo
//
//  Created by liangang zhan on 2018/7/1.
//  Copyright © 2018年 liangang zhan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LGTableData.h"

@interface LGTableViewCellLayout : NSObject
@property (nonatomic, strong) LGTableData *data;
@property (nonatomic, readonly) CGRect headerRect;
@property (nonatomic, readonly) CGRect nickNameRect;
@property (nonatomic, readonly) CGRect videoRect;
@property (nonatomic, readonly) CGRect playBtnRect;
@property (nonatomic, readonly) CGRect titleLabelRect;
@property (nonatomic, readonly) CGRect maskViewRect;
@property (nonatomic, readonly) CGFloat height;
@property (nonatomic, readonly) BOOL isVerticalVideo;

- (instancetype)initWithData:(LGTableData *)data;
@end
