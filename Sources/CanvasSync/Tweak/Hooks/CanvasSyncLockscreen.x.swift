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

class LockscreenWallpaperHook: ClassHook<CSCoverSheetViewController> {
    typealias Group = CSLockscreen
    @Property var lockscreenGradientView: CSGradientView? = nil
    @Property var lockscreenArtworkView: CSArtworkImageView? = nil
    @Property var lockscreenPlayerView: CSCanvasPlayerView? = nil
    
    func viewDidLoad() {
        orig.viewDidLoad()
        
        let appearanceStyle: PreferenceCollection.CanvasAppearance = .getAppearance()

        // Gradient
        if lockscreenGradientView == nil && tweakPrefs.isGradientEffectEnabled {
            lockscreenGradientView = CSGradientView(frame: target.view.bounds)
            target.view.insertSubview(lockscreenGradientView!, at: 0)
        }
        
        // Artwork
        if lockscreenArtworkView == nil && (appearanceStyle == .both || appearanceStyle == .artwork) {
            lockscreenArtworkView = CSArtworkImageView(frame: target.view.bounds)
            target.view.insertSubview(lockscreenArtworkView!, at: 0)
        }
        
        // Canvas
        if lockscreenPlayerView == nil && (appearanceStyle == .both || appearanceStyle == .canvas) {
            lockscreenPlayerView = CSCanvasPlayerView(frame: target.view.bounds)
            target.view.insertSubview(lockscreenPlayerView!, at: 0)
        }

        let lockscreenCanvas = (gradientView: lockscreenGradientView,
                                artworkView: lockscreenArtworkView,
                                playerView: lockscreenPlayerView)
        canvasInstances.append(lockscreenCanvas)
        
        // Some video wallpaper tweaks use the CSCoverSheetViewController class to add an AVPlayerLayer.
        // To address this, check if, for example, Eneko is installed, and hide this layer accordingly.
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            for layer in self.target.view.layer.sublayers ?? [] {
                if layer.isKind(of: AVPlayerLayer.self) {
                    if let playerLayer = layer as? AVPlayerLayer {
                        externalVideoPlayerLayers.append(playerLayer)
                    }
                }
            }
        }
    }
    
    func viewWillAppear(_ animated: Bool) {
        orig.viewWillAppear(animated)
        
        guard let sharedMediaController = SBMediaController.sharedInstance(),
              let lockscreenCanvasPlayerView = lockscreenPlayerView else { return }
        let isMediaPlaying: Bool = sharedMediaController.isPlaying()
        if isMediaPlaying { lockscreenCanvasPlayerView.play() }
        adjustFrame()
    }
    
    func viewDidDisappear(_ animated: Bool) {
        orig.viewDidDisappear(animated)
        
        guard let lockscreenCanvasPlayerView = lockscreenPlayerView else { return }
        lockscreenCanvasPlayerView.pause()
    }
    
    //orion:new
    func adjustFrame() {
        let controllerBounds: CGRect = target.view.bounds
        
        lockscreenGradientView?.frame = controllerBounds
        lockscreenArtworkView?.frame = controllerBounds
        lockscreenPlayerView?.frame = controllerBounds
    }
}
