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

class BacklightControllerHook: ClassHook<SBBacklightController> {
    
    func turnOnScreenFullyWithBacklightSource(_ arg1: Int64) {
        orig.turnOnScreenFullyWithBacklightSource(arg1)
        
        let isScreenOn = target.screenIsOn()
        if isScreenOn { handleCanvasPlayerPlaying(for: isScreenOn) }
    }
    
    func screenIsOn() -> Bool {
        let isScreenOn: Bool = orig.screenIsOn()
        if !isScreenOn { handleCanvasPlayerPlaying(for: isScreenOn) }
        return isScreenOn
    }
    
    //orion:new
    func handleCanvasPlayerPlaying(for screenOn: Bool) {
        guard let sharedMediaController = SBMediaController.sharedInstance() else { return }
        let isMediaPlaying: Bool = sharedMediaController.isPlaying()
        
        for canvasInstance in canvasInstances {
            guard let canvasPlayer: CSCanvasPlayerView = canvasInstance.playerView,
                  let _ = canvasPlayer.canvasPlayer.currentItem else { return }
            screenOn && isMediaPlaying ? canvasPlayer.play() : canvasPlayer.pause()
        }
    }
}
