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

@available(iOS 15, *)
class MediaControllerHook: ClassHook<SBMediaController> {
    typealias Group = CSSetNowPlayingInfo
    
    func setNowPlayingInfo(_ info: Any) {
        orig.setNowPlayingInfo(info)
        
        Task { @MainActor in
            guard let _ = info as? NSDictionary else { CSCanvasArtworkProvider.shared.handleClearingStatus(); return }
            
            // Set the artwork for the current playing song.
            // Updating the artwork should always be happen, even if the song has a canvas in the filesystem.
            do {
                try await CSCanvasArtworkProvider.shared.updateArtwork()
            } catch {
                guard let rootViewController = rootViewController() else { return }
                let error = CSCanvasArtworkProvider.ProviderError(map: error)
                rootViewController.presentError(with: error.information)
            }
        }
    }
    
    func _updateLastRecentActivityDate() {
        orig._updateLastRecentActivityDate()
        
        // This is the best way to Play/Pause the player
        // Keep in mind that handling it this way can be a bit confusing, as isMediaPlaying is reversed!
        Task { @MainActor in
            let isMediaPlaying: Bool = target.isPlaying() && !target.isPaused()
            CSCanvasArtworkProvider.shared.handlePlayingStatus(for: isMediaPlaying)
            
            // Observe the current state to hide or show the background of the dock.
            NotificationCenter.default.post(name: .dockDidChange, object: nil, userInfo: ["isMediaPlaying": isMediaPlaying])
        }
    }
    
    //orion:new
    private func rootViewController() -> UIViewController? {
        let keyWindow = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .flatMap({ $0.windows })
                .first(where: { $0.isKeyWindow })
        return keyWindow?.rootViewController
    }
}
