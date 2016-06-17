//
//  OBCollection.m
//
//  Created by CHIEN-MING LEE on 6/13/16.
//  Copyright © 2016 Derek. All rights reserved.
//

#import "OBCollection.h"
#import "OBModel.h"

@interface OBCollection()
@property (readonly) NSMutableArray *mutableCollection;
@property (nonatomic, strong) NSMutableArray *container;
@end

@implementation OBCollection

-(id)init
{
    if(self=[super init])
    {
        _container = [NSMutableArray array];
    }
    return self;
}

#pragma mark - Baisc KVO Setup
- (NSMutableArray *)mutableCollection
{
    return [self mutableArrayValueForKey:@"collection"];
}

- (NSArray *)collection
{
    return [NSArray arrayWithArray:self.container];
}

- (void)insertObject:(id)object inCollectionAtIndex:(NSUInteger)index
{
    [self.container insertObject:object atIndex:index];
}

- (void)removeObjectFromCollectionAtIndex:(NSUInteger)index
{
    [self.container removeObjectAtIndex:index];
}

- (void)replaceObjectInCollectionAtIndex:(NSUInteger)index withObject:(id)object
{
    [self.container replaceObjectAtIndex:index withObject:object];
}

#pragma mark - OBCollectionInterface
- (void)addObject:(id _Nonnull)anObject
{
    NSAssert(anObject != nil, @"");
    [self.mutableCollection addObject:anObject];
}

- (void)insertObject:(id _Nonnull)anObject atIndex:(NSUInteger)idx
{
    NSAssert(anObject != nil, @"");
    [self.mutableCollection insertObject:anObject atIndex:idx];
}

- (void)exchangeAtIndex:(NSUInteger)idx1 withIndex:(NSUInteger)idx2
{
    [self.mutableCollection exchangeObjectAtIndex:idx1 withObjectAtIndex:idx2];
}

- (void)removeObject:(id _Nonnull)anObject
{
    NSAssert(anObject != nil, @"");
    [self.mutableCollection removeObject:anObject];
}

- (void)removeObjectAtIndex:(NSUInteger)idx
{
    [self.mutableCollection removeObjectAtIndex:idx];
}

- (void)removeAllObjects
{
    [self.mutableCollection removeAllObjects];
}

- (id _Nonnull)objectAtIndex:(NSUInteger)idx
{
    return self.container[idx];
}

- (NSUInteger)indexOfObject:(id _Nonnull)anObject
{
    NSAssert(anObject != nil, @"");
    return [self.container indexOfObject:anObject];
}

#pragma mark - Implement NSFastEnumeration
-(NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(__unsafe_unretained id [])stackbuf count:(NSUInteger)len
{
    NSUInteger count = 0;

    if(state->state == 0)
    {
        state->mutationsPtr = &state->extra[0];
    }
    
    if(state->state < self.length)
    {
        state->itemsPtr = stackbuf;

        while((state->state < self.length) && (count < len))
        {
            stackbuf[count] = [self at:state->state];
            state->state++;
            count++;
        }
    }
    else
    {
        count = 0;
    }
    return count;
}

-(NSUInteger)length
{
    return [self.container count];
}

-(id)at:(NSUInteger)index
{
    return self.container[index];
}
@end
