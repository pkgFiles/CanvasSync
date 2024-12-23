/*
 
 MIT License

 Copyright (c) 2024 ★ Install Package Files

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

class MediaControllerHook: ClassHook<SBMediaController> {
    typealias Group = CSSetNowPlayingInfo
    
    func setNowPlayingInfo(_ info: Any) {
        orig.setNowPlayingInfo(info)
        
        CSNowPlayingManager.shared.getCurrentSongValues { result in
            switch result {
            case .success(let currentSong):
                if let spotifyPath = CSNowPlayingManager.shared.spotifyPath {
                    let fileManager = FileManager.default
                    let folderPath: String = "\(spotifyPath.path)/Documents/CanvasSync/"
                    
                    if fileManager.fileExists(atPath: folderPath) {
                        if let firstArtistName: String = currentSong.artist.components(separatedBy: ", ").first {
                            let canvasFirstArtist = firstArtistName.replacingOccurrences(of: "/", with: "-")
                            let canvasPath = folderPath + "\(canvasFirstArtist) - \(currentSong.title).mp4"
                            if !self.isCanvasForThisSongAlreadySet(forPath: canvasPath) {
                                if !canvasInstances.contains(where: { $0.playerView == nil }) && fileManager.fileExists(atPath: canvasPath) {
                                    self.setCanvas(with: canvasPath)
                                } else {
                                    self.setArtwork(with: currentSong.artwork)
                                }
                                self.adjustExternalVideoPlayerLayers(isHidden: true)
                            }
                        }
                    }
                } else { self.setArtwork(with: currentSong.artwork) }
            case .failure(let error):
                remLog(error.localizedDescription)
                self.adjustExternalVideoPlayerLayers(isHidden: false)
                self.hideEverything()
            }
        }
        
        // Change the state of the dock while music is playing
        // If the Observer don't exist, this will be ignored
        changeDockState()
    }
    
    func _updateLastRecentActivityDate() {
        orig._updateLastRecentActivityDate()
        
        // This is the best way to Play/Pause the player
        // Keep in mind that handling it this way can be a bit confusing, as isMediaPlaying is reversed!
        let isPlaying: Bool = target.isPlaying()
        let isPaused: Bool = target.isPaused()
        let isMediaPlaying: Bool = !isPlaying && isPaused ? true : false
        for canvasInstance in canvasInstances {
            guard let canvasPlayer = canvasInstance.playerView else { return }
            isMediaPlaying ? canvasPlayer.play() : canvasPlayer.pause()
        }
    }
    
    //orion:new
    func setArtwork(with currentSongArtworkImage: UIImage) {
        for canvas in canvasInstances {
            // Make gradient effect visible
            canvas.gradientView?.show()
            
            // Remove all PlayerItems in PlayerQueue and hide the Player
            canvas.playerView?.removeAllPlayerItems()
            canvas.playerView?.hide()
            
            // Make the ImageView visible and set artworkImage
            canvas.artworkView?.show()
            canvas.artworkView?.artworkImage = currentSongArtworkImage
        }
    }
    
    //orion:new
    func setCanvas(with path: String) {
        for canvas in canvasInstances {
            // Make gradient effect visible
            canvas.gradientView?.show()
            
            // Hide the ImageView and make the Player visible
            canvas.artworkView?.hide()
            canvas.playerView?.show()
            canvas.playerView?.setCanvas(with: path)
        }
    }
    
    //orion:new
    func hideEverything() {
        for canvas in canvasInstances {
            UIView.animate(withDuration: 0.25) {
                // Hide GradientView, PlayerView and ImageView
                canvas.gradientView?.hide()
                canvas.playerView?.hide()
                canvas.artworkView?.hide()
            } completion: { finished in
                if finished {
                    // Remove all PlayerItems
                    canvas.playerView?.removeAllPlayerItems()
                }
            }
        }
    }
    
    //orion:new
    func isCanvasForThisSongAlreadySet(forPath path: String) -> Bool {
        for canvas in canvasInstances {
            // Checks whether the Canvas name matches the currently playing song and updates the Canvas if they do not match.
            if (canvas.playerView?.canvasPlayerLayer.player?.currentItem?.asset as? AVURLAsset)?.url.path.components(separatedBy: "/").last == path.components(separatedBy: "/").last { return true } else { return false }
        }
        return false
    }
    
    //orion:new
    func changeDockState() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            NotificationCenter.default.post(name: NSNotification.Name("DefaultDockSateChanged"), object: nil)
            NotificationCenter.default.post(name: NSNotification.Name("FloatingDockSateChanged"), object: nil)
        }
    }
    
    //orion:new
    func adjustExternalVideoPlayerLayers(isHidden: Bool) {
        // Make video layers invisible, like Eneko or other tweaks.
        if !externalVideoPlayerLayers.isEmpty {
            for layer in externalVideoPlayerLayers {
                UIView.animate(withDuration: 0.25) {
                    isHidden ? (layer.opacity = 0.0) : (layer.opacity = 1.0)
                }
            }
        }
    }
}
