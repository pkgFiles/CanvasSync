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
import CanvasSyncC

@available(iOS 15, *)
@MainActor final class CSDockProvider {
    
    //MARK: - Singelton
    static let shared: CSDockProvider = .init()
    
    //MARK: - Variables
    private var dockView: UIView?
    private var observerTask: Task<Void, Never>?
    
    //MARK: - Initializers
    private init() {
        observerTask = Task {
            await observeDockNotifications()
        }
    }
    
    deinit { observerTask?.cancel(); observerTask = nil }
    
    //MARK: - Functions
    func configure(with view: UIView) {
        self.dockView = view
    }
    
    private func setVisibility(_ isPlaying: Bool) {
        self.dockView?.isHidden = isPlaying
        
        let targetValue: CGFloat = isPlaying ? (0.0) : (1.0)
        UIView.animate(withDuration: 0.5) {
            self.dockView?.alpha = targetValue
        }
    }

    private func updateDock(for isPlaying: Bool) {
        // Hide the dock background when media is playing, and show it when paused or stopped.
        setVisibility(isPlaying)
    }
    
    nonisolated private func observeDockNotifications() async {
        let notifications = NotificationCenter.default.notifications(named: .dockDidChange, object: nil)
        for await notification in notifications {
            guard !Task.isCancelled else { return }
            guard let isMediaPlaying: Bool = notification.userInfo?.first?.value as? Bool else { return }
            
            // Update the visibility of the dock for the current playing state.
            await updateDock(for: isMediaPlaying)
        }
    }
}
