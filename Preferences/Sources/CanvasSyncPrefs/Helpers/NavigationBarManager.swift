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
import Preferences

class NavigationBarManager {
    
    static func setNavBarThemed(enabled isEnabled: Bool, vc: UIViewController) {
        if #available(iOS 13.0, *) {
            guard let bar: UINavigationBar = vc.navigationController?.navigationController?.navigationBar else { return }
            guard let listController = vc as? PSListController else { return }
            let appearance = UINavigationBarAppearance()
            
            if isEnabled {
                // NavigationBar background color
                appearance.configureWithOpaqueBackground()
                appearance.backgroundColor = tweakColor
                appearance.shadowColor = UIColor.clear
                appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
                
                // NavigationBar icon
                if listController.specifier.name == "CanvasSync" {
                    let imagePath: String = prefsAssetsPath + "icon.png"
                    let iconView = UIImageView(frame: CGRect(x: bar.frame.maxX / 2, y: bar.frame.maxY / 2, width: 29, height: 29))
                    iconView.image = UIImage(contentsOfFile: imagePath)
                    vc.navigationItem.titleView = iconView
                }
                
                bar.isTranslucent = false
                bar.tintColor = UIColor.white
                bar.standardAppearance = appearance
                bar.scrollEdgeAppearance = appearance
            } else {
                bar.isTranslucent = true
                bar.tintColor = UINavigationBar.appearance().tintColor
                bar.standardAppearance = UINavigationBar.appearance().standardAppearance
                bar.scrollEdgeAppearance = UINavigationBar.appearance().scrollEdgeAppearance
            }
            
            vc.setNeedsStatusBarAppearanceUpdate()
        }
    }
}
