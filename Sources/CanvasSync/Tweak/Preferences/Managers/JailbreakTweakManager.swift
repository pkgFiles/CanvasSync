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

#warning("TODO: - Remove this afterwarts")
import roothide

final class JailbreakTweakManager {
    //MARK: - Enums
    enum JailbreakPaths {
        case bin
        case assets
        case support
        case plist(String)
        
        var relativePath: String {
            switch self {
            case .bin:                                      return relativePath(for: ["usr", "bin"])
            case .assets:                                   return relativePath(for: ["Library", "PreferenceBundles"])
            case .support:                                  return relativePath(for: ["Library", "Application Support"])
            case .plist(let subPath):                       return relativePath(for: [subPath, "mobile", "Library", "Preferences"])
            }
        }
        
        private func relativePath(for path: [String]) -> String { return path.map({ $0 + "/" }).joined() }
    }
    
    //MARK: - Singelton
    static let shared = JailbreakTweakManager()
    
    //MARK: - Variables
    private let rootPath = jbroot("/")
    var binPath: String!
    var plistPath: String!
    var prefsAssetsPath: String!
    var supportAssetsPath: String!

    let currentPreferencesIdentifier: String = "Prefs"
    let currentTweakName: String = "CanvasSync"
    lazy var configuration: PackageConfiguration = .init(bundleName: currentTweakName.components(separatedBy: .whitespaces).joined() + currentPreferencesIdentifier,
                                                         plistName: "com.pkgfiles." + currentTweakName.components(separatedBy: .whitespaces).joined().lowercased() + currentPreferencesIdentifier.lowercased(),
                                                         tweakColor: .init(red: 55/255, green: 44/255, blue: 36/255, alpha: 1.0))
    
    //MARK: - Initializers
    private init() {
        binPath = load(path: .bin, for: rootPath)
        plistPath = load(path: .plist("var"), for: rootPath) + configuration.plistName
        prefsAssetsPath = load(path: .assets, for: rootPath) + configuration.bundleName
        supportAssetsPath = load(path: .support, for: rootPath) + currentTweakName
    }
    
    //MARK: - Functions
    private func load(path: JailbreakPaths, for basePath: String) -> String {
        return basePath + path.relativePath
    }
}
