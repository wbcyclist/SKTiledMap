//
//  StaggeredRenderer.h
//  SKTiledMap
//
//  Created by JasioWoo on 15/6/2.
//  Copyright (c) 2015年 JasioWoo. All rights reserved.
//

#import "OrthogonalRenderer.h"

@interface StaggeredRenderer : OrthogonalRenderer {
    int m_sideLengthX;
    int m_sideOffsetX;
    int m_sideLengthY;
    int m_sideOffsetY;
    int m_rowHeight;
    int m_columnWidth;
    BOOL m_staggerX;
    BOOL m_staggerEven;
}




/// 交错时景深在前的返回YES (StaggerOdd时，奇数返回YES。StaggerEven时，偶数返回YES)
- (BOOL)doStaggerX:(int)x;

/// 交错时靠右的返回YES (StaggerOdd时，奇数返回YES。StaggerEven时，偶数返回YES)
- (BOOL)doStaggerY:(int)y;




@end
