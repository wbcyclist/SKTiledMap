//
//  WBMatrix.h
//  SKTiledMap
//
//  Created by JasioWoo on 15/5/21.
//  Copyright (c) 2015年 JasioWoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WBMatrix : NSObject

@property (nonatomic, assign, readonly) uint32_t numRows;
@property (nonatomic, assign, readonly) uint32_t numCols;

- (instancetype)initWithRows:(uint32_t)numRows cols:(uint32_t)numCols;

- (id)objectAtRow:(uint32_t)row col:(uint32_t)col;
- (void)setObject:(id)anObject atRow:(uint32_t)row col:(uint32_t)col;

- (void)updateMatrixRowsNum:(uint32_t)numRows;
- (void)updateMatrixColsNum:(uint32_t)numCols;

- (void)clearAllObject;


@end
