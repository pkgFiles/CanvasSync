#import <UIKit/UIKit.h>
#import <MediaRemote/MediaRemote.h>
#import <AVFoundation/AVFoundation.h>
#import "SpringBoard.h"
#import "RemoteLog.h"

@interface CSCoverSheetViewController : UIViewController
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
-(void)setNowPlayingInfo:(id)arg1;
-(BOOL)isPlaying;
-(BOOL)isPaused;
@end

@interface UIView(Private)
- (__kindof UIViewController *)_viewControllerForAncestor;
@end
