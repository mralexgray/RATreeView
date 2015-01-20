

#import <Foundation/Foundation.h>
@class RATreeNodeItem;

@interface RATreeNode : NSObject
 
@property (readonly) BOOL expanded;
@property (strong, readonly) id item;
- (id)initWithLazyItem:(RATreeNodeItem*)item expanded:(BOOL)expanded NS_DESIGNATED_INITIALIZER;
@end
