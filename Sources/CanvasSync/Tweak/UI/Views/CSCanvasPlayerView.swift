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

import UIKit
import AVFoundation

class CSCanvasPlayerView: UIView {
    
    //MARK: - Propertys
    lazy var canvasPlayer: AVQueuePlayer = {
        let player = AVQueuePlayer()
        player.volume = 0.0
        player.preventsDisplaySleepDuringVideoPlayback = false
        return player
    }()
    
    lazy var canvasPlayerLayer: AVPlayerLayer = {
        let layer = AVPlayerLayer(player: canvasPlayer)
        layer.videoGravity = .resizeAspectFill
        return layer
    }()
    
    //MARK: - Variables
    private var playerLooper: AVPlayerLooper?
    
    //MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCanvasPlayerView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        pause()
        removeAllPlayerItems()
    }
    
    //MARK: - Instance Methods
    override func layoutSubviews() {
        canvasPlayerLayer.frame = self.bounds
    }
    
    //MARK: - Functions
    private func setupCanvasPlayerView() {
        self.layer.addSublayer(canvasPlayerLayer)
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient)
        } catch let error as NSError {
            remLog(error.localizedDescription)
        }
    }
    
    func setCanvas(with path: String) {
        guard FileManager.default.fileExists(atPath: path) else { return }
        
        let canvasURL = URL(fileURLWithPath: path)
        let newPlayerItem = AVPlayerItem(url: canvasURL)

        playerLooper = nil
        playerLooper = AVPlayerLooper(player: canvasPlayer, templateItem: newPlayerItem)
        
        canvasPlayer.replaceCurrentItem(with: newPlayerItem)
        canvasPlayer.play()
    }
    
    func hide() {
        self.alpha = 0.0
    }
    
    func show() {
        self.alpha = 1.0
    }
    
    func play() {
        canvasPlayer.play()
    }
    
    func pause() {
        canvasPlayer.pause()
    }
    
    func removeAllPlayerItems() {
        playerLooper = nil
        canvasPlayer.removeAllItems()
    }
}
