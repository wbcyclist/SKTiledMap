//
//  WBGamePad.h
//  BalloonFight
//
//  Created by JasioWoo on 14/11/26.
//  Copyright (c) 2014年 JasioWoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBGamepadDPad.h"
#import "WBGamepadButton.h"

@interface WBGamePad : UIView

@property (nonatomic, assign)CGSize dpadSize;
@property (nonatomic, assign)CGSize buttonSize;

@property (nonatomic, strong)WBGamepadDPad *dpadView;
@property (nonatomic, strong)WBGamepadButton *buttonAView;

@property (nonatomic, weak)id<WBGamePadDelegate>delegate;

- (instancetype)initWithFrame:(CGRect)frame withDPadSize:(CGSize)dpadSize withButtonSize:(CGSize)buttonSize;

@end
