
#import "RATreeView+RATreeNodeCollectionControllerDataSource.h"
@implementation RATreeView (RATreeNodeCollectionControllerDataSource)
- (NSInteger)treeNodeCollectionController:(RATreeNodeCollectionController*)controller numberOfChildrenForItem:item {
  return [self.dataSource treeView:self numberOfChildrenOfItem:item];
}
- (id)treeNodeCollectionController:(RATreeNodeCollectionController*)controller child:(NSInteger)childIndex ofItem:item {
  return [self.dataSource treeView:self child:childIndex ofItem:item];
}
@end
