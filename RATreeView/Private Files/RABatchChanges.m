

#import "RABatchChanges.h"
typedef NS_ENUM(NSInteger, RABatchChangeType) {
  RABatchChangeTypeItemRowInsertion = 0,
  RABatchChangeTypeItemRowExpansion,
  RABatchChangeTypeItemRowDeletion,
  RABatchChangeTypeItemRowCollapse,
  RABatchChangeTypeItemMove
};

@interface RABatchChangeEntity : NSObject
@property (nonatomic) RABatchChangeType type;
@property (nonatomic) NSInteger ranking;
@property (nonatomic, copy) void(^updatesBlock)();
+ (instancetype)batchChangeEntityWithBlock:(void(^)())updates type:(RABatchChangeType)type ranking:(NSInteger)ranking;
@end

@implementation RABatchChangeEntity
+ (instancetype)batchChangeEntityWithBlock:(void (^)())updates type:(RABatchChangeType)type ranking:(NSInteger)ranking {
  NSParameterAssert(updates);
  RABatchChangeEntity *entity = [RABatchChangeEntity new];
  entity.type = type;
  entity.ranking = ranking;
  entity.updatesBlock = updates;
  
  return entity;
}
- (NSComparisonResult)compare:(RABatchChangeEntity*)otherEntity {
  if ([self destructiveOperation] && ![otherEntity destructiveOperation]) {
    return NSOrderedDescending;
  } else if ([self destructiveOperation]) {
    return [@(self.ranking) compare:@(otherEntity.ranking)];
  }
  
  if (self.type == RABatchChangeTypeItemMove && otherEntity.type != RABatchChangeTypeItemMove) {
    return [otherEntity destructiveOperation] ? NSOrderedAscending : NSOrderedDescending;
  }
  
  if ([self constructiveOperation]) {
    if (![otherEntity constructiveOperation]) {
      return NSOrderedAscending;
    }
    return [@(self.ranking) compare:@(otherEntity.ranking)];
  }
  
  return NSOrderedSame;
}
- (BOOL)constructiveOperation {
  return self.type == RABatchChangeTypeItemRowExpansion
  || self.type == RABatchChangeTypeItemRowInsertion;
}
- (BOOL)destructiveOperation {
  return self.type == RABatchChangeTypeItemRowCollapse
  || self.type == RABatchChangeTypeItemRowDeletion;
}
@end

@interface RABatchChanges ()
@property (nonatomic, strong) NSMutableArray *operationsStorage;
@property (nonatomic) NSInteger batchChangesCounter;
@end

@implementation RABatchChanges
- (id)init {
  self = [super init];
  if (self) {
    _batchChangesCounter = 0;
  }
  
  return self;
}
- (void)beginUpdates {
  if (self.batchChangesCounter++ == 0) {
    self.operationsStorage = [NSMutableArray array];
  }
}
- (void)endUpdates {
  self.batchChangesCounter--;
  if (self.batchChangesCounter == 0) {
    [self.operationsStorage sortUsingSelector:@selector(compare:)];
    
    for (RABatchChangeEntity *entity in self.operationsStorage) {
      entity.updatesBlock();
    }
    self.operationsStorage = nil;
  }
}
- (void)insertItemWithBlock:(void (^)())update atIndex:(NSInteger)index {
  RABatchChangeEntity *entity = [RABatchChangeEntity batchChangeEntityWithBlock:update
                                                                           type:RABatchChangeTypeItemRowInsertion
                                                                        ranking:index];
  [self addBatchChangeEntity:entity];
}
- (void)expandItemWithBlock:(void (^)())update atIndex:(NSInteger)index {
  RABatchChangeEntity *entity= [RABatchChangeEntity batchChangeEntityWithBlock:update
                                                                          type:RABatchChangeTypeItemRowExpansion
                                                                       ranking:index];
  [self addBatchChangeEntity:entity];
}
- (void)deleteItemWithBlock:(void (^)())update lastIndex:(NSInteger)lastIndex {
  RABatchChangeEntity *entity = [RABatchChangeEntity batchChangeEntityWithBlock:update
                                                                           type:RABatchChangeTypeItemRowDeletion
                                                                        ranking:lastIndex];
  [self addBatchChangeEntity:entity];
}
- (void)collapseItemWithBlock:(void (^)())update lastIndex:(NSInteger)lastIndex {
  RABatchChangeEntity *entity = [RABatchChangeEntity batchChangeEntityWithBlock:update
                                                                           type:RABatchChangeTypeItemRowCollapse
                                                                        ranking:lastIndex];
  [self addBatchChangeEntity:entity];
}
- (void)moveItemWithDeletionBlock:(void (^)())deletionUpdate fromLastIndex:(NSInteger)lastIndex additionBlock:(void (^)())additionUpdate toIndex:(NSInteger)index {
  RABatchChangeEntity *firstEntity = [RABatchChangeEntity batchChangeEntityWithBlock:deletionUpdate
                                                                                type:RABatchChangeTypeItemRowDeletion
                                                                             ranking:lastIndex];
  
  RABatchChangeEntity *secondEntity = [RABatchChangeEntity batchChangeEntityWithBlock:additionUpdate
                                                                                 type:RABatchChangeTypeItemRowInsertion
                                                                              ranking:index];
  [self addBatchChangeEntity:firstEntity];
  [self addBatchChangeEntity:secondEntity];
}
#pragma mark -
- (void)addBatchChangeEntity:(RABatchChangeEntity*)entity {
  if (self.batchChangesCounter > 0) {
    [self.operationsStorage addObject:entity];
  } else {
    entity.updatesBlock();
  }
}

@end
