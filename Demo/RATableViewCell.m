

#import "RATableViewCell.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation RATableViewCell
- (void)awakeFromNib {
  [super awakeFromNib];
  
  self.selectedBackgroundView = [UIView new];
  self.selectedBackgroundView.backgroundColor = [UIColor clearColor];
  
}
- (void)prepareForReuse {
  [super prepareForReuse];
  
  self.additionButtonHidden = NO;
}

- (void)setupWithTitle:(NSString*)title detailText:(NSString*)detailText level:(NSInteger)level additionButtonHidden:(BOOL)additionButtonHidden {
  self.customTitleLabel.text = title;
  self.detailedLabel.text = detailText;
  self.additionButtonHidden = additionButtonHidden;
  
  if (!level) self.detailTextLabel.textColor = [UIColor blackColor];
  
  self.backgroundColor = !level ? UIColorFromRGB(0xF7F7F7) : level == 1 ? UIColorFromRGB(0xD1EEFC) : level >= 2 ? UIColorFromRGB(0xE0F8D8) : self.backgroundColor;

  CGFloat left = 11 + 20 * level;
  
  CGRect titleFrame = self.customTitleLabel.frame;
  titleFrame.origin.x = left;
  self.customTitleLabel.frame = titleFrame;
  
  CGRect detailsFrame = self.detailedLabel.frame;
  detailsFrame.origin.x = left;
  self.detailedLabel.frame = detailsFrame;
}

#pragma mark - Properties
- (void)setAdditionButtonHidden:(BOOL)additionButtonHidden {
  [self setAdditionButtonHidden:additionButtonHidden animated:NO];
}
- (void)setAdditionButtonHidden:(BOOL)additionButtonHidden animated:(BOOL)animated {
  _additionButtonHidden = additionButtonHidden;
  [UIView animateWithDuration:animated ? 0.2 : 0 animations:^{
    self.additionButton.hidden = additionButtonHidden;
  }];
}

- (void) setSelected:(BOOL)selected {

  [super setSelected:selected];
  if (selected) self.backgroundColor = UIColor.redColor;

}
#pragma mark - Actions
- (IBAction)additionButtonTapped:_ { if (self.additionButtonTapAction) self.additionButtonTapAction(_); }

@end
