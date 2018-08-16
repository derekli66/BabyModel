//
//  ViewController.m
//  BabyModel
//
//  Created by CHIEN-MING LEE on 6/13/16.
//  Copyright © 2016 CHIEN-MING LEE. All rights reserved.
//

#import "ViewController.h"
#import "VGModel.h"
#import "OBCollection.h"

@interface ViewController ()
@property (nonatomic, strong) VGModel *testModel;
@end

@implementation ViewController

- (void)retainCycleTest
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"collection"]) {
        NSLog(@"Got collection changed. Changed item: %@", change);
    }
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
  
    // Testing custom collection object with KVO
    OBCollection *collection = [[OBCollection alloc] init];
    
    [collection addObserver:self forKeyPath:@"collection" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
    [collection addObject:@"String1"];
    [collection addObject:@"String2"];
    
    for (NSString *str in collection) {
        NSLog(@"String: %@", str);
    }
}

@end
