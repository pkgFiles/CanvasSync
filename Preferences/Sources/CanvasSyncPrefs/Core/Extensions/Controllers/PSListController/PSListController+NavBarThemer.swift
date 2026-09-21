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

import Preferences

@available(iOS 13.0, *)
extension PSListController {
    
    func setNavBarThemed(enabled isEnabled: Bool, hasIcon isIconEnabled: Bool = false) {
        guard let navigationController: UINavigationController = self.navigationController?.navigationController else { return }
        
        if isEnabled {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = JailbreakTweakManager.shared.configuration.tweakColor
            appearance.shadowColor = UIColor.clear
            appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            
            navigationController.navigationBar.isTranslucent = false
            navigationController.navigationBar.tintColor = UIColor.white
            navigationController.navigationBar.standardAppearance = appearance
            navigationController.navigationBar.scrollEdgeAppearance = appearance
            
            guard isIconEnabled,
                  self.navigationItem.titleView == nil,
                  self.specifier.name == JailbreakTweakManager.shared.currentTweakName else { self.navigationItem.titleView?.isHidden = false; return }
            let imagePath: String = JailbreakTweakManager.shared.prefsAssetsPath + "/icon.png"
            let iconView = UIImageView(frame: CGRect(x: navigationController.navigationBar.frame.maxX / 2,
                                                     y: navigationController.navigationBar.frame.maxY / 2,
                                                     width: 29,
                                                     height: 29))
            iconView.image = UIImage(contentsOfFile: imagePath)
            self.navigationItem.titleView = iconView
        } else {
            navigationController.navigationBar.isTranslucent = true
            navigationController.navigationBar.tintColor = UINavigationBar.appearance().tintColor
            navigationController.navigationBar.standardAppearance = UINavigationBar.appearance().standardAppearance
            navigationController.navigationBar.scrollEdgeAppearance = UINavigationBar.appearance().scrollEdgeAppearance
            
            guard isIconEnabled,
                  self.specifier.name == JailbreakTweakManager.shared.currentTweakName else { self.navigationItem.titleView?.removeFromSuperview(); return }
            self.navigationItem.titleView?.isHidden = true
        }
    }
}
