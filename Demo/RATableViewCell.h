

#import <UIKit/UIKit.h>

@interface RATableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *detailedLabel, *customTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *additionButton;

@property (nonatomic, copy) void (^additionButtonTapAction)(id sender);
@property (nonatomic) BOOL additionButtonHidden;

- (void)          setupWithTitle:(NSString*)t           detailText:(NSString*)d
                           level:(NSInteger)l additionButtonHidden:(BOOL)_;

- (void) setAdditionButtonHidden:(BOOL)_                  animated:(BOOL)a;
@end
