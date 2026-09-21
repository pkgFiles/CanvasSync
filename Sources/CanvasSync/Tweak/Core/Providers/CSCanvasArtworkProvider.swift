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

import Foundation
import CanvasSyncC

@available(iOS 15, *)
@MainActor final class CSCanvasArtworkProvider {
    
    //MARK: - Enums
    enum ProviderError: Error {
        case failedAppendingView
        case nowPlayingError(CSNowPlayingInfo.InfoError)
        case spotifyApplicationError(CSSpotifyApplication.ApplicationError)
        case unknown(Error)
        
        var information: (title: String, message: String) {
            switch self {
            case .failedAppendingView:                  return ("CSCanvasArtworkProvider", "Failed to append the canvasView to the array. More then two views are not allowed.")
            case .nowPlayingError(let error):           return ("CSNowPlayingInfo", error.text)
            case .spotifyApplicationError(let error):   return ("CSSpotifyApplication", error.text)
            case .unknown(let error):                   return ("Unknown Error", "An unknown error occured (\(error.localizedDescription)).")
            }
        }
        
        init(map error: Error) {
            if let error = error as? CSCanvasArtworkProvider.ProviderError {
                self = error
            } else if let error = error as? CSNowPlayingInfo.InfoError {
                self = ProviderError.nowPlayingError(error)
            } else if let error = error as? CSSpotifyApplication.ApplicationError {
                self = ProviderError.spotifyApplicationError(error)
            } else {
                self = ProviderError.unknown(error)
            }
        }
    }
    
    //MARK: - Singelton
    static let shared: CSCanvasArtworkProvider = .init()
    
    //MARK: - Variables
    private let nowPlayingInfo: CSNowPlayingInfo = .init()
    private let audioSession: CSAudioSession = .init()
    private var canvasViews: [CSCanvasView] = []
    private var observerTask: Task<Void, Never>?
    
    //MARK: - Initializers
    private init() {
        observerTask = Task {
            await observeSpotifyNotifications()
        }
        
        // Configures the AudioSession once with the .ambient category.
        // Ensures canvas video playback does not interrupt background audio (e.g., Spotify, Apple Music).
        audioSession.setupAudioSessionIfNeeded()
    }
    
    deinit { observerTask?.cancel(); observerTask = nil }
    
    //MARK: - Functions
    func append(_ view: CSCanvasView) throws {
        guard canvasViews.count < 2 else { throw ProviderError.failedAppendingView }
        canvasViews.append(view)
    }
    
    func handlePlayingStatus(for isPlaying: Bool) {
        canvasViews.forEach({ isPlaying ? ($0.play()) : ($0.pause()) })
    }
    
    func handleClearingStatus(shouldCleanArtwork: Bool = true) {
        canvasViews.forEach({
            $0.pause()
            
            if shouldCleanArtwork {
                $0.hide()
                $0.clearCanvas()
                $0.clearArtwork()
            } else { $0.clearCanvas() }
        })
    }
    
    func updateArtwork() async throws {
        do {
            let track: CSCurrentTrack = try await nowPlayingInfo.currentTrack()
            
            guard let artworkData = track.artworkData else { return }
            let artworkImage: UIImage? = UIImage(data: artworkData)
            
            canvasViews.forEach({ $0.setArtwork(with: artworkImage); $0.show() })
        } catch {
            throw CSCanvasArtworkProvider.ProviderError(map: error)
        }
    }
    
    #warning("TODO: - There is a big issue here: Currently the clearation happen in here, but also need in uodateArtwork. Changing an app like Spotify to Youtube will not clear the current canvas.")
    private func updateCanvas(for path: String?) {
        guard let path = path else {
            // Clear everything up, since we don't have a canvas to set, we just want to show the artwork for the current track.
            handleClearingStatus(shouldCleanArtwork: false); return
        }
        
        // If the path is not nil, we just want to set the canvas for the current track, that we get directly from Spotify.
        // But only if the track hasn't been already set in the player.
        guard !isCanvasForTrackAlreadySet(for: path) else { return }
        canvasViews.forEach({ $0.setCanvas(with: path) })
    }
    
    private func isCanvasForTrackAlreadySet(for path: String) -> Bool {
        guard let canvasPath = canvasViews.first?.currentItemPath() else { return false }
        return canvasPath == path
    }
    
    nonisolated private func observeSpotifyNotifications() async {
        // Set the observer for listening to the current Spotify session.
        // This is neccessary to collect the path for the current canvas if the track has one.
        let notifications = NSDistributedNotificationCenter.default.notifications(named: .trackDidReturnURL, object: nil)
        for await notification in notifications {
            guard !Task.isCancelled else { return }
            let canvasPath = notification.userInfo?.first?.value as? String
            
            // Set the canvas for the url that has been send as notification in the @MainActor.
            // This url comes as 'String' directly from Spotify. At that place is the canvas as '.mp4' file saved.
            // We also don't need to manually check if the file exist or not. That has already been done for us.
            await updateCanvas(for: canvasPath)
        }
    }
}
