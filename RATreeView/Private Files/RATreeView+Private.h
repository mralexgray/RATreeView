
#import "RATreeView.h"
@class RATreeNode;
@interface RATreeView (Private)
- (RATreeNode*)treeNodeForIndexPath:(NSIndexPath*)indexPath;
- (NSIndexPath*)indexPathForItem:item;
- (void)setupTreeStructure;
- (void)collapseCellForTreeNode:(RATreeNode*)treeNode;
- (void)collapseCellForTreeNode:(RATreeNode*)treeNode withRowAnimation:(RATreeViewRowAnimation)rowAnimation;
- (void)expandCellForTreeNode:(RATreeNode*)treeNode;
- (void)expandCellForTreeNode:(RATreeNode*)treeNode withRowAnimation:(RATreeViewRowAnimation)rowAnimation;
- (void)insertItemAtIndex:(NSInteger)index inParent:(id)parent withAnimation:(RATreeViewRowAnimation)animation;
- (void)removeItemAtIndex:(NSInteger)indexe inParent:(id)parent withAnimation:(RATreeViewRowAnimation)animation;
@end
