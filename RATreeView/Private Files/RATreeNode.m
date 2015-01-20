

#import "RATreeNode.h"
#import "RATreeNodeItem.h"

typedef enum RATreeDepthLevel {
  RATreeDepthLevelNotInitialized
} RATreeDepthLevel;
@interface RATreeNode ()
@property (nonatomic, getter = isExpanded, readwrite) BOOL expanded;
@property (nonatomic) NSInteger treeDepthLevel;
@property (strong, nonatomic) RATreeNodeItem *lazyItem;
@property (strong, nonatomic) NSArray *descendants;
@end
@implementation RATreeNode
- (id)initWithLazyItem:(RATreeNodeItem*)item expanded:(BOOL)expanded {
  self = [super init];
  if (self) {
    _treeDepthLevel = RATreeDepthLevelNotInitialized;
    _lazyItem = item;
    _expanded = expanded;
  }
  
  return self;
}
- (RATreeNodeItem*)item {
  return self.lazyItem.item;
}
@end
