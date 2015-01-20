

#import "RATreeNodeCollectionController.h"
#import "RATreeNodeController.h"
#import "RATreeNode.h"
#import "RATreeNodeItem+Private.h"
#import "RABatchChanges.h"

@interface RATreeNodeCollectionController () <RATreeNodeControllerDelegate, RATreeNodeItemDataSource>
@property (nonatomic, strong) RATreeNodeController *rootController;
@end

@implementation RATreeNodeCollectionController
- (NSInteger)numberOfVisibleRowsForItems {
  return self.rootController.numberOfVisibleDescendants;
}
- (RATreeNode*)treeNodeForIndex:(NSInteger)index {
  return [self.rootController controllerForIndex:index].treeNode;
}
- (NSInteger)indexForItem:item {
  return [self.rootController indexForItem:item];
}
- (NSInteger)lastVisibleDescendantIndexForItem:item {
  return [self.rootController lastVisibleDescendatIndexForItem:item];
}
- (id)parentForItem:item {
  RATreeNodeController *controller = [self.rootController controllerForItem:item];
  return controller.parentController.treeNode.item;
}
- (NSInteger)levelForItem:item {
  return [self.rootController controllerForItem:item].level;
}
- (id)childInParent:(id)parent atIndex:(NSInteger)index {
  RATreeNodeController *controller = [self.rootController controllerForItem:parent].childControllers[index];
  return controller.treeNode.item;
}
- (void)expandRowForItem:item updates:(void (^)(NSIndexSet*))updates {
  NSParameterAssert(updates);
  
  RATreeNodeController *parentController = [self.rootController controllerForItem:item];
  
  NSInteger numberOfChildren = [self.dataSource treeNodeCollectionController:self numberOfChildrenForItem:parentController.treeNode.item];
  NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, numberOfChildren)];
  NSArray *childControllers = [self controllersForNodesWithIndexes:indexes inParentController:parentController];
  
  [parentController insertChildControllers:childControllers atIndexes:indexes];
  [parentController expand];
  
  updates(parentController.descendantsIndexes);
}
- (void)collapseRowForItem:item updates:(void (^)(NSIndexSet*))updates {
  NSParameterAssert(updates);
  
  RATreeNodeController *controller = [self.rootController controllerForItem:item];
  NSIndexSet *deletions = controller.descendantsIndexes;
  [controller collapse];
  
  updates(deletions);
}
- (void)insertItemsAtIndexes:(NSIndexSet*)indexes inParent:item {
  RATreeNodeController *parentController = [self.rootController controllerForItem:item];
  NSArray *newControllers = [self controllersForNodesWithIndexes:indexes inParentController:parentController];
  [parentController insertChildControllers:newControllers atIndexes:indexes];
}
- (void)moveItemAtIndex:(NSInteger)index inParent:(id)parent toIndex:(NSInteger)newIndex inParent:(id)newParent updates:(void (^)(NSIndexSet *, NSIndexSet*))updates {
  NSParameterAssert(updates);
  
  NSMutableIndexSet *removedIndexes = [NSMutableIndexSet indexSet];
  NSMutableIndexSet *addedIndexes = [NSMutableIndexSet indexSet];
  
  RATreeNodeController *parentController = [self.rootController controllerForItem:parent];
  
  if (parent == newParent) {
    [parentController moveChildControllerAtIndex:index toIndex:newIndex];
    
  } else {
    RATreeNodeController *childController = parentController.childControllers[index];
    
    [removedIndexes addIndex:childController.index];
    [removedIndexes addIndexes:childController.descendantsIndexes];
    
    RATreeNodeController *newParentController = [self.rootController controllerForItem:parent];
    [parentController removeChildControllersAtIndexes:[NSIndexSet indexSetWithIndex:index]];
    [newParentController insertChildControllers:@[childController] atIndexes:[NSIndexSet indexSetWithIndex:newIndex]];
    
    [addedIndexes addIndex:childController.index];
    [addedIndexes addIndexes:childController.descendantsIndexes];
  }
  
  updates(removedIndexes, addedIndexes);
}
- (void)removeItemsAtIndexes:(NSIndexSet*)indexes inParent:item updates:(void (^)(NSIndexSet*))updates {
  RATreeNodeController *parentController = [self.rootController controllerForItem:item];
  
  NSMutableIndexSet *indexesToRemoval = [NSMutableIndexSet indexSet];
  [indexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
    RATreeNodeController *controller = parentController.childControllers[idx];
    [indexesToRemoval addIndex:controller.index];
    [indexesToRemoval addIndexes:controller.descendantsIndexes];
  }];
  
  [parentController removeChildControllersAtIndexes:indexes];
  
  updates(indexesToRemoval);
}
- (NSArray*)controllersForNodesWithIndexes:(NSIndexSet*)indexes inParentController:(RATreeNodeController*)parentController {
  NSMutableArray *newControllers = [NSMutableArray array];
  [indexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
    RATreeNodeItem *lazyItem = [[RATreeNodeItem alloc] initWithParent:parentController.treeNode.item index:idx];
    [lazyItem setDataSource:self];
    RATreeNodeController *controller = [[RATreeNodeController alloc] initWithParent:parentController item:lazyItem expanded:NO];
    [newControllers addObject:controller];
  }];
  
  return [newControllers copy];
}
- (NSArray*)controllersForNodes:(NSInteger)nodesNumber inParentController:(RATreeNodeController*)parentController {
  NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, nodesNumber)];
  return [self controllersForNodesWithIndexes:indexSet inParentController:parentController];
}
#pragma mark - RATreeNodeController delegate
- (id)treeNodeController:(RATreeNodeController*)controller child:(NSInteger)childIndex {
  return [self.dataSource treeNodeCollectionController:self child:childIndex ofItem:controller.treeNode.item];
}
- (NSInteger)numberOfChildrenForTreeNodeController:(RATreeNodeController*)controller {
  return [self.dataSource treeNodeCollectionController:self numberOfChildrenForItem:controller.treeNode.item];
}

#pragma mark - RATreeNodeItem data source
- (id)itemForTreeNodeItem:(RATreeNodeItem*)treeNodeItem {
  return [self.dataSource treeNodeCollectionController:self child:treeNodeItem.index ofItem:treeNodeItem.parent];
}

#pragma mark - Properties
- (RATreeNodeController*)rootController {
  if (!_rootController) {
    _rootController = [[RATreeNodeController alloc] initWithParent:nil item:nil expanded:YES];
    
    NSInteger numberOfChildren = [self.dataSource treeNodeCollectionController:self numberOfChildrenForItem:nil];
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, numberOfChildren)];
    NSArray *childControllers = [self controllersForNodesWithIndexes:indexSet inParentController:_rootController];
    [_rootController insertChildControllers:childControllers atIndexes:indexSet];
  }
  
  return _rootController;
}
@end
