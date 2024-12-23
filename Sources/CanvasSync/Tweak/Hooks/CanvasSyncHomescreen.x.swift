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

class HomescreenWallpaperHook: ClassHook<SBHomeScreenViewController> {
    typealias Group = CSHomescreen
    @Property var homescreenGradientView: CSGradientView? = nil
    @Property var homescreenArtworkView: CSArtworkImageView? = nil
    @Property var homescreenPlayerView: CSCanvasPlayerView? = nil
    
    func viewDidLoad() {
        orig.viewDidLoad()
        
        let appearanceStyle: PreferenceCollection.CanvasAppearance = .getAppearance()
        
        // Gradient
        if homescreenGradientView == nil && tweakPrefs.isGradientEffectEnabled {
            homescreenGradientView = CSGradientView(frame: target.view.bounds)
            target.view.insertSubview(homescreenGradientView!, at: 0)
        }
        
        // Artwork
        if homescreenArtworkView == nil && (appearanceStyle == .both || appearanceStyle == .artwork) {
            homescreenArtworkView = CSArtworkImageView(frame: target.view.bounds)
            target.view.insertSubview(homescreenArtworkView!, at: 0)
        }
        
        // Canvas
        if homescreenPlayerView == nil && (appearanceStyle == .both || appearanceStyle == .canvas) {
            homescreenPlayerView = CSCanvasPlayerView(frame: target.view.bounds)
            target.view.insertSubview(homescreenPlayerView!, at: 0)
        }
        
        let homescreenCanvas = (gradientView: homescreenGradientView,
                                artworkView: homescreenArtworkView,
                                playerView: homescreenPlayerView)
        canvasInstances.append(homescreenCanvas)
        
        // Some video wallpaper tweaks use the SBIconController class to add an AVPlayerLayer.
        // To address this, check if, for example, Eneko is installed, and hide this layer accordingly.
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if let iconController = self.target.iconController {
                for layer in iconController.view.layer.sublayers ?? [] {
                    if layer.isKind(of: AVPlayerLayer.self) {
                        if let playerLayer = layer as? AVPlayerLayer {
                            externalVideoPlayerLayers.append(playerLayer)
                        }
                    }
                }
            }
        }
    }
    
    func viewWillAppear(_ animated: Bool) {
        orig.viewWillAppear(animated)
        
        guard let sharedMediaController = SBMediaController.sharedInstance(),
              let homescreenCanvasPlayerView = homescreenPlayerView else { return }
        let isMediaPlaying: Bool = sharedMediaController.isPlaying()
        if isMediaPlaying { homescreenCanvasPlayerView.play() }
        adjustFrame()
    }
    
    func viewDidDisappear(_ animated: Bool) {
        orig.viewDidDisappear(animated)
        
        guard let homescreenCanvasPlayerView = homescreenPlayerView else { return }
        homescreenCanvasPlayerView.pause()
    }
    
    //orion:new
    func adjustFrame() {
        let controllerBounds: CGRect = target.view.bounds
        
        homescreenGradientView?.frame = controllerBounds
        homescreenArtworkView?.frame = controllerBounds
        homescreenPlayerView?.frame = controllerBounds
    }
}
