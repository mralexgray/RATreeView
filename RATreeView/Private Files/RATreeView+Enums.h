
#import "RATreeView.h"
@interface RATreeView (Enums)
//Row Animations
+ (UITableViewRowAnimation)tableViewRowAnimationForTreeViewRowAnimation:(RATreeViewRowAnimation)rowAnimation;
//Cell Separator Styles
+ (RATreeViewCellSeparatorStyle)treeViewCellSeparatorStyleForTableViewSeparatorStyle:(UITableViewCellSeparatorStyle)style;
+ (UITableViewCellSeparatorStyle)tableViewCellSeparatorStyleForTreeViewCellSeparatorStyle:(RATreeViewCellSeparatorStyle)style;
//Tree View Style
+ (UITableViewStyle)tableViewStyleForTreeViewStyle:(RATreeViewStyle)treeViewStyle;
+ (RATreeViewStyle)treeViewStyleForTableViewStyle:(UITableViewStyle)tableViewStyle;
//Scroll Positions
+ (UITableViewScrollPosition)tableViewScrollPositionForTreeViewScrollPosition:(RATreeViewScrollPosition)scrollPosition;
@end
