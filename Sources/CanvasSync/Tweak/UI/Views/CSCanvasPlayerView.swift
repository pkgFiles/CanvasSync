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

import UIKit
import AVFoundation

class CSCanvasPlayerView: UIView {
    
    //MARK: - Propertys
    private lazy var canvasPlayer: AVQueuePlayer = {
        let player = AVQueuePlayer()
        player.volume = 0.0
        player.preventsDisplaySleepDuringVideoPlayback = false
        return player
    }()
    
    var canvasPlayerLayer: AVPlayerLayer { return self.layer as! AVPlayerLayer }
    
    //MARK: - Variables
    private var playerLooper: AVPlayerLooper?
    
    //MARK: - Overrides
    override class var layerClass: AnyClass { return AVPlayerLayer.self }
    
    //MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        pause()
        removeAllPlayerItems()
    }
    
    //MARK: - Functions
    private func setupUI() {
        self.translatesAutoresizingMaskIntoConstraints = false
        canvasPlayerLayer.player = canvasPlayer
        canvasPlayerLayer.videoGravity = .resizeAspectFill
    }
    
    func setCanvas(with path: String) {
        removeAllPlayerItems()
        
        let canvasURL = URL(fileURLWithPath: path)
        let canvasAsset = AVAsset(url: canvasURL)
        let newPlayerItem = AVPlayerItem(asset: canvasAsset)
        playerLooper = AVPlayerLooper(player: canvasPlayer, templateItem: newPlayerItem)
        canvasPlayer.play()
    }
    
    func currentItemURL() -> URL? {
        return (canvasPlayer.currentItem?.asset as? AVURLAsset)?.url
    }
    
    func play() {
        canvasPlayer.play()
    }
    
    func pause() {
        canvasPlayer.pause()
    }
    
    func removeAllPlayerItems() {
        playerLooper?.disableLooping()
        playerLooper = nil
        canvasPlayer.removeAllItems()
    }
}
