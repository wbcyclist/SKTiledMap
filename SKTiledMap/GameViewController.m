//
//  GameViewController.m
//  SKTiledMap
//
//  Created by JasioWoo on 15/4/2.
//  Copyright (c) 2015年 JasioWoo. All rights reserved.
//

#import "GameViewController.h"
#import "GameScene.h"
#import "ZoomTestScene.h"

#import "WBGamePad.h"

@interface GameViewController ()

@property (nonatomic, strong)WBGamePad *gamePad;

@end

@implementation GameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    skView.showsDrawCount = YES;
    /* Sprite Kit applies additional optimizations to improve rendering performance */
    skView.ignoresSiblingOrder = YES;
//    skView.showsPhysics = YES;
    
    // Create and configure the scene.
    CGSize viewSize = self.view.bounds.size;
    viewSize.width *= 2;
    viewSize.height *= 2;
    
//    GameScene *scene = [[GameScene alloc] initWithSize:viewSize];
//    ZoomTestScene *scene = [[ZoomTestScene alloc] initWithSize:viewSize mapFile:@"TiledMap/Orthogonal/02.tmx"];
    ZoomTestScene *scene = [[ZoomTestScene alloc] initWithSize:viewSize mapFile:@"TiledMap/Isometric/02.tmx"];
    
    scene.scaleMode = SKSceneScaleModeFill;
    
    
    // game pad
    int tmp = self.view.bounds.size.height;
    CGSize dSize = CGSizeMake(150, 150);
    self.gamePad = [[WBGamePad alloc] initWithFrame:CGRectMake(0, tmp-20-dSize.width, 20+dSize.width, 20+dSize.height)
                                       withDPadSize:dSize
                                     withButtonSize:CGSizeMake(50, 50)];
    self.gamePad.buttonAView.hidden = YES;
//    self.gamePad.hidden = YES;
    [skView addSubview:self.gamePad];
    
    if ([scene respondsToSelector:@selector(setGamePad:)]) {
        self.gamePad.hidden = NO;
        [scene performSelectorOnMainThread:@selector(setGamePad:) withObject:self.gamePad waitUntilDone:YES];
    } else {
        self.gamePad.hidden = YES;
    }
    
    
    
    
    // Present the scene.
    [skView presentScene:scene];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
