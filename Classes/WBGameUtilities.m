//
//  WBGameUtilities.m
//  BalloonFight
//
//  Created by JasioWoo on 14/9/23.
//  Copyright (c) 2014年 JasioWoo. All rights reserved.
//
#import "WBGameUtilities.h"


#pragma mark - Point Calculations
/// 两点间的距离
CGFloat WB_DistanceBetweenPoints(CGPoint first, CGPoint second) {
	return hypotf(second.x - first.x, second.y - first.y);
}
/// 两点直线相对的弧度
CGFloat WB_RadiansBetweenPoints(CGPoint first, CGPoint second) {
	CGFloat deltaX = second.x - first.x;
	CGFloat deltaY = second.y - first.y;
	return atan2f(deltaY, deltaX);
}
/// 两点相加
CGPoint WB_PointByAddingCGPoints(CGPoint first, CGPoint second) {
	return CGPointMake(first.x + second.x, first.y + second.y);
}

/// 两点直线相对的角度 (0~360)
CGFloat WB_DegreesBetweenPoints(CGPoint first, CGPoint second) {
    CGFloat d = WB_RadiansBetweenPoints(first, second);
    d = WB_POLAR_ADJUST(d);
    return WB_AngleToDegrees(d);
}

CGFloat WB_AngleToDegrees(CGFloat r) {
    r = r * 57.29577951f;// 180/PI
    r = (r > 0.0 ? r : (360.0 + r));
    return r;
}

/// YES: x和y有相同的符号 NO: x，y有相反的符号
BOOL WB_ISSameSign(NSInteger x, NSInteger y) {
	// 有0的情况例外
	return (x ^ y) >= 0;
}


#pragma mark - Loading from a Texture Atlas
NSArray *WB_LoadFramesFromAtlas(NSString *atlasName, NSString *baseFileName, int numberOfFrames) {
	NSMutableArray *frames = [NSMutableArray arrayWithCapacity:numberOfFrames];
	SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:atlasName];
	for (int i = 1; i <= numberOfFrames; i++) {
		NSString *fileName = [NSString stringWithFormat:@"%@%04d.png", baseFileName, i];
		SKTexture *texture = [atlas textureNamed:fileName];
		[frames addObject:texture];
	}
	return frames;
}



#pragma mark - SKEmitterNode Category
@implementation SKEmitterNode (WBBalloonFightAdditions)
+ (instancetype)wbbf_emitterNodeWithEmitterNamed:(NSString *)emitterFileName {
	return [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:emitterFileName ofType:@"sks"]];
}
@end










