
#import <UIKit/UIKit.h>
#import "RAViewController.h"

@interface RAAppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) RAViewController *viewController;
@end

@implementation RAAppDelegate
- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions {
  _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  _window.rootViewController = [UINavigationController.alloc initWithRootViewController:
        _viewController = [RAViewController.alloc initWithNibName:@"RAViewController_iPhone" bundle:nil]];
  [self.window makeKeyAndVisible];
  return YES;
}

@end

int main(int argc, char *argv[]) {
  @autoreleasepool {
      return UIApplicationMain(argc, argv, nil, NSStringFromClass([RAAppDelegate class]));
  }
}
