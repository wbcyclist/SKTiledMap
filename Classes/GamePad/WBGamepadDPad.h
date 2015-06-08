//
//  WBGamepadDPad.h
//  BalloonFight
//
//  Created by JasioWoo on 14/11/26.
//  Copyright (c) 2014年 JasioWoo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, WBGamepadDirection) {
	WBGamepadNoDirection = 0,
	WBGamepadNorth,		// ↑
	WBGamepadSouth,		// ↓
	WBGamepadWest,		// ←
	WBGamepadEast,		// →
	WBGamepadNorthWest,	// ↖︎
	WBGamepadNorthEast,	// ↗︎
	WBGamepadSouthWest,	// ↙︎
	WBGamepadSouthEast	// ↘︎
};

@protocol WBGamePadDelegate <NSObject>
@optional
- (void)gamePadDPadDidActive:(BOOL)active;
- (void)gamePadDPadDidUpdateAngle:(float)angle;
- (void)gamePadDPadDidUpdateDirection:(WBGamepadDirection)direction;
- (void)gamePadButtonDidPressed:(BOOL)isPressed withId:(int)buttonId;

@end

@interface WBGamepadDPad : UIView

@property (nonatomic, assign)BOOL isActive;
@property (nonatomic, assign)CGFloat angle;
@property (nonatomic, assign)WBGamepadDirection direction;

@property (nonatomic, weak)id<WBGamePadDelegate>delegate;

- (instancetype)initWithFrame:(CGRect)frame withDPadSize:(CGSize)dpadSize;



@end
