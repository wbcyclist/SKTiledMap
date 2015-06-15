//
//  SplitWindow.m
//  PathFindingForObjC-Example
//
//  Created by JasioWoo on 15/3/20.
//  Copyright (c) 2015年 JasioWoo. All rights reserved.
//

#import "SplitWindow.h"
#import "TestEntity.h"
#import "ZoomTestScene.h"
#import "ZPositionTestScene.h"


@interface SplitWindow() <NSTableViewDelegate, NSTableViewDataSource>
@property (nonatomic, weak) IBOutlet NSTableView *tableView;
@end

@implementation SplitWindow {
    NSInteger m_currentRow;
}

- (void)setTableView:(NSTableView *)tableView {
    if (_tableView != tableView) {
        _tableView = tableView;
        [tableView setDoubleAction:@selector(tableDoubleClick:)];
    }
}

- (void)setTestDatas:(NSMutableArray *)testDatas {
    if (_testDatas != testDatas) {
        _testDatas = testDatas;
        [self.tableView reloadData];
    }
}

- (void)setGameView:(SKView *)gameView {
    if (_gameView != gameView) {
        _gameView = gameView;
        gameView.ignoresSiblingOrder = YES;
        gameView.showsDrawCount = YES;
        gameView.showsFPS = YES;
        gameView.showsNodeCount = YES;
//        gameView.showsPhysics = YES;
        
    }
}


- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

#define LEFT_VIEW_MIN_WIDTH 250.0
#define LEFT_VIEW_MAX_WIDTH 350.0

- (BOOL)splitView:(NSSplitView *)splitView canCollapseSubview:(NSView *)subview {
	return self.leftView == subview;
}

- (BOOL)splitView:(NSSplitView *)splitView shouldCollapseSubview:(NSView *)subview forDoubleClickOnDividerAtIndex:(NSInteger)dividerIndex {
	return self.leftView == subview;
}

- (CGFloat)splitView:(NSSplitView *)splitView constrainMinCoordinate:(CGFloat)proposedMinimumPosition ofSubviewAt:(NSInteger)dividerIndex {
	return LEFT_VIEW_MIN_WIDTH;
}

- (CGFloat)splitView:(NSSplitView *)splitView constrainMaxCoordinate:(CGFloat)proposedMaximumPosition ofSubviewAt:(NSInteger)dividerIndex {
	return LEFT_VIEW_MAX_WIDTH;
}

//- (void)splitView:(NSSplitView *)splitView resizeSubviewsWithOldSize:(NSSize)oldSize {
//	if (NSEqualSizes(splitView.frame.size, oldSize)) {
//		return;
//	}
//	NSSize newSize = splitView.frame.size;
//	NSPoint rightOrigin = NSMakePoint(splitView.dividerThickness, 0);
//	
//	if (![splitView isSubviewCollapsed:self.leftView]) {
//		rightOrigin = NSMakePoint(self.leftView.frame.size.width + splitView.dividerThickness, 0);
//		
//		if (newSize.height != oldSize.height) {
//			[self.leftView setFrameSize:NSMakeSize(self.leftView.frame.size.width, newSize.height)];
//		}
//	}
//	
//	NSRect rightFrame = {
//		rightOrigin,
//		newSize.width - rightOrigin.x,
//		newSize.height
//	};
//	[self.rightView setFrame:rightFrame];
//}


- (BOOL)loadTestEntity:(TestEntity *)entity {
    if ([entity isKindOfClass:[TestCaseEntity class]]) {
        TestCaseEntity *caseEntity = (TestCaseEntity*)entity;
        SKScene *gameScene = nil;
        if ([caseEntity.classEntity.testClassName isEqualToString:@"ZoomTestScene"]) {
            gameScene = [[ZoomTestScene alloc] initWithSize:self.gameView.frame.size mapFile:caseEntity.tmxFile];
            
        } else if ([caseEntity.classEntity.testClassName isEqualToString:@"ZPositionTestScene"]) {
            gameScene = [[ZPositionTestScene alloc] initWithSize:self.gameView.frame.size mapFile:caseEntity.tmxFile];
            
        }
        
        if (!gameScene) {
            return NO;
        }
        
        gameScene.scaleMode = SKSceneScaleModeResizeFill;
//        [self.gameView presentScene:gameScene];
        
        [self.gameView presentScene:gameScene transition:[SKTransition flipHorizontalWithDuration:1]];
        [self makeFirstResponder:self.gameView];
        return YES;
        
    } else {
        return NO;
    }
}



#pragma mark - NSTableView Action
- (IBAction)tableDoubleClick:(id)sender {
    NSInteger row = [self.tableView selectedRow];
//    NSLog(@"row=%@", @(row));
    if (row<0 || row>=self.testDatas.count) {
        return;
    }
    
    if (m_currentRow != row && [self loadTestEntity:self.testDatas[row]]) {
        m_currentRow = row;
    }
}


#pragma mark - NSTableViewDataSource
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return self.testDatas.count;
}


#pragma mark - NSTableViewDelegate
- (BOOL)tableView:(NSTableView *)tableView isGroupRow:(NSInteger)row {
    return [self.testDatas[row] isKindOfClass:[TestClassEntity class]];
}


- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    TestEntity *entity = self.testDatas[row];
    if ([entity isKindOfClass:[TestClassEntity class]]) {
        NSTextField *textField = [tableView makeViewWithIdentifier:@"GroupCell" owner:self];
        textField.stringValue = entity.tile;
        return textField;
    } else {
        TestCaseEntity *caseEntity = (TestCaseEntity *)entity;
        NSTableCellView *cellView = [tableView makeViewWithIdentifier:@"ContentCell" owner:self];
        cellView.textField.stringValue = caseEntity.tile;
        cellView.imageView.image = caseEntity.thumbnailImage;
        return cellView;
    }
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    if ([self.testDatas[row] isKindOfClass:[TestClassEntity class]]) {
        return tableView.rowHeight;
    } else {
        return 72;
    }
}





















@end
