//
//  ViewController.m
//  BabyModel
//
//  Created by CHIEN-MING LEE on 6/13/16.
//  Copyright © 2016 CHIEN-MING LEE. All rights reserved.
//

#import "ViewController.h"
#import "VGModel.h"

@interface ViewController ()
@property (nonatomic, strong) VGModel *testModel;
@end

@implementation ViewController

- (void)retainCycleTest
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Test BabyModel property monitor function
    VGModel *aModel = [[VGModel alloc] init];
    aModel.title = @"Bob";
    aModel.backgroundImage = [UIImage imageNamed:@"green_grace.png"];
    
    __weak typeof(self) weakSelf = self;
    [self.testModel addObserver:self forProperty:@"title" withEvent:^(NSString * _Nonnull propertyName, NSDictionary * _Nonnull changes) {
        NSLog(@"Change property: %@, changes: %@", propertyName, changes);
        [weakSelf retainCycleTest];
        weakSelf.testModel.backgroundImage = [UIImage imageNamed:@"171-sun.png"];
    }];
    
    [self.testModel addObserver:self forProperty:@"backgroundImage" withEvent:^(NSString * _Nonnull propertyName, NSDictionary * _Nonnull changes) {
        NSLog(@"I got the images: %@", changes);
        [weakSelf retainCycleTest];
    }];
    
    self.testModel = aModel;
    
    [self.testModel ceaseFireOnProperty:@"title"];
    self.testModel.title = @"Jack Hugo";
    [self.testModel resumeFireOnProperty:@"title"];
    
    self.testModel.title = @"TingTing";
}

@end
