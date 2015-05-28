//
//  WBMatrix.m
//  SKTiledMap
//
//  Created by JasioWoo on 15/5/21.
//  Copyright (c) 2015年 JasioWoo. All rights reserved.
//

#import "WBMatrix.h"

#define NumToString(num) [NSString stringWithFormat:@"%d", num]

@interface WBMatrix ()

@property (nonatomic, strong) NSMutableDictionary *matrixDic;
@property (nonatomic, assign) uint32_t numRows;
@property (nonatomic, assign) uint32_t numCols;

@end

@implementation WBMatrix

- (instancetype)init {
    if (self = [super init]) {
        self.matrixDic = [NSMutableDictionary dictionary];
        self.numCols = 0;
        self.numRows = 0;
    }
    return self;
}
- (instancetype)initWithRows:(uint32_t)numRows cols:(uint32_t)numCols {
    if (self = [self init]) {
        self.numRows = numRows;
        self.numCols = numCols;
        
        for (uint32_t i=0; i<_numRows; i++) {
            NSMutableArray *rowArr = [NSMutableArray arrayWithCapacity:_numCols];
            for (uint32_t j=0; j<_numCols; j++) {
                [rowArr addObject:[NSNull null]];
            }
            [self.matrixDic setObject:rowArr forKey:NumToString(i)];
        }
    }
    return self;
}

- (void)dealloc {
    NSLog(@"%s", __func__);
    [self.matrixDic.allValues makeObjectsPerformSelector:@selector(removeAllObjects)];
    [self.matrixDic removeAllObjects];
    self.matrixDic = nil;
}

- (NSMutableArray *)getArrAtRow:(uint32_t)row {
    return self.matrixDic[NumToString(row)];
}


- (id)objectAtRow:(uint32_t)row col:(uint32_t)col {
    if (col>=self.numCols || row>=self.numRows) {
        return nil;
    }
    NSArray *colArr = [self getArrAtRow:row];
    id obj = colArr[col];
    return obj==[NSNull null] ? nil : obj;
}

- (void)setObject:(id)anObject atRow:(uint32_t)row col:(uint32_t)col {
    if (col>=self.numCols || row>=self.numRows) {
        return;
    }
    if (anObject==nil) {
        [[self getArrAtRow:row] replaceObjectAtIndex:col withObject:[NSNull null]];
    } else {
        [[self getArrAtRow:row] replaceObjectAtIndex:col withObject:anObject];
    }
}

- (void)updateMatrixRowsNum:(uint32_t)numRows {
    if (numRows==0 || self.numRows==numRows) {
        return;
    }
    if (self.numRows > numRows) {
        for (uint32_t i=numRows; i<_numRows; i++) {
            NSMutableArray *rowArr = [self getArrAtRow:i];
            [rowArr removeAllObjects];
            [self.matrixDic removeObjectForKey:NumToString(i)];
        }
    } else {
        for (uint32_t i=self.numRows; i<numRows; i++) {
            NSMutableArray *rowArr = [NSMutableArray arrayWithCapacity:_numCols];
            for (uint32_t j=0; j<_numCols; j++) {
                [rowArr addObject:[NSNull null]];
            }
            [self.matrixDic setObject:rowArr forKey:NumToString(i)];
        }
    }
    self.numRows = numRows;
}

- (void)updateMatrixColsNum:(uint32_t)numCols {
    if (numCols==0 || self.numCols==numCols) {
        return;
    }
    for (uint32_t i=0; i<_numRows; i++) {
        NSMutableArray *rowArr = [self getArrAtRow:i];
        NSInteger arrCount = rowArr.count;
        if (self.numCols > numCols) {
            arrCount--;
            for (; arrCount >= numCols; arrCount--) {
                [rowArr removeObjectAtIndex:arrCount];
            }
        } else {
            for (; arrCount < numCols; arrCount++) {
                [rowArr addObject:[NSNull null]];
            }
        }
    }
    self.numCols = numCols;
}

- (void)clearAllObject {
    NSEnumerator *enumerator = [_matrixDic keyEnumerator];
    NSMutableArray *rowArr;
    for(NSString *aKey in enumerator) {
        rowArr = [_matrixDic objectForKey:aKey];
        for (uint32_t j=0; j<rowArr.count; j++) {
            id anObject = rowArr[j];
            if (anObject != [NSNull null]) {
                rowArr[j] = [NSNull null];
            }
        }
    }
}

- (NSString *)description {
    return [_matrixDic description];
}

@end
