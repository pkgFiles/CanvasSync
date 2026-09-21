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

import Preferences
import CanvasSyncPrefsC

@available(iOS 13.0, *)
class CanvasSyncMainVC: PSListController {

    //MARK: - Propertys
    let headerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 275))
    
    //MARK: - Variables
    var mainDeveloper: Developer = .init(name: "★ Install Package Files", shorthand: "pkgFiles", social: [.twitterX, .kofi])
    
    //MARK: - Initializers
    override init(forContentSize contentSize: CGSize) {
        super.init(forContentSize: contentSize)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    //MARK: - Instance Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let avatarURL = URL(string: "https://github.com/\(mainDeveloper.shorthand).png") else { return }
        try? RESTful.shared.download(at: avatarURL, completion: { [weak self] result in
            switch result {
            case .success(let avatarData):
                self?.mainDeveloper.avatar = UIImage(data: avatarData)
                DispatchQueue.main.async { self?.reload() }
    
            case .failure(let error):
                remLog(error.localizedDescription)
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setNavBarThemed(enabled: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.setNavBarThemed(enabled: false)
    }
    
    //MARK: - Overrides
    override var preferredStatusBarStyle: UIStatusBarStyle { return .default }
    
    //MARK: - Functions
    private func setupUI() {
        self.view.clipsToBounds = true
        
        let rightBarButtonItems: [UIBarButtonItem] = [
            UIBarButtonItem(image: UIImage(systemName: "arrow.triangle.2.circlepath.circle.fill"),
                            style: .plain,
                            target: self,
                            action: #selector(respringDevice)),
            UIBarButtonItem(image: UIImage(systemName: "arrow.counterclockwise.circle.fill"),
                            style: .plain,
                            target: self,
                            action: #selector(resetInstructions)),
        ]
        self.navigationItem.rightBarButtonItems = rightBarButtonItems
        
        let bannerImageView = UIImageView(frame: headerView.bounds)
        bannerImageView.contentMode = .scaleAspectFit
        bannerImageView.image = UIImage(contentsOfFile: JailbreakTweakManager.shared.prefsAssetsPath + "/CSBanner.png")
        bannerImageView.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(bannerImageView)
        
        NSLayoutConstraint.activate([
            bannerImageView.topAnchor.constraint(equalTo: headerView.topAnchor, constant: -50),
            bannerImageView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            bannerImageView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            bannerImageView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor),
        ])
    }
    
    //MARK: - Actions
    @objc private func respringDevice() {
        let binaryPath = JailbreakTweakManager.shared.binPath + "killall"
        let args = ["killall", "SpringBoard", nil].map({ UnsafeMutablePointer(mutating: ($0 as? NSString)?.utf8String) })
        var pid: pid_t = 0
        
        posix_spawn(&pid, binaryPath, nil, nil, args, nil)
    }
    
    @objc private func resetInstructions() {
        let alertController = UIAlertController(title: "Reset Tweak Settings", 
                                                message: "Are you sure you want to reset all tweak settings? This will restore default instructions and disable the tweak.",
                                                preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let resetAction = UIAlertAction(title: "Reset", style: .destructive) { [weak self] _ in
            do {
                try JailbreakTweakPreferencesManager.current.deletePreferences()
                self?.respringDevice()
            } catch {
                self?.showError("CanvasSyncMainVC", error.localizedDescription)
            }
        }
        
        [cancelAction, resetAction].forEach({ alertController.addAction($0) })
        self.present(alertController, animated: true)
    }
}
