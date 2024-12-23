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

class CSApplicationManager {
    
    //MARK: - Variables
    ///Singelton
    static let shared = CSApplicationManager()
    
    ///Variables
    private let appController = SBApplicationController.sharedInstance()
    private var allApps: NSArray {
        guard let applications = appController?.allApplications() as? NSArray else { return [] }
        return applications
    }
    
    //MARK: - Initializer
    private init() {}
    
    //MARK: - Functions
    func getSpotifyDocumentsPath() -> URL? {
        let spotifyBundleIdentifier = "com.spotify.client"
        
        for app in allApps {
            guard let currentApplication = app as? SBApplication else { remLog(NSError(domain: "ApplicationError",code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to cast app to SBApplication"])); return nil }
            guard let applicationInfo: SBApplicationInfo = currentApplication.info() else { return nil }
            guard let bundleIdentifier = currentApplication.bundleIdentifier() else { continue }
            
            if let documentsURL = applicationInfo.dataContainerURL() as? URL {
                if bundleIdentifier == spotifyBundleIdentifier {
                    return documentsURL
                }
            }
        }
        
        return nil
    }
}
