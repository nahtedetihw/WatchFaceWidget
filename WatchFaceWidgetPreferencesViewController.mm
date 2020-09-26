#import "WatchFaceWidgetPreferencesViewController.h"

@implementation WatchFaceWidgetPreferencesViewController
-(NSArray *)specifiers {
    if (!_specifiers) {
        _specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
    }

    return _specifiers;
}
@end
