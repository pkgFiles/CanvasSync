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
import CanvasSyncC

class CSNowPlayingManager {
    
    //MARK: - Variables
    ///Singelton
    static let shared = CSNowPlayingManager()
    
    ///Variables
    let nowPlayingNotification: NSNotification.Name = NSNotification.Name("NowPlayingNotification")
    let spotifyPath: URL? = CSApplicationManager.shared.getSpotifyDocumentsPath()
    private let mediaController = SBMediaController.sharedInstance()
    
    //MARK: - Initializer
    private init() {}
    
    //MARK: - Functions
    func getCurrentSongValues(_ completion: @escaping (Result<(artwork: UIImage, title: String, artist: String), Error>) -> Void) {
        MRMediaRemoteGetNowPlayingInfo(DispatchQueue.main) { information in
            guard let information = information else { completion(.failure(NSError(domain: "NowPlayingInfoError",
                                                                                   code: 1,
                                                                                   userInfo: [NSLocalizedDescriptionKey: "Failed to unwrap song informations"]))); return }
            
            // Converting information in NSDictionary
            let dict = information as NSDictionary
            
            // Fetch the values for a specific key
            if let artworkData = dict.object(forKey: "kMRMediaRemoteNowPlayingInfoArtworkData") as? Data,
               let songArtwork = UIImage(data: artworkData),
               let songTitle: String = dict.object(forKey: "kMRMediaRemoteNowPlayingInfoTitle") as? String,
               let songArtist: String = dict.object(forKey: "kMRMediaRemoteNowPlayingInfoArtist") as? String {
                if songArtist.isEmpty && songTitle.contains("\u{2022}") {
                    let components = songTitle.components(separatedBy: "\u{2022}")
                    let newSongTitle = components[0].trimmingCharacters(in: .whitespaces)
                    let artistsComponent = components[1].trimmingCharacters(in: .whitespaces)
                    let newSongArtist = artistsComponent.components(separatedBy: ",").joined(separator: ",")
                    completion(.success((songArtwork, newSongTitle, newSongArtist)))
                } else {
                    let newSongTitle = songTitle.trimmingCharacters(in: .whitespaces)
                    let newSongArtist = songArtist.trimmingCharacters(in: .whitespaces)
                    completion(.success((songArtwork, newSongTitle, newSongArtist)))
                }
            }
        }
    }
}
