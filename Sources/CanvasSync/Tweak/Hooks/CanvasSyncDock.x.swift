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

class SpringBoardDefaultDockHook: ClassHook<SBDockView> {
    typealias Group = CSSpringBoardDock
    
    func didMoveToWindow() {
        orig.didMoveToWindow()
        
        addObserver()
    }
    
    //orion:new
    func addObserver() {
        NotificationCenter.default.addObserver(target, selector: #selector(setHiddenOrVisible), name: NSNotification.Name("DefaultDockSateChanged"), object: nil)
    }
    
    //orion:new
    @objc func setHiddenOrVisible() {
        guard let sharedMediaController = SBMediaController.sharedInstance() else { return }
        
        let backgroundView = Ivars<UIView>(target)._backgroundView
        let isMediaPlaying = sharedMediaController.isPlaying()
        backgroundView.isHidden = isMediaPlaying ? true : false
    }
}

class SpringBoardFloatingDockHook: ClassHook<SBFloatingDockView> {
    typealias Group = CSSpringBoardDock
    
    func didMoveToWindow() {
        orig.didMoveToWindow()
        
        addObserver()
    }
    
    //orion:new
    func addObserver() {
        NotificationCenter.default.addObserver(target, selector: #selector(setHiddenOrVisible), name: NSNotification.Name("FloatingDockSateChanged"), object: nil)
    }
    
    //orion:new
    @objc func setHiddenOrVisible() {
        guard let sharedMediaController = SBMediaController.sharedInstance() else { return }
        
        let backgroundView = Ivars<UIView>(target.mainPlatterView)._backgroundView
        let isMediaPlaying = sharedMediaController.isPlaying()
        backgroundView.isHidden = isMediaPlaying ? true : false
    }
}
