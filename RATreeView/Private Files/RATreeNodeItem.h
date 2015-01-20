
#import <Foundation/Foundation.h>
@interface RATreeNodeItem : NSObject
@property (nonatomic, strong, readonly) id item;
- (instancetype)initWithParent:(id)parent index:(NSInteger)index NS_DESIGNATED_INITIALIZER;
@end
