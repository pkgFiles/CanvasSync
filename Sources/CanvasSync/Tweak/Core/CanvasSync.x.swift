/*
 
 MIT License

 Copyright (c) 2026 ★ Install Package Files

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 
*/

import Orion
import CanvasSyncC

// CanvasSync - Display artwork or Spotify Canvas as wallpaper.
// For modern iOS 15.0 - 18.7.1
// Based on original from @sugiuta: https://havoc.app/package/canvaslife
//MARK: - Variables
let settings: SettingsModel = JailbreakTweakPreferencesManager.current.settings

//MARK: - HookGroups
struct CSSetNowPlayingInfo: HookGroup {}
struct CSLockscreen: HookGroup { let lockscreenEnabled: Bool }
struct CSHomescreen: HookGroup { let homescreenEnabled: Bool }
struct CSSpringBoardDock: HookGroup { let isDockBackgroundHidden: Bool }
struct CSSpringBoardBacklight: HookGroup {}

//MARK: - Initialize Tweak
final class CanvasSync: Tweak {

    init() {
        remLog("Preferences Loading...")

        let playingInfoHook: CSSetNowPlayingInfo = CSSetNowPlayingInfo()
        let lockscreenHook: CSLockscreen = CSLockscreen(lockscreenEnabled: settings.canvasAppearance == .both || settings.canvasAppearance == .lockscreen)
        let homescreenHook: CSHomescreen = CSHomescreen(homescreenEnabled: settings.canvasAppearance == .both || settings.canvasAppearance == .homescreen)
        let springboardBacklightHook: CSSpringBoardBacklight = CSSpringBoardBacklight()
        let springboardDockHook: CSSpringBoardDock = CSSpringBoardDock(isDockBackgroundHidden: settings.isDockBackgroundHidden)
        
        switch settings.isTweakEnabled {
        case true:
            remLog("Tweak is Enabled! :)")
            playingInfoHook.activate()
            
            if lockscreenHook.lockscreenEnabled {
                lockscreenHook.activate()
                springboardBacklightHook.activate()
            }
            
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
