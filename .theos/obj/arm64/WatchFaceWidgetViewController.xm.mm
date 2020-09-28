#line 1 "WatchFaceWidgetViewController.xm"
#import "WatchFaceWidgetViewController.h"

static NSMutableDictionary *colorDictionary;

static NSString *nsNotificationString = @"com.nahtedetihw.watchfacewidget/preferences.changed";


NSDateFormatter *dateFormatterHour;
UITapGestureRecognizer *tapGesture;
UIImpactFeedbackGenerator *gen;


@implementation WatchFaceWidgetViewController

-(void)viewDidLoad {
	[super viewDidLoad];


	self.square = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
	[self.view addSubview:self.square];

	self.square.translatesAutoresizingMaskIntoConstraints = NO;
	[self.square.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
	[self.square.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
	[self.square.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
	[self.square.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
    
    NSInteger blurBackground = [widgetOptions[@"blurSelection"] integerValue];
    
    self.blurEffectView = [[UIVisualEffectView alloc] initWithFrame:self.square.bounds];

    if (blurBackground == 0) {

        self.square.backgroundColor = [SparkColourPickerUtils colourWithString:[colorDictionary objectForKey:@"backgroundColor"] withFallback:@"#000000"];
        
        self.blurEffectView.hidden = YES;

    } else if (blurBackground == 1) {
        
        UIBlurEffect *blurEffect;
        UIBlurEffect *blurEffect2;
        if(@available(iOS 13.0, *)) {
            blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemUltraThinMaterial];
            self.blurEffectView.effect = blurEffect;
        } else if (@available(iOS 11.0, *)) {
            blurEffect2 = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
            self.blurEffectView.effect = blurEffect2;
        }
    
            self.square.backgroundColor = [UIColor clearColor];
    
            self.blurEffectView.hidden = NO;
            
        }
        
        self.blurEffectView.layer.cornerRadius = self.view.frame.size.height/7;
        self.blurEffectView.frame = self.view.bounds;
        self.blurEffectView.layer.masksToBounds = YES;
        
        [self.square insertSubview:self.blurEffectView atIndex:0];

	tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
	[self.square addGestureRecognizer:tapGesture];


	self.hourLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, self.view.frame.size.width-10, self.view.frame.size.height/2)];
	self.hourLabel.textAlignment = NSTextAlignmentRight;
	self.hourLabel.textColor = [SparkColourPickerUtils colourWithString:[colorDictionary objectForKey:@"labelHourColor"] withFallback:@"#FFFFFF"];
	self.hourLabel.lineBreakMode = NSLineBreakByWordWrapping;
	self.hourLabel.numberOfLines = 2;
	[self.square addSubview:self.hourLabel];


	self.minuteLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height/2-10, self.view.frame.size.width-10, self.view.frame.size.height/2)];
	self.minuteLabel.textAlignment = NSTextAlignmentRight;
	self.minuteLabel.textColor = [SparkColourPickerUtils colourWithString:[colorDictionary objectForKey:@"labelMinuteColor"] withFallback:@"#FFFFFF"];
	self.minuteLabel.lineBreakMode = NSLineBreakByWordWrapping;
	self.minuteLabel.numberOfLines = 2;
	[self.square addSubview:self.minuteLabel];


	[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(refreshTime) userInfo:nil repeats:YES];


	
	NSInteger hourFormatSelected = [widgetOptions[@"hourFormat"] integerValue];

	
	if (hourFormatSelected == 0) { 

		[dateFormatterHour setDateFormat:@"h"];

	}else if (hourFormatSelected == 1) { 

		[dateFormatterHour setDateFormat:@"HH"];

	}


	NSInteger tapGestureSelected = [widgetOptions[@"tapGestureOption"] integerValue];

	if (tapGestureSelected == 0) {

		tapGesture.numberOfTapsRequired = 1;

	}else if (tapGestureSelected == 1) {

		tapGesture.numberOfTapsRequired = 2;

	}


}



-(void)refreshTime {

	
	NSInteger hourFormatSelected = [widgetOptions[@"hourFormat"] integerValue];

	
	if (hourFormatSelected == 0) { 

		dateFormatterHour = [[NSDateFormatter alloc] init];
		[dateFormatterHour setDateFormat:@"h"];
		self.hourLabel.text = [dateFormatterHour stringFromDate:[NSDate date]];

	}else if (hourFormatSelected == 1) { 

		dateFormatterHour = [[NSDateFormatter alloc] init];
		[dateFormatterHour setDateFormat:@"HH"];
		self.hourLabel.text = [dateFormatterHour stringFromDate:[NSDate date]];

	}


	
	NSDateFormatter *dateFormatterMinute = [[NSDateFormatter alloc] init];
	[dateFormatterMinute setDateFormat:@":mm"];
	self.minuteLabel.text = [dateFormatterMinute stringFromDate:[NSDate date]];

}


- (void)handleTapGesture:(UITapGestureRecognizer *)sender {

	NSInteger hapticSelected = [widgetOptions[@"useHapticOption"] integerValue];

	if (hapticSelected == 0) {

		gen = nil;

	}else if (hapticSelected == 1) {

		gen = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
		[gen impactOccurred];

	}

	[[UIApplication sharedApplication] launchApplicationWithIdentifier:@"com.apple.mobiletimer" suspended:0];
}


-(void)viewWillLayoutSubviews {

	[super viewWillLayoutSubviews];

	self.hourLabel.frame = CGRectMake(0, 10, self.view.frame.size.width-10, self.view.frame.size.height/2);

	self.hourLabel.font = [UIFont boldSystemFontOfSize:80];

	self.minuteLabel.frame = CGRectMake(0, self.view.frame.size.height/2-10, self.view.frame.size.width-10, self.view.frame.size.height/2);

	self.minuteLabel.font = [UIFont boldSystemFontOfSize:80];

	self.square.layer.cornerRadius = self.view.frame.size.height/7;
	self.cornerRadius = self.view.frame.size.height/7;
    self.blurEffectView.layer.cornerRadius = self.view.frame.size.height/7;
    self.blurEffectView.frame = self.view.bounds;
    self.blurEffectView.layer.masksToBounds = YES;

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


	if ([key isEqualToString:@"hourFormat"]) {

		
		NSInteger hourFormatSelected = [widgetOptions[@"hourFormat"] integerValue];

		
		if (hourFormatSelected == 0) { 

			[dateFormatterHour setDateFormat:@"h"];

		} else if (hourFormatSelected == 1){ 

			[dateFormatterHour setDateFormat:@"HH"];

		}
	}


	if ([key isEqualToString:@"tapGestureOption"]) {

		NSInteger tapGestureSelected = [widgetOptions[@"tapGestureOption"] integerValue];

		if (tapGestureSelected == 0) {

			tapGesture.numberOfTapsRequired = 1;

		}else if (tapGestureSelected == 1) {

			tapGesture.numberOfTapsRequired = 2;

		}

	}


	if ([key isEqualToString:@"useHapticOption"]) {

		NSInteger hapticSelected = [widgetOptions[@"useHapticOption"] integerValue];

		if (hapticSelected == 0) {

			gen = nil;

		}else if (hapticSelected == 1) {

			gen = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
			[gen impactOccurred];

		}

	}
 
    if ([key isEqualToString:@"blurSelection"]) {
 
        NSInteger blurBackground = [widgetOptions[@"blurSelection"] integerValue];

    if (blurBackground == 0) {

        self.square.backgroundColor = [SparkColourPickerUtils colourWithString:[colorDictionary objectForKey:@"backgroundColor"] withFallback:@"#000000"];
        
        self.blurEffectView.hidden = YES;

    } else if (blurBackground == 1) {

        UIBlurEffect *blurEffect;
        UIBlurEffect *blurEffect2;
        if(@available(iOS 13.0, *)) {
            blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemUltraThinMaterial];
            self.blurEffectView.effect = blurEffect;
        } else if (@available(iOS 11.0, *)) {
            blurEffect2 = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
            self.blurEffectView.effect = blurEffect2;
        }
    
            self.square.backgroundColor = [UIColor clearColor];
    
            self.blurEffectView.hidden = NO;
            
        }
        
    }


}


static void notificationCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {

	
	colorDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/private/var/mobile/Library/Preferences/com.nahtedetihw.watchfacewidget.color.plist"];

}


@end


static __attribute__((constructor)) void _logosLocalCtor_319290b9(int __unused argc, char __unused **argv, char __unused **envp) {

	notificationCallback(NULL, NULL, NULL, NULL, NULL);
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, notificationCallback, (CFStringRef)nsNotificationString, NULL, CFNotificationSuspensionBehaviorCoalesce);

};
