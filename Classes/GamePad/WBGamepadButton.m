//
//  WBGamepadButton.m
//  BalloonFight
//
//  Created by JasioWoo on 14/11/26.
//  Copyright (c) 2014年 JasioWoo. All rights reserved.
//

#import "WBGamepadButton.h"


@interface WBGamepadButton ()

@property (nonatomic, assign)CGSize buttonSize;

@property(nonatomic, strong) UIView *dpadDrawView;
@property(nonatomic, strong) CAShapeLayer *dPadCircleCtrl;
@property(nonatomic, strong) CAShapeLayer *dPadDiscCtrl;

@end

@implementation WBGamepadButton

- (instancetype)initWithFrame:(CGRect)frame withButtonId:(int)bID withButtonSize:(CGSize)bSize {
	self = [super initWithFrame:frame];
	if (self) {
		self.buttonId = bID;
		self.buttonSize = bSize;
		[self setup];
	}
	return self;
	
}

- (void)setup {
//	[self setBackgroundColor:[UIColor orangeColor]];
	
	self.dpadDrawView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.buttonSize.width, self.buttonSize.height)];
	[self addSubview:self.dpadDrawView];
	
	// Draw D-Pad
	//rgb(216,56,71)
	self.dPadDiscCtrl = [self createBezierCircle:CGPointMake(self.buttonSize.width/2.0, self.buttonSize.height/2.0)
										  radius:self.buttonSize.width/2.0
										   color:[UIColor colorWithRed:216/255.0 green:56/255.0 blue:71/255.0 alpha:1]
									   lineWidth:1
											fill:YES];
	self.dPadDiscCtrl.opacity = 0.5;
	[self.dpadDrawView.layer addSublayer:self.dPadDiscCtrl];
	
	self.dPadCircleCtrl = [self createBezierCircle:CGPointMake(self.buttonSize.width/2.0, self.buttonSize.height/2.0)
											radius:self.buttonSize.width/2.0
											 color:[UIColor colorWithWhite:0.4 alpha:1]
										 lineWidth:1
											  fill:NO];
	[self.dpadDrawView.layer addSublayer:self.dPadCircleCtrl];
	
	self.dpadDrawView.frame = (CGRect){
		.origin.x = CGRectGetWidth(self.frame)-self.buttonSize.width-20,
		.origin.y = CGRectGetHeight(self.frame)-self.buttonSize.height-20,
		.size = self.buttonSize
	};
}

- (void)setIsPressed:(BOOL)isPressed {
	if (_isPressed != isPressed) {
		_isPressed = isPressed;
		if ([self.delegate respondsToSelector:@selector(gamePadButtonDidPressed:withId:)]) {
			[self.delegate gamePadButtonDidPressed:isPressed withId:self.buttonId];
		}
	}
}


#pragma mark -
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *aTouch = [touches anyObject];
	CGPoint point = [aTouch locationInView:self];
	point = CGPointMake(MIN(MAX(point.x-self.buttonSize.width/2.0, 10), CGRectGetWidth(self.frame)-self.buttonSize.width-10),
						MIN(MAX(point.y-self.buttonSize.height/2.0, 10), CGRectGetHeight(self.frame)-self.buttonSize.height-10));
	
	CGRect frame = self.dpadDrawView.frame;
	frame.origin = CGPointMake(point.x, point.y);
	self.dpadDrawView.frame = frame;
	
	self.isPressed = YES;
	self.dPadDiscCtrl.opacity = 0.8;
	self.dPadCircleCtrl.hidden = YES;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	self.isPressed = NO;
	self.dPadDiscCtrl.opacity = 0.5;
	self.dPadCircleCtrl.hidden = NO;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	self.isPressed = NO;
	self.dPadDiscCtrl.opacity = 0.5;
	self.dPadCircleCtrl.hidden = NO;
}

#pragma mark - Drawing utils
-(CAShapeLayer*) createBezierCircle:(CGPoint)center
							 radius:(float)radius
							  color:(UIColor*)color
						  lineWidth:(float)lineWidth
							   fill:(BOOL)fill
{
	CAShapeLayer *circle = [[CAShapeLayer alloc] init];
	circle.path = [UIBezierPath bezierPathWithArcCenter:center
												 radius:radius
											 startAngle:M_PI
											   endAngle:3*M_PI
											  clockwise:1].CGPath;
	if( !fill ) {
		circle.fillColor = [UIColor clearColor].CGColor;
		circle.strokeColor = color.CGColor;
	} else {
		circle.fillColor = color.CGColor;
		circle.strokeColor = [UIColor clearColor].CGColor;
	}
	circle.lineWidth = lineWidth;
	return circle;
}



@end
