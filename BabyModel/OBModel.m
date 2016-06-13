//
//  OBModel.m
//  ObjectiveCPractice
//
//  Created by CHIEN-MING LEE on 6/13/16.
//  Copyright © 2016 Derek. All rights reserved.
//

#import "OBModel.h"
#import <objc/runtime.h>

NSString * const kOBNewValueKey = @"newValue";
NSString * const kOBOldValueKey = @"oldValue";
NSString * const kOBIndexesKey = @"indexes";
NSString * const kOBKindKey = @"kind";

static NSString * const kOBCallbackKey = @"callback";
static NSString * const kOBObserverKey = @"observer";

@interface OBModel()
@property (nonatomic, strong) NSArray *properties;
@property (nonatomic, strong) NSMutableDictionary *eventMap;
@property (nonatomic, strong) NSMutableDictionary *bypassSettings;
@end

@implementation OBModel
#pragma mark - Initialization
- (void)loadPropertyNames
{
    unsigned int propertyCount = 0;
    objc_property_t * properties = class_copyPropertyList([self class], &propertyCount);
    
    NSMutableArray * propertyNames = [NSMutableArray array];
    for (unsigned int i = 0; i < propertyCount; ++i) {
        objc_property_t property = properties[i];
        const char * name = property_getName(property);
        [propertyNames addObject:[NSString stringWithUTF8String:name]];
    }
    free(properties);
    self.properties = [NSArray arrayWithArray:propertyNames];
}

- (void)registerPropertiesChangeMonitor
{
    NSArray *properties = self.properties;
    for (NSString *propertyName in properties) {
        [self addObserver:self forKeyPath:propertyName options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    }
}

- (void)unregisterPropertiesChangeMonitor
{
    NSArray *properties = self.properties;
    for (NSString *propertyName in properties) {
        [self removeObserver:self forKeyPath:propertyName context:nil];
    }
}

- (void)resetByPassSettings
{
    NSArray *properties = self.properties;
    for (NSString *propertyName in properties) {
        self.bypassSettings[propertyName] = @(NO);
    }
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _bypassSettings = [NSMutableDictionary dictionary];
        _eventMap = [NSMutableDictionary dictionary];
        _properties = [NSArray array];
        [self loadPropertyNames];
        [self registerPropertiesChangeMonitor];
        [self resetByPassSettings];
    }
    return self;
}

- (void)dealloc
{
    [self unregisterPropertiesChangeMonitor];
    [self removeAllObservers];
}

#pragma mark - Helpers
- (NSDictionary *)wrapKVOChange:(NSDictionary<NSString *,id> *)change
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionaryWithCapacity:4];
    id newValue = change[NSKeyValueChangeNewKey];
    newValue = (newValue) ? newValue : [NSNull null];
    id oldValue = change[NSKeyValueChangeOldKey];
    oldValue = (oldValue) ? oldValue : [NSNull null];
    
    [mutableDict setObject:newValue forKey:kOBNewValueKey];
    [mutableDict setObject:oldValue forKey:kOBOldValueKey];
    
    if (nil != change[NSKeyValueChangeIndexesKey]) {
        [mutableDict setObject:change[NSKeyValueChangeIndexesKey] forKey:kOBIndexesKey];
        [mutableDict setObject:change[NSKeyValueChangeKindKey] forKey:kOBKindKey];
    }
    
    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if (self == object) {
        if ([self isCeasedFireOnProperty:keyPath])
            return;
        
        NSMutableArray *handlers=self.eventMap[keyPath];
        if(!handlers)
            return;
        
        NSDictionary *wrappedInfo = [self wrapKVOChange:change];
        
        for(NSDictionary *eventHandler in handlers)
        {
            OBEvent callback = eventHandler[kOBCallbackKey];
            callback(keyPath, wrappedInfo);
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - OBModelInterface
- (void)addObserver:(NSObject *)observer forProperty:(NSString *)propertyName withEvent:(OBEvent)aBlock
{
    NSAssert(observer != nil, @"No observer given before monitoring property change");
    NSAssert(propertyName != nil, @"No property name given before monitoring property change");
    NSAssert(aBlock != nil, @"No event block given before monitoring property: %@", propertyName);

    if (![self.properties containsObject:propertyName])
        return;
    
    NSMutableArray *handlers = self.eventMap[propertyName];
    if (nil == handlers) {
        handlers = [NSMutableArray array];
        self.eventMap[propertyName] = handlers;
    }
    [handlers addObject:@{ kOBObserverKey: observer, kOBCallbackKey: aBlock }];
}

- (void)removeObserver:(NSObject *)observer forProperty:(NSString *)propertyName
{
    NSAssert(observer != nil, @"");
    NSAssert(propertyName != nil, @"");
    
    NSMutableArray *mutableArray = self.eventMap[propertyName];
    NSArray *eventHandlers = [NSArray arrayWithArray:mutableArray];
    
    for (NSDictionary *dict in eventHandlers) {
        if ([dict[kOBObserverKey] isEqual:observer]) {
            [mutableArray removeObject:dict];
        }
    }
}

- (void)removeObserver:(NSObject *)observer
{
    NSAssert(observer != nil, @"");
    NSArray *properties = self.properties;
    for (NSString *propertyName in properties) {
        [self removeObserver:observer forProperty:propertyName];
    }
}

- (void)removeAllObservers
{
    [self.eventMap removeAllObjects];
}

- (void)ceaseFireOnProperty:(NSString *)propertyName
{
    NSAssert(propertyName != nil, @"");
    self.bypassSettings[propertyName] = @(YES);
}

- (void)resumeFireOnProperty:(NSString *)propertyName
{
    NSAssert(propertyName != nil, @"");
    self.bypassSettings[propertyName] = @(NO);
}

- (BOOL)isCeasedFireOnProperty:(NSString *)propertyName
{
    NSAssert(propertyName != nil, @"");
    return [self.bypassSettings[propertyName] boolValue];
}
@end
