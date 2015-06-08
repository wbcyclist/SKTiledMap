//
//  WBGamepadDPad.m
//  BalloonFight
//
//  Created by JasioWoo on 14/11/26.
//  Copyright (c) 2014年 JasioWoo. All rights reserved.
//

#import "WBGamepadDPad.h"

#define SIGN(x) (x<0?-1:1)

@interface WBGamepadDPad ()

@property (nonatomic, assign)CGSize dpadSize;
@property (nonatomic, assign)CGSize dpadDiscSize;

@property(nonatomic, strong) UIView *dpadDrawView;
@property(nonatomic, strong) CAShapeLayer *dPadCircleCtrl;
@property(nonatomic, strong) CAShapeLayer *dPadDiscCtrl;


@end

@implementation WBGamepadDPad {
	float distLimit;
	float m_distMinLimit; // 移动作用最小比例权值(判断Pan移动距离超过多少才进行移动响应处理)
	
}


- (instancetype)initWithFrame:(CGRect)frame withDPadSize:(CGSize)dpadSize {
	self = [super initWithFrame:frame];
	if (self) {
//        [self setBackgroundColor:[UIColor blueColor]];
		
		self.dpadSize = dpadSize;
		self.dpadDiscSize = CGSizeMake(0.55*dpadSize.width, 0.55*dpadSize.height);
		distLimit = (self.dpadSize.width-self.dpadDiscSize.width)/2.0;
		m_distMinLimit = 0.2;
		
		_angle = 0;
		_isActive = NO;
		_direction = WBGamepadNoDirection;
		
		[self setup];
	}
	return self;
	
}

- (void)setup {
	self.dpadDrawView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.dpadSize.width, self.dpadSize.height)];
//	self.dpadDrawView.backgroundColor = [UIColor orangeColor];
	[self addSubview:self.dpadDrawView];
	
	// Draw D-Pad
	float circleLineWidth = 0.75;
	self.dPadCircleCtrl = [self createBezierCircle:CGPointMake(self.dpadSize.width/2.0, self.dpadSize.height/2.0)
											radius:self.dpadSize.width/2.0
											 color:[UIColor redColor]
										 lineWidth:circleLineWidth
											  fill:NO];
	self.dPadCircleCtrl.opacity = 0.8;
	[self.dpadDrawView.layer addSublayer:self.dPadCircleCtrl];
	
	self.dpadDrawView.frame = (CGRect){
		.origin.x = 10,
		.origin.y = CGRectGetHeight(self.frame)-self.dpadSize.height-10,
		.size = self.dpadSize
	};
	
	self.dPadDiscCtrl = [self createBezierCircle:CGPointMake(self.dpadSize.width/2.0, self.dpadSize.height/2.0)
									 radius:self.dpadDiscSize.width/2.0
									  color:[UIColor grayColor]
								  lineWidth:circleLineWidth
									   fill:YES];
	self.dPadDiscCtrl.opacity = 0.8;
	[self.dpadDrawView.layer addSublayer:self.dPadDiscCtrl];
	
	// 拖动手势
	UIPanGestureRecognizer * viewPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dPadPan:)];
	viewPan.maximumNumberOfTouches = 1;
	[self addGestureRecognizer:viewPan];
}

- (void)setIsActive:(BOOL)isActive {
	if (_isActive != isActive) {
		_isActive = isActive;
		if ([self.delegate respondsToSelector:@selector(gamePadDPadDidActive:)]) {
			[self.delegate gamePadDPadDidActive:isActive];
		}
	}
}
- (void)setAngle:(CGFloat)angle {
	if (_angle != angle) {
		_angle = angle;
		if ([self.delegate respondsToSelector:@selector(gamePadDPadDidUpdateAngle:)]) {
			[self.delegate gamePadDPadDidUpdateAngle:angle];
		}
	}
}
- (void)setDirection:(WBGamepadDirection)direction {
	if (_direction != direction) {
		_direction = direction;
		if ([self.delegate respondsToSelector:@selector(gamePadDPadDidUpdateDirection:)]) {
			[self.delegate gamePadDPadDidUpdateDirection:direction];
		}
	}
}


#pragma mark -
- (void)dPadPan:(UIPanGestureRecognizer*)sender {
//	debugMethod();
	if( sender.state==UIGestureRecognizerStateBegan || sender.state==UIGestureRecognizerStateChanged) {
		CGPoint location = [sender locationInView:self];
		CGPoint origin = CGPointMake(CGRectGetMidX(self.dpadDrawView.frame), CGRectGetMidY(self.dpadDrawView.frame));
		float tx = location.x - origin.x;
		float ty = location.y - origin.y;
		CGPoint translate = CGPointMake(tx, ty);
		
		float dist = sqrt(tx*tx+ty*ty);
		if (!self.isActive) {
			if(dist<m_distMinLimit*distLimit) {
				return;
			}
			self.isActive = YES;
		}
		self.dPadDiscCtrl.opacity = 0.8;
		
		[CATransaction begin];
		[CATransaction setAnimationDuration:0.0];
		circleClampTranslate(origin, &translate, distLimit);
		self.dPadDiscCtrl.transform = CATransform3DMakeTranslation(translate.x, translate.y, 0);
		[CATransaction commit];
		
		if (dist<m_distMinLimit*distLimit) {
			self.angle = 0;
			self.direction = WBGamepadNoDirection;
		} else {
			self.angle = getDPadAngle(origin, translate);
//			NSLog(@"angle=%f", self.angle);
			self.direction = [self getDPadDirectionFromAngle:self.angle];
		}
		
		
	} else if(sender.state == UIGestureRecognizerStateEnded) {
		self.dPadDiscCtrl.opacity = 0.4;
		
		// Reset position with default interp animation
		self.dPadDiscCtrl.transform = CATransform3DMakeTranslation(0, 0, 0);
		
		self.isActive = NO;
		self.angle = 0;
		self.direction = WBGamepadNoDirection;
	}
}

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
////	debugMethod();
//	UITouch *aTouch = [touches anyObject];
//	CGPoint point = [aTouch locationInView:self];
//	point = CGPointMake(MIN(MAX(point.x-self.dpadSize.width/2.0, 10), CGRectGetWidth(self.frame)-self.dpadSize.width-10),
//						MIN(MAX(point.y-self.dpadSize.height/2.0, 10), CGRectGetHeight(self.frame)-self.dpadSize.height-10));
//	
//	CGRect frame = self.dpadDrawView.frame;
//	frame.origin = CGPointMake(point.x, point.y);
//	self.dpadDrawView.frame = frame;
//}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	self.isActive = NO;
	self.angle = 0;
	self.direction = WBGamepadNoDirection;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	self.isActive = NO;
	self.angle = 0;
	self.direction = WBGamepadNoDirection;
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

- (WBGamepadDirection) getDPadDirectionFromAngle:(float)angle
{
	if( angle<=M_PI/8 || angle>15*M_PI/8 )
	{
		return WBGamepadWest;
	}
	else if( angle>M_PI/8 && angle<=3*M_PI/8 )
	{
		return WBGamepadNorthWest;
	}
	else if( angle>3*M_PI/8 && angle<=5*M_PI/8 )
	{
		return WBGamepadNorth;
	}
	else if( angle>5*M_PI/8 && angle<=7*M_PI/8 )
	{
		return WBGamepadNorthEast;
	}
	else if( angle>7*M_PI/8 && angle<=9*M_PI/8 )
	{
		return WBGamepadEast;
	}
	else if( angle>9*M_PI/8 && angle<=11*M_PI/8 )
	{
		return WBGamepadSouthEast;
	}
	else if( angle>11*M_PI/8 && angle<=13*M_PI/8 )
	{
		return WBGamepadSouth;
	}
	else if( angle>13*M_PI/8 && angle<=15*M_PI/8 )
	{
		return WBGamepadSouthWest;
	}
	return WBGamepadNoDirection;
}

bool circleClampTranslate(const CGPoint origin, CGPoint *translate, float limit) {
	CGPoint dstPoint = CGPointMake(origin.x + translate->x, origin.y + translate->y);
	float dist = sqrt( pow(dstPoint.x-origin.x, 2) + pow(dstPoint.y-origin.y, 2) );
	if( dist<=limit ) {
		return false;
	}
	
	float alpha = acos(ABS(translate->x) / dist);
	
	float tx = cos(alpha) * limit;
	float ty = sin(alpha) * limit;
	
	translate->x = SIGN(translate->x) * tx;
	translate->y = SIGN(translate->y) * ty;
	
	return true;
}

float getDPadAngle(const CGPoint origin, const CGPoint translate) {
	CGPoint dstPoint = CGPointMake(origin.x + translate.x, origin.y + translate.y);
	float dist = sqrt(pow(dstPoint.x-origin.x, 2) + pow(dstPoint.y-origin.y, 2));
	float alpha = acos(ABS(translate.x) / dist);
	
	if (translate.x<0 && translate.y<0) {
		alpha = M_PI - alpha;
		
	} else if (translate.x<0 && translate.y>0) {
		alpha = M_PI + alpha;
		
	} else if (translate.x>0 && translate.y>0) {
		alpha = 2*M_PI - alpha;
	}
	return alpha;
}

@end
