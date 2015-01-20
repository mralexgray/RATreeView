

#import <Foundation/Foundation.h>
@class RATreeNodeController, RATreeNode, RATreeNodeItem;

@protocol RATreeNodeControllerDelegate <NSObject>
@end
@interface RATreeNodeController : NSObject
@property (nonatomic, weak, readonly) RATreeNodeController *parentController;
@property (nonatomic, strong, readonly) NSArray *childControllers;
@property (nonatomic, strong, readonly) RATreeNode *treeNode;
@property (readonly) NSInteger index;
@property (readonly) NSInteger numberOfVisibleDescendants;
@property (nonatomic, strong, readonly) NSIndexSet *descendantsIndexes;
@property (readonly) NSInteger level;
- (instancetype)initWithParent:(RATreeNodeController*)parentController item:(RATreeNodeItem*)item expanded:(BOOL)expanded NS_DESIGNATED_INITIALIZER;
- (void)collapse;
- (void)expand;
- (void)insertChildControllers:(NSArray*)controllers atIndexes:(NSIndexSet*)indexes;
- (void)moveChildControllerAtIndex:(NSInteger)index toIndex:(NSInteger)newIndex;
- (void)removeChildControllersAtIndexes:(NSIndexSet*)indexes;
- (NSInteger)indexForItem:item;
- (NSInteger)lastVisibleDescendatIndexForItem:item;
- (RATreeNodeController*)controllerForIndex:(NSInteger)index;
- (RATreeNodeController*)controllerForItem:item;
@end
