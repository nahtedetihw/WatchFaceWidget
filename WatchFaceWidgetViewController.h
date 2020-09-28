#import <HSWidgets/HSWidgetViewController.h>
#import <SparkColourPickerUtils.h>
#import <SparkColourPickerView.h>
#import "MediaRemote.h"

@interface WatchFaceWidgetViewController : HSWidgetViewController
@property (nonatomic, strong) UIView *square;
@property (nonatomic, strong) UILabel *hourLabel;
@property (nonatomic, strong) UILabel *minuteLabel;
@property (nonatomic, retain) UIVisualEffectView *blurEffectView;
@end

@interface UIApplication (WatchFaceWidget)
- (BOOL)launchApplicationWithIdentifier:(id)arg1 suspended:(BOOL)arg2 ;
@end
