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

import Foundation
import UIKit

class PreferenceCollection {
    
    //MARK: - Main
    enum CanvasStyle {
        case both, lockscreen, homescreen
        
        static func getStyle() -> CanvasStyle {
            switch tweakPrefs.canvasStyle {
            case 0: return .both
            case 1: return .lockscreen
            case 2: return .homescreen
            default: break
            }
            return .both
        }
    }
    
    //MARK: - Appearance
    enum CanvasAppearance {
        case both, artwork, canvas
        
        static func getAppearance() -> CanvasAppearance {
            switch tweakPrefs.appearanceStyle {
            case 0: return .both
            case 1: return .artwork
            case 2: return .canvas
            default: break
            }
            return .both
        }
    }
    
    enum CanvasGradientSize {
            case low, medium, high
            
            private static func getSize() -> CanvasGradientSize {
                switch tweakPrefs.gradientSize {
                case 0: return .low
                case 1: return .medium
                case 2: return .high
                default: break
                }
                
                return .medium
            }
            
        static func setAlpha() -> CGFloat {
                switch CanvasGradientSize.getSize() {
                case .low: return CGFloat(0.5)
                case .medium: return CGFloat(0.75)
                case .high: return CGFloat(1.0)
                }
            }
        }
}
