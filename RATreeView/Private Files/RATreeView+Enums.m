
#import "RATreeView+Enums.h"
#import "RATreeView.h"
@implementation RATreeView (Enums)
#pragma mark Row Animations
+ (UITableViewRowAnimation)tableViewRowAnimationForTreeViewRowAnimation:(RATreeViewRowAnimation)rowAnimation {
  switch (rowAnimation) {
    case RATreeViewRowAnimationFade:
      return UITableViewRowAnimationFade;
    case RATreeViewRowAnimationNone:
      return UITableViewRowAnimationNone;
    case RATreeViewRowAnimationAutomatic:
      return UITableViewRowAnimationAutomatic;
    case RATreeViewRowAnimationBottom:
      return UITableViewRowAnimationBottom;
    case RATreeViewRowAnimationLeft:
      return UITableViewRowAnimationLeft;
    case RATreeViewRowAnimationMiddle:
      return UITableViewRowAnimationMiddle;
    case RATreeViewRowAnimationRight:
      return UITableViewRowAnimationRight;
    case RATreeViewRowAnimationTop:
      return UITableViewRowAnimationTop;
    default:
      return UITableViewRowAnimationNone;
  }
}
#pragma mark Cell Separator Styles
+ (RATreeViewCellSeparatorStyle)treeViewCellSeparatorStyleForTableViewSeparatorStyle:(UITableViewCellSeparatorStyle)style {
  switch (style) {
    case UITableViewCellSeparatorStyleNone:
      return RATreeViewCellSeparatorStyleNone;
    case UITableViewCellSeparatorStyleSingleLine:
      return RATreeViewCellSeparatorStyleSingleLine;
    case UITableViewCellSeparatorStyleSingleLineEtched:
      return RATreeViewCellSeparatorStyleSingleLineEtched;
    default:
      return RATreeViewCellSeparatorStyleNone;
  }
}
+ (UITableViewCellSeparatorStyle)tableViewCellSeparatorStyleForTreeViewCellSeparatorStyle:(RATreeViewCellSeparatorStyle)style {
  switch (style) {
    case RATreeViewCellSeparatorStyleNone:
      return UITableViewCellSeparatorStyleNone;
    case RATreeViewCellSeparatorStyleSingleLine:
      return UITableViewCellSeparatorStyleSingleLine;
    case RATreeViewCellSeparatorStyleSingleLineEtched:
      return UITableViewCellSeparatorStyleSingleLineEtched;
    default:
      return UITableViewCellSeparatorStyleNone;
  }
}
#pragma mark Tree View Style
+ (UITableViewStyle)tableViewStyleForTreeViewStyle:(RATreeViewStyle)treeViewStyle {
  switch (treeViewStyle) {
    case RATreeViewStylePlain:
      return UITableViewStylePlain;
    case RATreeViewStyleGrouped:
      return UITableViewStyleGrouped;
  }
}
+ (RATreeViewStyle)treeViewStyleForTableViewStyle:(UITableViewStyle)tableViewStyle {
  switch (tableViewStyle) {
    case UITableViewStylePlain:
      return RATreeViewStylePlain;
    case UITableViewStyleGrouped:
      return RATreeViewStyleGrouped;
  }
}
#pragma mark Scroll Positions
+ (UITableViewScrollPosition)tableViewScrollPositionForTreeViewScrollPosition:(RATreeViewScrollPosition)scrollPosition {
  switch (scrollPosition) {
    case RATreeViewScrollPositionNone:
      return UITableViewScrollPositionNone;
    case RATreeViewScrollPositionTop:
      return UITableViewScrollPositionTop;
    case RATreeViewScrollPositionMiddle:
      return UITableViewScrollPositionMiddle;
    case RATreeViewScrollPositionBottom:
      return UITableViewScrollPositionBottom;
    default:
      return UITableViewScrollPositionNone;
  }
}
@end
