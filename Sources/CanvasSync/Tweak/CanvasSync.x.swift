import Orion
import CanvasSyncC

// CanvasSync - Display artwork or Spotify Canvas as wallpaper.
// For modern iOS 15.0 - 16.7.10
// Based on original from @sugiuta: https://havoc.app/package/canvaslife
//MARK: - Variables
///Preferences
var tweakPrefs: SettingsModel = SettingsModel()

///Tweak
var canvasInstances: [(gradientView: CSGradientView?, artworkView: CSArtworkImageView?, playerView: CSCanvasPlayerView?)] = []
var externalVideoPlayerLayers: [AVPlayerLayer] = []

//MARK: - Initialize Tweak
struct CSSetNowPlayingInfo: HookGroup {}
struct CSLockscreen: HookGroup { let lockscreenEnabled: Bool }
struct CSHomescreen: HookGroup { let homescreenEnabled: Bool }
struct CSSpringBoardDock: HookGroup { let isDockBackgroundHidden: Bool }
struct CanvasSync: Tweak {
    init() {
        remLog("Preferences Loading...")
        tweakPrefs = TweakPreferences.preferences.loadPreferences()

        let canvasStyle: PreferenceCollection.CanvasStyle = .getStyle()
        let playingInfoHook: CSSetNowPlayingInfo = CSSetNowPlayingInfo()
        let lockscreenHook: CSLockscreen = CSLockscreen(lockscreenEnabled: canvasStyle == .both || canvasStyle == .lockscreen)
        let homescreenHook: CSHomescreen = CSHomescreen(homescreenEnabled: canvasStyle == .both || canvasStyle == .homescreen)
        let springboardDockHook: CSSpringBoardDock = CSSpringBoardDock(isDockBackgroundHidden: tweakPrefs.isDockBackgroundHidden)
        
        switch tweakPrefs.isTweakEnabled {
        case true:
            remLog("Tweak is Enabled! :)")
            playingInfoHook.activate()
            if lockscreenHook.lockscreenEnabled { lockscreenHook.activate() }
            if homescreenHook.homescreenEnabled {
                homescreenHook.activate()
                if springboardDockHook.isDockBackgroundHidden { springboardDockHook.activate() }
            }
        case false:
            remLog("Tweak is Disabled! :(")
            break
        }
    }
}
