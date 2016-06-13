//
//  FFCollection.h
//
//  Created by CHIEN-MING LEE on 6/13/16.
//  Copyright © 2016 Derek. All rights reserved.
//

#import "OBModel.h"

@protocol OBCollectionInterface <NSObject>
@required
@property (nonatomic, readonly) NSArray * _Nonnull collection;
- (void)addObject:(id _Nonnull)anObject;
- (void)insertObject:(id _Nonnull)anObject atIndex:(NSUInteger)idx;
- (void)exchangeAtIndex:(NSUInteger)idx1 withIndex:(NSUInteger)idx2;
- (void)removeObject:(id _Nonnull)anObject;
- (void)removeObjectAtIndex:(NSUInteger)idx;
- (void)removeAllObjects;
- (id _Nonnull)objectAtIndex:(NSUInteger)idx;
- (NSUInteger)indexOfObject:(id _Nonnull)anObject;
@end

@interface OBCollection : OBModel <OBCollectionInterface, NSFastEnumeration>
@property (nonatomic, readonly) NSArray * _Nonnull collection;
@end
