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

class CSCanvasView: UIView {

    //MARK: - Propertys
    private var canvasGradientView: CSGradientView?
    private var canvasPlayerView: CSCanvasPlayerView?
    private var canvasArtworkImageView: CSCanvasArtworkImageView?
    
    //MARK: - Variables
    private let configuration: CanvasConfiguration
    
    //MARK: - Initializers
    init(configuration: CanvasConfiguration) {
        self.configuration = configuration
        
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Functions
    private func setupUI() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.hide()
        
        // Setting up the artwork to the 'CSCanvasView'
        if configuration.isArtworkEnabled {
            let artworkImageView = CSCanvasArtworkImageView(frame: .zero)
            addAndPinSubview(artworkImageView)
            self.canvasArtworkImageView = artworkImageView
        }
        
        // Setting up the player for the canvas to the 'CSCanvasView'
        if configuration.isCanvasEnabed {
            let playerView = CSCanvasPlayerView(frame: .zero)
            addAndPinSubview(playerView)
            self.canvasPlayerView = playerView
        }
        
        // Setting up the gradient to the 'CSCanvasView'
        if configuration.isGradientEnabled {
            let gradientView = CSGradientView(frame: .zero)
            gradientView.setGradientAlpha(configuration.gradientAlpha)
            addAndPinSubview(gradientView)
            self.canvasGradientView = gradientView
        }
    }
    
    private func addAndPinSubview(_ subview: UIView) {
        self.addSubview(subview)
        
        NSLayoutConstraint.activate([
            subview.topAnchor.constraint(equalTo: self.topAnchor),
            subview.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            subview.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            subview.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    func setCanvas(with path: String) {
        canvasPlayerView?.setCanvas(with: path)
    }
    
    func setArtwork(with newImage: UIImage?) {
        canvasArtworkImageView?.setArtwork(with: newImage)
    }
    
    func show() {
        self.alpha = 1.0
    }
    
    func hide() {
        UIView.animate(withDuration: 0.25) {
            self.alpha = 0.0
        }
    }
    
    func play() {
        canvasPlayerView?.play()
    }
    
    func pause() {
        canvasPlayerView?.pause()
    }
    
    func clearCanvas() {
        canvasPlayerView?.removeAllPlayerItems()
    }
    
    func clearArtwork() {
        canvasArtworkImageView?.image = nil
    }
    
    func currentItemPath() -> String? {
        return canvasPlayerView?.currentItemURL()?.path
    }
}
