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

final class JailbreakTweakPreferencesManager {
    
    //MARK: - Singelton
    static let current = JailbreakTweakPreferencesManager()
    
    //MARK: - Variables
    lazy var settings: SettingsModel = loadPreferences()
    
    //MARK: - Functions
    func loadPreferences() -> SettingsModel {
        guard let data = FileManager.default.contents(atPath: JailbreakTweakManager.shared.plistPath) else {
            guard !FileManager.default.fileExists(atPath: JailbreakTweakManager.shared.plistPath) else { return .init() }
            remLog("Preferences don't exist... Creating...")
            do {
                return try createPreferences(atPath: JailbreakTweakManager.shared.plistPath)
            } catch { remLog(error.localizedDescription); return .init() }
        }
        
        do {
            remLog("Preferences Loading...")
            let settings = try PropertyListDecoder().decode(SettingsModel.self, from: data)
            remLog(settings)
            return settings
        } catch {
            remLog("Preferences Updating...")
            do {
                return try updatePreferences(atPath: JailbreakTweakManager.shared.plistPath)
            } catch { remLog(error.localizedDescription); return .init() }
        }
    }
    
    /// Update a specific value in the preferences
    func updatePreferences(value: Any?, for key: String) {
        guard let plistData: NSMutableDictionary = NSMutableDictionary(contentsOfFile: JailbreakTweakManager.shared.plistPath) else { return }
        plistData.setValue(value, forKey: key)
        plistData.write(toFile: JailbreakTweakManager.shared.plistPath, atomically: true)
    }
    
    /// Update the preferences in filesystem with a overwrite of the current SettingsModel. The 'value' can be specified during runtime.
    func updatePreferences<Value>(_ keyPath: WritableKeyPath<SettingsModel, Value>, to value: Value) throws {
        settings[keyPath: keyPath] = value
        let encodedData = try PropertyListEncoder().encode(settings)
        try encodedData.write(to: URL(fileURLWithPath: JailbreakTweakManager.shared.plistPath), options: .atomic)
    }
    
    /// Delete the whole preferences from the filesystem
    func deletePreferences() throws {
        try FileManager.default.removeItem(atPath: JailbreakTweakManager.shared.plistPath)
    }
    
    /// Update preferences and add non existing values to the current SettingsModel
    private func updatePreferences(atPath path: String) throws -> SettingsModel {
        guard let plistData: NSMutableDictionary = NSMutableDictionary(contentsOfFile: path),
              let plistKeys: [String] = plistData.allKeys as? [String] else { return .init() }
        guard let settingsData = try JSONSerialization.jsonObject(with: JSONEncoder().encode(SettingsModel())) as? [String: Any] else { throw NSError(domain: "JSONError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to create a JSON-Object!"]) }
        
        for i in settingsData {
            if !plistKeys.contains(i.key) {
                remLog("The Key: \(i.key) don't exist! Adding to .plist...")
                plistData.setValue(i.value, forKey: i.key)
                plistData.write(toFile: path, atomically: true)
            }
        }
        return try JSONDecoder().decode(SettingsModel.self, from: try JSONSerialization.data(withJSONObject: plistData))
    }
    
    /// Create a preference .plist file in the filesystem of the device
    private func createPreferences(atPath path: String) throws -> SettingsModel {
        guard let dict = try JSONSerialization.jsonObject(with: JSONEncoder().encode(SettingsModel())) as? [String: Any] else { return .init() }
        let plistData = NSDictionary(dictionary: dict)
        plistData.write(toFile: path, atomically: true)
        return try JSONDecoder().decode(SettingsModel.self, from: try JSONSerialization.data(withJSONObject: plistData))
    }
}
