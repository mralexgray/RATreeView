
#import "RATreeView.h"
#import "RATreeView_ClassExtension.h"
#import "RATreeView+Enums.h"
#import "RATreeView+Private.h"
#import "RATreeView+UIScrollView.h"
#import "RABatchChanges.h"
#import "RATreeNodeCollectionController.h"
#import "RATreeNode.h"
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincomplete-implementation"
@implementation RATreeView
#pragma clang diagnostic pop
//Managing the Display of Content
@dynamic contentOffset, contentSize, contentInset;
//Managing Scrolling
@dynamic scrollEnabled, directionalLockEnabled, scrollsToTop, pagingEnabled, bounces, alwaysBounceVertical, alwaysBounceHorizontal, canCancelContentTouches, delaysContentTouches, decelerationRate, dragging, tracking, decelerating;
//Managing the Scroll Indicator
@dynamic indicatorStyle, scrollIndicatorInsets, showsHorizontalScrollIndicator, showsVerticalScrollIndicator;
//- (void)flashScrollIndicators;
//Zooming and Panning
@dynamic panGestureRecognizer, pinchGestureRecognizer, zoomScale, maximumZoomScale, minimumZoomScale, zoomBouncing, zooming, bouncesZoom;
#pragma mark Initializing a TreeView Object
- init {
  return [self initWithFrame:CGRectMake(0, 0, 100, 100) style:RATreeViewStylePlain];
}
- initWithFrame:(CGRect)frame {
  return [self initWithFrame:frame style:RATreeViewStylePlain];
}
- initWithFrame:(CGRect)frame style:(RATreeViewStyle)style {
  return self = [super initWithFrame:frame] ? [self commonInitWithFrame:(CGRect){CGPointZero,self.bounds.size} style:style], self : nil;
}
- initWithCoder:(NSCoder*)aDecoder { return self = [super initWithCoder:aDecoder] ? [self commonInitWithFrame:(CGRect){CGPointZero,self.bounds.size} style:RATreeViewStylePlain], self : nil; }
- (void)commonInitWithFrame:(CGRect)frame style:(RATreeViewStyle)style {
  self.backgroundColor = UIColor.redColor;
  UITableViewStyle tableViewStyle = [RATreeView tableViewStyleForTreeViewStyle:style];
  
  UITableView *tableView =  [[UITableView alloc] initWithFrame:frame style:tableViewStyle];
  tableView.delegate = (id<UITableViewDelegate>)self;
  tableView.dataSource = (id<UITableViewDataSource>)self;
  tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  tableView.backgroundColor = [UIColor clearColor];
  [self addSubview:tableView];
  [self setTableView:tableView];
  
  self.rowsExpandingAnimation = RATreeViewRowAnimationTop;
  self.rowsCollapsingAnimation = RATreeViewRowAnimationBottom;
}
#pragma mark Configuring a Tree View
- (NSInteger)numberOfRows {
  return [self.tableView numberOfRowsInSection:0];
}
- (RATreeViewStyle)style {
  UITableViewStyle tableViewStyle = self.tableView.style;
  return [RATreeView treeViewStyleForTableViewStyle:tableViewStyle];
}
- (RATreeViewCellSeparatorStyle)separatorStyle {
  RATreeViewCellSeparatorStyle style = [RATreeView treeViewCellSeparatorStyleForTableViewSeparatorStyle:self.tableView.separatorStyle];
  return style;
}
- (void)setSeparatorStyle:(RATreeViewCellSeparatorStyle)separatorStyle {
  UITableViewCellSeparatorStyle tableViewSeparatorStyle = [RATreeView tableViewCellSeparatorStyleForTreeViewCellSeparatorStyle:separatorStyle];
  self.tableView.separatorStyle = tableViewSeparatorStyle;
}
- (UIColor*)separatorColor {
  return self.tableView.separatorColor;
}
- (void)setSeparatorColor:(UIColor*)separatorColor {
  self.tableView.separatorColor = separatorColor;
}
- (CGFloat)rowHeight {
  return self.tableView.rowHeight;
}
- (void)setRowHeight:(CGFloat)rowHeight {
  self.tableView.rowHeight = rowHeight;
}
- (CGFloat)estimatedRowHeight {
  return self.tableView.estimatedRowHeight;
}
- (void)setEstimatedRowHeight:(CGFloat)estimatedRowHeight {
  self.tableView.estimatedRowHeight = estimatedRowHeight;
}
- (UIEdgeInsets)separatorInset {
  return self.tableView.separatorInset;
}
- (void)setSeparatorInset:(UIEdgeInsets)separatorInset {
  self.tableView.separatorInset = separatorInset;
}
- (UIView*)backgroundView {
  return self.tableView.backgroundView;
}
- (void)setBackgroundView:(UIView*)backgroundView {
  self.tableView.backgroundView = backgroundView;
}
#pragma mark Expanding and Collapsing Rows
- (void)expandRowForItem:item {
  [self expandRowForItem:item withRowAnimation:self.rowsExpandingAnimation];
}
- (void)expandRowForItem:item withRowAnimation:(RATreeViewRowAnimation)animation {
  NSIndexPath *indexPath = [self indexPathForItem:item];
  RATreeNode *treeNode = [self treeNodeForIndexPath:indexPath];
  if (treeNode.expanded) {
    return;
  }
  [self expandCellForTreeNode:treeNode withRowAnimation:animation];
}
- (void)collapseRowForItem:item {
  [self collapseRowForItem:item withRowAnimation:self.rowsCollapsingAnimation];
}
- (void)collapseRowForItem:item withRowAnimation:(RATreeViewRowAnimation)animation {
  NSIndexPath *indexPath = [self indexPathForItem:item];
  RATreeNode *treeNode = [self treeNodeForIndexPath:indexPath];
  [self collapseCellForTreeNode:treeNode withRowAnimation:animation];
}
#pragma mark - Changing tree's structure
- (void)beginUpdates {
  [self.tableView beginUpdates];
  [self.batchChanges beginUpdates];
}
- (void)endUpdates {
  [self.batchChanges endUpdates];
  [self.tableView endUpdates];
}
- (void)insertItemsAtIndexes:(NSIndexSet*)indexes inParent:(id)parent withAnimation:(RATreeViewRowAnimation)animation {
  if (parent && ![self isCellForItemExpanded:parent]) {
    return;
  }
  __weak typeof(self) weakSelf = self;
  [indexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
    [weakSelf insertItemAtIndex:idx inParent:parent withAnimation:animation];
  }];
}
- (void)deleteItemsAtIndexes:(NSIndexSet*)indexes inParent:(id)parent withAnimation:(RATreeViewRowAnimation)animation {
  if (parent && ![self isCellForItemExpanded:parent]) {
    return;
  }
  __weak typeof(self) weakSelf = self;
  [indexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
    [weakSelf removeItemAtIndex:idx inParent:parent withAnimation:animation];
  }];
}
#pragma mark - Creating Table View Cells
- (void)registerNib:(UINib*)nib forCellReuseIdentifier:(NSString*)identifier {
  [self.tableView registerNib:nib forCellReuseIdentifier:identifier];
}
- (void)registerClass:(Class)cellClass forCellReuseIdentifier:(NSString*)identifier {
  [self.tableView registerClass:cellClass forCellReuseIdentifier:identifier];
}
- dequeueReusableCellWithIdentifier:(NSString*)identifier {
  return [self.tableView dequeueReusableCellWithIdentifier:identifier];
}
#pragma mark - Accessing Header and Footer Views
- (void)registerNib:(UINib*)nib forHeaderFooterViewReuseIdentifier:(NSString*)identifier {
  [self.tableView registerNib:nib forHeaderFooterViewReuseIdentifier:identifier];
}
- (void)registerClass:(Class)aClass forHeaderFooterViewReuseIdentifier:(NSString*)identifier {
  [self.tableView registerClass:aClass forHeaderFooterViewReuseIdentifier:identifier];
}
- dequeueReusableHeaderFooterViewWithIdentifier:(NSString*)identifier {
  return [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
}
- (UIView*)treeHeaderView {
  return self.tableView.tableHeaderView;
}
- (void)setTreeHeaderView:(UIView*)treeHeaderView {
  self.tableView.tableHeaderView = treeHeaderView;
}
- (UIView*)treeFooterView {
  return self.tableView.tableFooterView;
}
- (void)setTreeFooterView:(UIView*)treeFooterView {
  self.tableView.tableFooterView = treeFooterView;
}
#pragma mark - Working with Expandability
- (BOOL)isCellForItemExpanded:item {
  NSIndexPath *indexPath = [self indexPathForItem:item];
  return [self treeNodeForIndexPath:indexPath].expanded;
}
- (BOOL)isCellExpanded:(UITableViewCell*)cell {
  id item = [self itemForCell:cell];
  return [self isCellForItemExpanded:item];
}
#pragma mark - Working with Indentation
- (NSInteger)levelForCellForItem:item {
  return [self.treeNodeCollectionController levelForItem:item];
}
- (NSInteger)levelForCell:(UITableViewCell*)cell {
  id item = [self itemForCell:cell];
  return [self levelForCellForItem:item];
}
#pragma mark - Getting the Parent for an Item
- parentForItem:item {
  return [self.treeNodeCollectionController parentForItem:item];
}
#pragma mark - Accessing Cells
- (UITableViewCell*)cellForItem:item {
  NSIndexPath *indexPath = [self indexPathForItem:item];
  return [self.tableView cellForRowAtIndexPath:indexPath];
}
- (NSArray*)visibleCells {
  return [self.tableView visibleCells];
}
- itemForCell:(UITableViewCell*)cell {
  NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
  return [self treeNodeForIndexPath:indexPath].item;
}
- itemForRowAtPoint:(CGPoint)point {
  NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
  return !indexPath ? nil : [self treeNodeForIndexPath:indexPath].item;
}
- itemsForRowsInRect:(CGRect)rect {
  NSArray *indexPaths = [self.tableView indexPathsForRowsInRect:rect];
  return [self itemsForIndexPaths:indexPaths];
}
- (NSArray*)itemsForVisibleRows {
  NSArray *indexPaths = [self.tableView indexPathsForVisibleRows];
  return [self itemsForIndexPaths:indexPaths];
}
#pragma mark - Scrolling the TreeView
- (void)scrollToRowForItem:item atScrollPosition:(RATreeViewScrollPosition)scrollPosition animated:(BOOL)animated {
  NSIndexPath *indexPath = [self indexPathForItem:item];
  UITableViewScrollPosition tableViewScrollPosition = [RATreeView tableViewScrollPositionForTreeViewScrollPosition:scrollPosition];
  [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:tableViewScrollPosition animated:animated];
}
- (void)scrollToNearestSelectedRowAtScrollPosition:(RATreeViewScrollPosition)scrollPosition animated:(BOOL)animated {
  UITableViewScrollPosition tableViewScrollPosition = [RATreeView tableViewScrollPositionForTreeViewScrollPosition:scrollPosition];
  [self.tableView scrollToNearestSelectedRowAtScrollPosition:tableViewScrollPosition animated:animated];
}
#pragma mark - Managing Selections
- itemForSelectedRow {
  return [self treeNodeForIndexPath:[self.tableView indexPathForSelectedRow]].item;
}
- (NSArray*)itemsForSelectedRows { return [self itemsForIndexPaths:/* selectedRows */[self.tableView indexPathsForSelectedRows]]; }
- (void)selectRowForItem:item animated:(BOOL)animated scrollPosition:(RATreeViewScrollPosition)scrollPosition {
  NSIndexPath *indexPath = [self indexPathForItem:item];
  UITableViewScrollPosition tableViewScrollPosition = [RATreeView tableViewScrollPositionForTreeViewScrollPosition:scrollPosition];
  [self.tableView selectRowAtIndexPath:indexPath animated:animated scrollPosition:tableViewScrollPosition];
}
- (void)deselectRowForItem:item animated:(BOOL)animated {
  NSIndexPath *indexPath = [self indexPathForItem:item];
  [self.tableView deselectRowAtIndexPath:indexPath animated:animated];
}
- (BOOL)allowsSelection {
  return self.tableView.allowsSelection;
}
- (void)setAllowsSelection:(BOOL)allowsSelection {
  self.tableView.allowsSelection = allowsSelection;
}
- (BOOL)allowsMultipleSelection {
  return self.tableView.allowsMultipleSelection;
}
- (void)setAllowsMultipleSelection:(BOOL)allowsMultipleSelection {
  self.tableView.allowsMultipleSelection = allowsMultipleSelection;
}
- (BOOL)allowsSelectionDuringEditing {
  return self.tableView.allowsSelectionDuringEditing;
}
- (void)setAllowsSelectionDuringEditing:(BOOL)allowsSelectionDuringEditing {
  self.tableView.allowsSelectionDuringEditing = allowsSelectionDuringEditing;
}
- (BOOL)allowsMultipleSelectionDuringEditing {
  return self.tableView.allowsMultipleSelectionDuringEditing;
}
- (void)setAllowsMultipleSelectionDuringEditing:(BOOL)allowsMultipleSelectionDuringEditing {
  self.tableView.allowsMultipleSelectionDuringEditing = allowsMultipleSelectionDuringEditing;
}
#pragma mark - Managing the Editing of Tree Cells
- (BOOL)isEditing {
  return self.tableView.isEditing;
}
- (void)setEditing:(BOOL)editing {
  self.tableView.editing = editing;
}
- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
  [self.tableView setEditing:editing animated:animated];
}
#pragma mark - Reloading the Tree View
- (void)reloadData {
  [self setupTreeStructure];
  [self.tableView reloadData];
}
- (void)reloadRowsForItems:(NSArray*)items withRowAnimation:(RATreeViewRowAnimation)animation {
  NSMutableArray *indexes = [NSMutableArray array];
  UITableViewRowAnimation tableViewRowAnimation = [RATreeView tableViewRowAnimationForTreeViewRowAnimation:animation];
  for (id item in items) {
    NSIndexPath *indexPath = [self indexPathForItem:item];
    [indexes addObject:indexPath];
  }
  
  [self.tableView reloadRowsAtIndexPaths:indexes withRowAnimation:tableViewRowAnimation];
}
- (void)reloadRows {
  NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:0];
  [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
}
#pragma mark - UIScrollView's properties
- (void)setContentOffset:(CGPoint)contentOffset animated:(BOOL)animated {
  [self.tableView setContentOffset:contentOffset animated:animated];
}
- (void)scrollRectToVisible:(CGRect)visible animated:(BOOL)animated {
  [self.tableView scrollRectToVisible:visible animated:animated];
}
- (void)setZoomScale:(CGFloat)zoomScale animated:(BOOL)animated {
  [self.tableView setZoomScale:zoomScale animated:animated];
}
- (void)flashScrollIndicators {
  [self.tableView flashScrollIndicators];
}
- (void)zoomToRect:(CGRect)rect animated:(BOOL)animated {
  [self.tableView zoomToRect:rect animated:animated];
}
#pragma mark - 
- (NSArray*) itemsForIndexPaths:(NSArray*)indexPaths {
  NSMutableArray *items = @[].mutableCopy;
  for (NSIndexPath *indexPath in indexPaths) [items addObject:[self treeNodeForIndexPath:indexPath].item];
  return [items copy];
}
@end

@implementation RADataObject @synthesize children = _children, name = _name;

- initWithName:(NSString*)name children:(NSArray*)children { return self = super.init ? _children = [NSArray arrayWithArray:children], _name = name,self : nil; }
+ dataObjectWithName:(NSString*)name children:(NSArray*)children { return [self.class.alloc initWithName:name children:children]; }
+ (NSArray*) dataObjectsWithNames:(NSArray*)names {
  NSMutableArray *a = @[].mutableCopy;
  for (id x in names) [a addObject:[self.class dataObjectWithName:x children:nil]];
  return [a copy];
}
- (void)addChild:(id)child {
  [[self mutableArrayValueForKey:@"children"] insertObject:child atIndex:0];
}
- (void)removeChild:(id)child {
  [[self mutableArrayValueForKey:@"children"] removeObject:child];
}
@end
