//
//  UIDynamicAnimator+AAPLDebugInterfaceOnly.h
//  CoreEffect
//
//  Created by ZhengWei on 16/4/19.
//  Copyright © 2016年 Bourbon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDynamicAnimator (AAPLDebugInterfaceOnly)
@property (nonatomic, getter=isDebugEnabled) BOOL debugEnabled;
@end
