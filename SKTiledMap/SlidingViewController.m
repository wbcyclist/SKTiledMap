//
//  SlidingViewController.m
//  SKTiledMap
//
//  Created by JasioWoo on 15/6/15.
//  Copyright (c) 2015年 JasioWoo. All rights reserved.
//

#import "SlidingViewController.h"
#import "ContentViewController.h"
#import "UIViewController+ECSlidingViewController.h"
#import "TestEntity.h"


@interface SlidingViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *testDatas;
@property (nonatomic, weak) TestCaseEntity *currentCase;

@end

@implementation SlidingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // load test data
    self.testDatas = [NSMutableArray array];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"ExampleData" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSArray *pfDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
    for (NSDictionary *data in pfDic) {
        TestClassEntity *classEntity = [TestClassEntity new];
        classEntity.tile = data[@"Tile"];
        classEntity.testClassName = data[@"TestClass"];
        
        NSMutableArray *cases = [NSMutableArray array];
        for (NSDictionary *caseData in data[@"Cases"]) {
            TestCaseEntity *caseEntity = [TestCaseEntity new];
            caseEntity.classEntity = classEntity;
            caseEntity.tile = caseData[@"Name"];
            caseEntity.tmxFile = caseData[@"TMXFile"];
            NSString *imgFile = [[NSBundle mainBundle] pathForResource:caseData[@"Thumbnail"] ofType:nil];
            caseEntity.thumbnailImage = [[UIImage alloc] initWithContentsOfFile:imgFile];
            [cases addObject:caseEntity];
            
            // load first case
            if (!self.currentCase) {
                if ([self.slidingViewController.topViewController isKindOfClass:[ContentViewController class]]) {
                    ContentViewController *topVC = (ContentViewController *)self.slidingViewController.topViewController;
                    if ([topVC loadTestEntity:caseEntity]) {
                        self.currentCase = caseEntity;
                    }
                }
            }
            
        }
        [self.testDatas addObject:cases];
    }
}

- (TestCaseEntity *)caseEntityAtIndexPath:(NSIndexPath *)indexPath {
    return self.testDatas[indexPath.section][indexPath.row];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.testDatas.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.testDatas[section] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    TestCaseEntity *entity = [self.testDatas[section] lastObject];
    return entity.classEntity.tile;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"MainCell";
    
    TestCaseEntity *caseEntity = [self caseEntityAtIndexPath:indexPath];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:1];
    UILabel *label = (UILabel *)[cell viewWithTag:2];
    imageView.image = caseEntity.thumbnailImage;
    label.text = caseEntity.tile;
    
    return cell;
}



#pragma mark - UITableViewDelegate
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    
//}
//
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"section=%@, row=%@", @(indexPath.section), @(indexPath.row));
    
    TestCaseEntity *caseEntity = [self caseEntityAtIndexPath:indexPath];
    if (self.currentCase!=caseEntity) {
        if ([self.slidingViewController.topViewController isKindOfClass:[ContentViewController class]]) {
            ContentViewController *topVC = (ContentViewController *)self.slidingViewController.topViewController;
            if ([topVC loadTestEntity:caseEntity]) {
                self.currentCase = caseEntity;
            }
        }
    }
    [self.slidingViewController resetTopViewAnimated:YES];
}


@end
