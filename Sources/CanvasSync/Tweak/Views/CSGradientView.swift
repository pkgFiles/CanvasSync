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

class CSGradientView: UIView {

    //MARK: - Variables
    ///Preferences
    private let gradientAlpha: CGFloat = PreferenceCollection.CanvasGradientSize.setAlpha()
    
    //MARK: - Overrides
    override class var layerClass: AnyClass { CAGradientLayer.self }

    //MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradientView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Functions
    private func setupGradientView() {
        self.isOpaque = false
        self.alpha = 0.0
        
        if let gradient = self.layer as? CAGradientLayer {
            gradient.startPoint = CGPoint(x: 0.5, y: 0)
            gradient.endPoint = CGPoint(x: 0.5, y: 1)
            gradient.colors = [UIColor.clear.cgColor, UIColor.black.withAlphaComponent(gradientAlpha).cgColor]
        }
    }
    
    func hide() {
        self.alpha = 0.0
    }
    
    func show() {
        self.alpha = 1.0
    }
}
