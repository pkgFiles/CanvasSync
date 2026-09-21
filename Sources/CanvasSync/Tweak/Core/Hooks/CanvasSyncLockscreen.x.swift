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

import Orion
import CanvasSyncC

@available(iOS 15, *)
class LockscreenWallpaperHook: ClassHook<CSCoverSheetViewController> {
    typealias Group = CSLockscreen
    @Property var canvasView: CSCanvasView?
    
    func viewDidLoad() {
        orig.viewDidLoad()
        
        // Create a 'CSCanvasView' to the 'CSCoverSheetViewController' with all the preferences that the user has been set in the PreferenceBundle
        guard canvasView == nil else { return }
        let configuration: CanvasConfiguration = .init(isArtworkEnabled: (settings.canvasStyle == .both || settings.canvasStyle == .artwork),
                                                       isCanvasEnabed: (settings.canvasStyle == .both || settings.canvasStyle == .canvas),
                                                       isGradientEnabled: settings.isGradientEffectEnabled,
                                                       gradientAlpha: settings.canvasGradientSize.alpha)
        let canvasView: CSCanvasView = .init(configuration: configuration)
        self.target.view.insertSubview(canvasView, at: 0)
        NSLayoutConstraint.activate([
            canvasView.topAnchor.constraint(equalTo: target.view.topAnchor),
            canvasView.leadingAnchor.constraint(equalTo: target.view.leadingAnchor),
            canvasView.trailingAnchor.constraint(equalTo: target.view.trailingAnchor),
            canvasView.bottomAnchor.constraint(equalTo: target.view.bottomAnchor)
        ])

        self.canvasView = canvasView
        append(canvasView)
    }
    
    //orion:new
    private func append(_ canvasView: CSCanvasView) {
        Task { @MainActor in
            do {
                try CSCanvasArtworkProvider.shared.append(canvasView)
            } catch {
                let error = CSCanvasArtworkProvider.ProviderError(map: error)
                target.presentError(with: error.information)
            }
        }
    }
}
