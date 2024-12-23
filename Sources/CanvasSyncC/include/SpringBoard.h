#import <UIKit/UIKit.h>

@interface SpringBoard : UIApplication
- (BOOL)isLocked;
@end

@interface SBBacklightController : NSObject
-(BOOL)screenIsOn;
@end

@interface SBApplicationInfo : NSObject
-(id)dataContainerURL;
@end

@interface SBApplicationController : NSObject
+(instancetype)sharedInstance;
-(id)allApplications;
@end

@interface SBApplication : NSObject
-(SBApplicationInfo *)info;
-(NSString *)bundleIdentifier;
@end
