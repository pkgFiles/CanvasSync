#import <UIKit/UIKit.h>
#import <MediaRemote/MediaRemote.h>
#import <AVFoundation/AVFoundation.h>
#import "RemoteLog.h"

@interface CSCoverSheetViewController : UIViewController
@end

@interface SBBacklightController : NSObject
@property (nonatomic,readonly) BOOL screenIsOn;
@end

@interface SBApplicationInfo : NSObject
-(id)dataContainerURL;
@end

@interface SBApplicationController : NSObject
+(instancetype)sharedInstance;
-(id)applicationWithBundleIdentifier:(id)arg1;
@end

@interface SBApplication : NSObject
-(SBApplicationInfo *)info;
@end

@interface SBIconController : UIViewController
+(instancetype)sharedInstance;
@end

@interface SBHomeScreenViewController : UIViewController
@property (nonatomic,weak,readonly) SBIconController *iconController;
@end

@interface SBFTouchPassThroughView : UIView
@end

@interface SBDockView : UIView {
    UIView* _backgroundView;
}
@end

@interface SBFloatingDockPlatterView : UIView {
    UIView* _backgroundView;
}
@end

@interface SBFloatingDockView : SBFTouchPassThroughView
@property (nonatomic,retain) SBFloatingDockPlatterView *mainPlatterView;
@end

@interface SBMediaController : NSObject
+(instancetype)sharedInstance;
-(BOOL)isPlaying;
-(BOOL)isPaused;
@end

@interface NSDistributedNotificationCenter: NSNotificationCenter
@end
