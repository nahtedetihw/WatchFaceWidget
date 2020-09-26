#import "WatchFaceWidgetViewController.h"

static NSMutableDictionary *colorDictionary;

static NSString *nsNotificationString = @"com.nahtedetihw.watchfacewidget/preferences.changed";

static bool is24h;

@implementation WatchFaceWidgetViewController

-(void)viewDidLoad {
	[super viewDidLoad];
    
    self.square = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];

    self.square.backgroundColor = [SparkColourPickerUtils colourWithString:[colorDictionary objectForKey:@"backgroundColor"] withFallback:@"#000000"];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    tapGesture.numberOfTapsRequired = 1;
    [self.square addGestureRecognizer:tapGesture];

    [self.view addSubview:self.square];
    
    self.square.translatesAutoresizingMaskIntoConstraints = NO;
    [self.square.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
    [self.square.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
    [self.square.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [self.square.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
    
    self.hourLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, self.view.frame.size.width-10, self.view.frame.size.height/2)];
    NSDateFormatter *dateFormatterHour = [[NSDateFormatter alloc] init];
    if (is24h) {
    [dateFormatterHour setDateFormat:@"HH"];
    } else {
    [dateFormatterHour setDateFormat:@"h"];
    }
    self.hourLabel.text = [dateFormatterHour stringFromDate:[NSDate date]];
    self.hourLabel.textAlignment = NSTextAlignmentRight;
    self.hourLabel.textColor = [SparkColourPickerUtils colourWithString:[colorDictionary objectForKey:@"labelHourColor"] withFallback:@"#FFFFFF"];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(showHour) userInfo:nil repeats:YES];
    self.hourLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.hourLabel.numberOfLines = 2;
    
    [self.square addSubview:self.hourLabel];
    
    self.minuteLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height/2-10, self.view.frame.size.width-10, self.view.frame.size.height/2)];
    NSDateFormatter *dateFormatterMinute = [[NSDateFormatter alloc] init];
    [dateFormatterMinute setDateFormat:@":mm"];
    self.minuteLabel.text = [dateFormatterMinute stringFromDate:[NSDate date]];
    self.minuteLabel.textAlignment = NSTextAlignmentRight;
    self.minuteLabel.textColor = [SparkColourPickerUtils colourWithString:[colorDictionary objectForKey:@"labelMinuteColor"] withFallback:@"#FFFFFF"];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(showMinute) userInfo:nil repeats:YES];
    self.minuteLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.minuteLabel.numberOfLines = 2;
    
    [self.square addSubview:self.minuteLabel];
}

- (void)showHour {
    NSDateFormatter *dateFormatterHour = [[NSDateFormatter alloc] init];
    [dateFormatterHour setDateFormat:@"h"];
    self.hourLabel.text = [dateFormatterHour stringFromDate:[NSDate date]];
}

- (void)showMinute {
    NSDateFormatter *dateFormatterMinute = [[NSDateFormatter alloc] init];
    [dateFormatterMinute setDateFormat:@":mm"];
    self.minuteLabel.text = [dateFormatterMinute stringFromDate:[NSDate date]];
}

- (void)handleTapGesture:(UITapGestureRecognizer *)sender {
    [[UIApplication sharedApplication] launchApplicationWithIdentifier:@"com.apple.mobiletimer" suspended:0];
}

/*
-(BOOL)isAccessoryTypeEnabled:(AccessoryType)accessoryType {
    if (accessoryType == AccessoryTypeExpand) {
        HSWidgetSize finalExpandedSize = HSWidgetSizeAdd(self.widgetFrame.size, 0, 2);
        return [self containsSpaceToExpandOrShrinkToWidgetSize:finalExpandedSize];
    } else if (accessoryType == AccessoryTypeShrink) {
        HSWidgetSize finalShrinkSize = HSWidgetSizeAdd(self.widgetFrame.size, 0, -2);
        return [self containsSpaceToExpandOrShrinkToWidgetSize:finalShrinkSize];
    }
    return [super isAccessoryTypeEnabled:accessoryType];
}

-(void)accessoryTypeTapped:(AccessoryType)accessory {
    if (accessory == AccessoryTypeExpand) {
            HSWidgetSize finalExpandSize = HSWidgetSizeAdd(self.widgetFrame.size, 0, 2);
            [self updateForExpandOrShrinkToWidgetSize:finalExpandSize];
    } else if (accessory == AccessoryTypeShrink) {
        HSWidgetSize finalShrinkSize = HSWidgetSizeAdd(self.widgetFrame.size, 0, -2);
        [self updateForExpandOrShrinkToWidgetSize:finalShrinkSize];
    }
}
*/

-(void)viewWillLayoutSubviews {
    
    [super viewWillLayoutSubviews];
    
    self.hourLabel.frame = CGRectMake(0, 10, self.view.frame.size.width-10, self.view.frame.size.height/2);
    
    self.hourLabel.font = [UIFont boldSystemFontOfSize:80];
    
    self.minuteLabel.frame = CGRectMake(0, self.view.frame.size.height/2-10, self.view.frame.size.width-10, self.view.frame.size.height/2);
    
    self.minuteLabel.font = [UIFont boldSystemFontOfSize:80];
    
    self.square.layer.cornerRadius = self.view.frame.size.height/7;
    self.cornerRadius = self.view.frame.size.height/7;
    
}

+(HSWidgetSize)minimumSize {
    return HSWidgetSizeMake(2, 2);
}

-(void)setWidgetOptionValue:(id<NSCoding>)object forKey:(NSString *)key {
    [super setWidgetOptionValue:object forKey:key];

    if ([key isEqualToString:@"backgroundColor"]) {
    
        self.square.backgroundColor = [SparkColourPickerUtils colourWithString:[colorDictionary objectForKey:@"backgroundColor"] withFallback:@"#000000"];
        
        notificationCallback(NULL, NULL, NULL, NULL, NULL);
        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, notificationCallback, (CFStringRef)nsNotificationString, NULL, CFNotificationSuspensionBehaviorCoalesce);
        
    }
    
    if ([key isEqualToString:@"labelHourColor"]) {
        
        self.hourLabel.textColor = [SparkColourPickerUtils colourWithString:[colorDictionary objectForKey:@"labelHourColor"] withFallback:@"#FFFFFF"];
        
        notificationCallback(NULL, NULL, NULL, NULL, NULL);
        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, notificationCallback, (CFStringRef)nsNotificationString, NULL, CFNotificationSuspensionBehaviorCoalesce);

    }
    
        if ([key isEqualToString:@"labelMinuteColor"]) {
        
        self.minuteLabel.textColor = [SparkColourPickerUtils colourWithString:[colorDictionary objectForKey:@"labelMinuteColor"] withFallback:@"#FFFFFF"];
        
        notificationCallback(NULL, NULL, NULL, NULL, NULL);
        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, notificationCallback, (CFStringRef)nsNotificationString, NULL, CFNotificationSuspensionBehaviorCoalesce);

    }
}

static void notificationCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {

    // Notification for colors
    colorDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/private/var/mobile/Library/Preferences/com.nahtedetihw.watchfacewidget.color.plist"];
}

@end

%ctor {

    notificationCallback(NULL, NULL, NULL, NULL, NULL);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, notificationCallback, (CFStringRef)nsNotificationString, NULL, CFNotificationSuspensionBehaviorCoalesce);
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateStyle:NSDateFormatterNoStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    NSString *dateString = [formatter stringFromDate:[NSDate date]];
    NSRange amRange = [dateString rangeOfString:[formatter AMSymbol]];
    NSRange pmRange = [dateString rangeOfString:[formatter PMSymbol]];
    is24h = (amRange.location == NSNotFound && pmRange.location == NSNotFound);
    
};
