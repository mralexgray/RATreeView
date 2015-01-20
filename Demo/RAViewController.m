
#import "RAViewController.h"
#import "RATableViewCell.h"

@implementation RAViewController

- (void)viewDidLoad {

  [super viewDidLoad];
  
  [self loadData];
  
  RATreeView *treeView = [RATreeView.alloc initWithFrame:self.view.bounds];
  
  treeView.delegate = self;
  treeView.dataSource = self;
  treeView.separatorStyle = RATreeViewCellSeparatorStyleSingleLine;

  self.treeView = treeView;

  [treeView reloadData];
  [treeView setBackgroundColor:[UIColor colorWithWhite:0.4 alpha:1.0]];

  [self.view insertSubview:treeView atIndex:0];
  
  [self.navigationController setNavigationBarHidden:NO];
  self.navigationItem.title = NSLocalizedString(@"Things", nil);
  [self updateNavigationItemButton];
  
  [self.treeView registerNib:[UINib nibWithNibName:NSStringFromClass([RATableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([RATableViewCell class])];
}
- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
//  if([[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."][0] intValue] >= 7) {
//    CGRect statusBarViewRect = [[UIApplication sharedApplication] statusBarFrame];
//    float heightPadding = statusBarViewRect.size.height+self.navigationController.navigationBar.frame.size.height;
//    self.treeView.contentInset = UIEdgeInsetsMake(heightPadding, 0.0, 0.0, 0.0);
//    self.treeView.contentOffset = CGPointMake(0.0, -heightPadding);
//  }
  self.treeView.frame = self.view.bounds;
}
#pragma mark - Actions 

- (void)editButtonTapped:(id)sender {
  [self.treeView setEditing:!self.treeView.isEditing animated:YES];
  [self updateNavigationItemButton];
}

- (void)updateNavigationItemButton {
  UIBarButtonSystemItem systemItem = self.treeView.isEditing ? UIBarButtonSystemItemDone : UIBarButtonSystemItemEdit;
  self.editButton = [UIBarButtonItem.alloc initWithBarButtonSystemItem:systemItem target:self action:@selector(editButtonTapped:)];
  self.navigationItem.rightBarButtonItem = _editButton;
}
#pragma mark TreeView Delegate methods

- (CGFloat) treeView:(RATreeView*)_    heightForRowForItem:item { return 44; }
- (BOOL)    treeView:(RATreeView*)_      canEditRowForItem:item { return YES; }
- (void)    treeView:(RATreeView*)_   willExpandRowForItem:item {

  [(RATableViewCell*)[_ cellForItem:item] setAdditionButtonHidden:NO animated:YES];
}
- (void)    treeView:(RATreeView*)_ willCollapseRowForItem:item {

  [(RATableViewCell*)[_ cellForItem:item] setAdditionButtonHidden:YES animated:YES];
}
- (void)    treeView:(RATreeView*)_ commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowForItem:item {

  if (editingStyle != UITableViewCellEditingStyleDelete)    return;
  
  RADataObject *parent = [self.treeView parentForItem:item];
  NSInteger index = 0;
  
  if (!parent) {
    index = [self.data indexOfObject:item];
    NSMutableArray *children = [self.data mutableCopy];
    [children removeObject:item];
    self.data = [children copy];
    
  } else {
    index = [parent.children indexOfObject:item];
    [parent removeChild:item];
  }
  
  [self.treeView deleteItemsAtIndexes:[NSIndexSet indexSetWithIndex:index] inParent:parent withAnimation:RATreeViewRowAnimationRight];
  if (parent) [self.treeView reloadRowsForItems:@[parent] withRowAnimation:RATreeViewRowAnimationNone];
}

#pragma mark TreeView Data Source

- (UITableViewCell*)treeView:(RATreeView*)_ cellForItem:(id<RADataObject>)item {
  
  NSInteger level = [self.treeView levelForCellForItem:item];
  NSInteger numberOfChildren = ((RADataObject*)item).children.count;
  NSString *detailText = [NSString localizedStringWithFormat:@"Number of children %@", [@(numberOfChildren) stringValue]];
  BOOL expanded = [self.treeView isCellForItemExpanded:item];
  
  RATableViewCell *cell = [self.treeView dequeueReusableCellWithIdentifier:NSStringFromClass([RATableViewCell class])];
  [cell setupWithTitle:item.name detailText:detailText level:level additionButtonHidden:!expanded];
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  
  __weak typeof(self) weakSelf = self;
  cell.additionButtonTapAction = ^(id sender){
    if (![weakSelf.treeView isCellForItemExpanded:item] || weakSelf.treeView.isEditing) {
      return;
    }
    RADataObject *newDataObject = [RADataObject dataObjectWithName:@"Added value" children:@[]];
    [item addChild:newDataObject];
    [weakSelf.treeView insertItemsAtIndexes:[NSIndexSet indexSetWithIndex:0] inParent:item withAnimation:RATreeViewRowAnimationLeft];
    [weakSelf.treeView reloadRowsForItems:@[item] withRowAnimation:RATreeViewRowAnimationNone];
  };
  
  return cell;
}
- (NSInteger)       treeView:(RATreeView*)_ numberOfChildrenOfItem:(id<RADataObject>)item {

    return !item ? self.data.count : item.children.count;
}
-                   treeView:(RATreeView*)_ child:(NSInteger)index ofItem:(id<RADataObject>)item {

  return !item ? self.data[index] : item.children[index];
}

#pragma mark - Helpers

- (void)loadData {

  RADataObject *phone = [RADataObject dataObjectWithName:@"Phones"
                                                children:[RADataObject dataObjectsWithNames:@[@"Phone 1", @"Phone 2", @"Phone 2222"]]];
  
  RADataObject *notebook1 = [RADataObject dataObjectWithName:@"Notebook 1" children:nil];
  RADataObject *notebook2 = [RADataObject dataObjectWithName:@"Notebook 2" children:nil];
  
  RADataObject *computer1 = [RADataObject dataObjectWithName:@"Computer 1"
                                                    children:@[notebook1, notebook2]];
  RADataObject *computer2 = [RADataObject dataObjectWithName:@"Computer 2" children:nil];
  RADataObject *computer3 = [RADataObject dataObjectWithName:@"Computer 3" children:nil];
  
  RADataObject *computer = [RADataObject dataObjectWithName:@"Computers"
                                                   children:@[computer1, computer2, computer3]];
  RADataObject *car = [RADataObject dataObjectWithName:@"Cars" children:nil];
  RADataObject *bike = [RADataObject dataObjectWithName:@"Bikes" children:nil];
  RADataObject *house = [RADataObject dataObjectWithName:@"Houses" children:nil];
  RADataObject *flats = [RADataObject dataObjectWithName:@"Flats" children:nil];
  RADataObject *motorbike = [RADataObject dataObjectWithName:@"Motorbikes" children:nil];
  RADataObject *drinks = [RADataObject dataObjectWithName:@"Drinks" children:nil];
  RADataObject *food = [RADataObject dataObjectWithName:@"Food" children:nil];
  RADataObject *sweets = [RADataObject dataObjectWithName:@"Sweets" children:nil];
  RADataObject *watches = [RADataObject dataObjectWithName:@"Watches" children:nil];
  RADataObject *walls = [RADataObject dataObjectWithName:@"Walls" children:nil];
  
  self.data = @[phone, computer, car, bike, house, flats, motorbike, drinks, food, sweets, watches, walls];
}
@end
