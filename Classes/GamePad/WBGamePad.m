//
//  WBGamePad.m
//  BalloonFight
//
//  Created by JasioWoo on 14/11/26.
//  Copyright (c) 2014年 JasioWoo. All rights reserved.
//

#import "WBGamePad.h"

@interface WBGamePad()

@end

@implementation WBGamePad

- (instancetype)initWithFrame:(CGRect)frame withDPadSize:(CGSize)dpadSize withButtonSize:(CGSize)buttonSize {
	self = [super initWithFrame:frame];
	if (self) {
//		self.backgroundColor = [UIColor clearColor];
//		self.backgroundColor = [UIColor redColor];
		self.dpadSize = dpadSize;
		self.buttonSize = buttonSize;
		[self setup];
	}
	return self;
}

- (void)setup {
	
//	self.dpadView = [[WBGamepadDPad alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame)/2.0, CGRectGetHeight(self.frame))
//											withDPadSize:self.dpadSize];
    self.dpadView = [[WBGamepadDPad alloc] initWithFrame:self.bounds
                                            withDPadSize:self.dpadSize];
    
	[self addSubview:self.dpadView];
	
	self.buttonAView = [[WBGamepadButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame)/2.0,
																		 0,
																		 CGRectGetWidth(self.frame)/2.0, CGRectGetHeight(self.frame))
												 withButtonId:0 withButtonSize:self.buttonSize];
	[self addSubview:self.buttonAView];
	
}

- (void)setDelegate:(id<WBGamePadDelegate>)delegate {
	self.dpadView.delegate = delegate;
	self.buttonAView.delegate = delegate;
}



@end
