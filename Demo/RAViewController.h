
#import <UIKit/UIKit.h>
#import "RATreeView.h"
@interface RAViewController : UIViewController <RATreeViewDelegate, RATreeViewDataSource>
@property (nonatomic) NSArray *data;
@property (weak, nonatomic) RATreeView *treeView;
@property (nonatomic) UIBarButtonItem *editButton;
@end
