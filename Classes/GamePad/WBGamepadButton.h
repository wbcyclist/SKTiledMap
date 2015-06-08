//
//  WBGamepadButton.h
//  BalloonFight
//
//  Created by JasioWoo on 14/11/26.
//  Copyright (c) 2014年 JasioWoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBGamepadDPad.h"


@interface WBGamepadButton : UIView

@property (nonatomic, assign)int buttonId;
@property (nonatomic, assign)BOOL isPressed;
@property (nonatomic, weak)id<WBGamePadDelegate>delegate;

- (instancetype)initWithFrame:(CGRect)frame withButtonId:(int)bID withButtonSize:(CGSize)bSize;

@end
