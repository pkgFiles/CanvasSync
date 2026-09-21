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

final class CSNowPlayingInfo {
    
    //MARK: - Enums
    enum InfoError: Error {
        case failedUnwrappingSong
        case unknown(Error)
        
        var text: String {
            switch self {
            case .failedUnwrappingSong:         return "Failed to unwrap song informations for the current song."
            case .unknown(let error):           return "An unknown error occured (\(error.localizedDescription))."
            }
        }
    }
    
    enum InfoKey {
        case songTitle, songArtist, songArtwork
        
        var key: String {
            switch self {
            case .songTitle:    return "kMRMediaRemoteNowPlayingInfoTitle"
            case .songArtist:   return "kMRMediaRemoteNowPlayingInfoArtist"
            case .songArtwork:  return "kMRMediaRemoteNowPlayingInfoArtworkData"
            }
        }
    }
    
    //MARK: - Functions
    func currentTrack() async throws -> CSCurrentTrack {
        try await withCheckedThrowingContinuation { continuation in
            MRMediaRemoteGetNowPlayingInfo(DispatchQueue.main) { information in
                guard let information = information as? [String: Any] else { continuation.resume(throwing: InfoError.failedUnwrappingSong); return }
                
                // All the needed information is optional and may be nil. We capture whatever is available at initialization.
                let songTitle = information[InfoKey.songTitle.key] as? String
                let songArtist = information[InfoKey.songArtist.key] as? String
                let artworkData = information[InfoKey.songArtwork.key] as? Data
                
                // Return the track as 'CSCurrentTrack' asynchronous.
                continuation.resume(returning: CSCurrentTrack(title: songTitle, artist: songArtist, artworkData: artworkData))
            }
        }
    }
}
