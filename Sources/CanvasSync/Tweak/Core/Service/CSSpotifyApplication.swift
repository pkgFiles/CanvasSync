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

final class CSSpotifyApplication {
    
    //MARK: - Enums
    enum ApplicationError: Error {
        case noApplicationController
        case noApplicationSpotify
        case noApplicationInfo
        case noApplicationURL
        case unknown(Error)
        
        var text: String {
            switch self {
            case .noApplicationController:  return "Failed to access 'SBApplicationController' to fetch Spotify's path."
            case .noApplicationSpotify:     return "Failed to find the 'SBApplication' instance for Spotify's bundle identifier."
            case .noApplicationInfo:        return "Failed to retrieve application info for Spotify."
            case .noApplicationURL:         return "Failed to obtain the data container URL for Spotify."
            case .unknown(let error):       return "An unknown error occured (\(error.localizedDescription))."
            }
        }
    }
    
    //MARK: - Variables
    private let spotifyBundleIdentifier = "com.spotify.client"
    
    //MARK: - Functions
    func getSpotifyDocumentsPath() throws -> URL {
        guard let appController = SBApplicationController.sharedInstance() else { throw ApplicationError.noApplicationController }
        guard let spotifyApplication = appController.application(withBundleIdentifier: spotifyBundleIdentifier) as? SBApplication else { throw ApplicationError.noApplicationSpotify }
        guard let spotifyInfo: SBApplicationInfo = spotifyApplication.info() else { throw ApplicationError.noApplicationInfo }
        guard let spotifyDataContainerURL = spotifyInfo.dataContainerURL() as? URL else { throw ApplicationError.noApplicationURL }
        return spotifyDataContainerURL
    }
}
