//
//  OBModel.h
//
//  Created by CHIEN-MING LEE on 6/13/16.
//  Copyright © 2016 Derek. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * _Nonnull const kOBNewValueKey;
extern NSString * _Nonnull const kOBOldValueKey;
extern NSString * _Nonnull const kOBIndexesKey;
extern NSString * _Nonnull const kOBKindKey;

typedef void (^OBEvent)(NSString * _Nonnull propertyName, NSDictionary * _Nonnull changes);

@protocol OBModelInterface <NSObject>
@required
- (void)addObserver:(NSObject * _Nonnull)observer forProperty:(NSString * _Nonnull)propertyName withEvent:(OBEvent _Nonnull)aBlock;
- (void)removeObserver:(NSObject * _Nonnull)observer forProperty:(NSString * _Nonnull)propertyName;
- (void)removeObserver:(NSObject * _Nonnull)observer;
- (void)removeAllObservers;
- (void)ceaseFireOnProperty:(NSString * _Nonnull)propertyName;
- (void)resumeFireOnProperty:(NSString * _Nonnull)propertyName;
- (BOOL)isCeasedFireOnProperty:(NSString * _Nonnull)propertyName;

@optional
- (NSString * _Nullable)description;
@end

@interface OBModel : NSObject <OBModelInterface>
@end
