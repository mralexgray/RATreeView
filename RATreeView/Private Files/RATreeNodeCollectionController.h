

#import <Foundation/Foundation.h>
@class RATreeNodeController, RATreeNode, RATreeNodeCollectionController;
@protocol RATreeNodeCollectionControllerDataSource <NSObject>
- (NSInteger)treeNodeCollectionController:(RATreeNodeCollectionController*)controller numberOfChildrenForItem:item;
- (id)treeNodeCollectionController:(RATreeNodeCollectionController*)controller child:(NSInteger)childIndex ofItem:item;
@end

@interface RATreeNodeCollectionController : NSObject
@property (strong, nonatomic) id<RATreeNodeCollectionControllerDataSource> dataSource;
@property (readonly) NSInteger numberOfVisibleRowsForItems;
- (RATreeNode*)treeNodeForIndex:(NSInteger)index;
- (NSInteger)levelForItem:item;
- (id)parentForItem:item;
- (id)childInParent:(id)parent atIndex:(NSInteger)index;
- (NSInteger)indexForItem:item;
- (NSInteger)lastVisibleDescendantIndexForItem:item;
- (void)expandRowForItem:item updates:(void(^)(NSIndexSet*))updates;
- (void)collapseRowForItem:item updates:(void(^)(NSIndexSet*))updates;
- (void)insertItemsAtIndexes:(NSIndexSet*)indexes inParent:item;
- (void)moveItemAtIndex:(NSInteger)index inParent:(id)parent toIndex:(NSInteger)newIndex inParent:(id)newParent updates:(void(^)(NSIndexSet *deletions, NSIndexSet *additions))updates;
- (void)removeItemsAtIndexes:(NSIndexSet*)indexes inParent:item updates:(void(^)(NSIndexSet*))updates;
@end
