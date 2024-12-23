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

import Preferences

class CSSingleCreditCell: PSTableCell {
    
    enum Socials: String {
        case twitterX = "X"
        case kofi = "Ko-Fi"
        
        func getSocialURLString() -> String {
            switch self {
            case .twitterX: return "https://x.com/"
            case .kofi: return "https://ko-fi.com/"
            }
        }
    }
    
    //MARK: - Propertys
    private lazy var creditCell: CSCreditView = {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(handleSocial))
        let view = CSCreditView(username: (user: "★ Install Package Files", shorthand: "pkgFiles"), avatarUrlString: "1651534033019437056/BlFUdlQg_200x200.jpg")
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(recognizer)
        return view
    }()
    
    private lazy var kofiSupportImageView: UIImageView = {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(handleSupport))
        let imageView = UIImageView(image: UIImage(contentsOfFile: prefsAssetsPath + "Support/support_me_on_kofi_\(self.traitCollection.userInterfaceStyle == .light ? "dark" : "beige").png"))
        imageView.contentMode = .scaleAspectFit
        imageView.addGestureRecognizer(recognizer)
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    //MARK: - Initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String, specifier: PSSpecifier) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(creditCell)
        self.contentView.addSubview(kofiSupportImageView)
        
        NSLayoutConstraint.activate([
            creditCell.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            creditCell.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            creditCell.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            creditCell.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.725),
            
            kofiSupportImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 15),
            kofiSupportImageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -15),
            kofiSupportImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -15),
            kofiSupportImageView.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.275),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Functions
    @objc private func handleSocial() {
        loadPage(.twitterX)
    }
    
    @objc private func handleSupport() {
        loadPage(.kofi)
    }
    
    private func loadPage(_ social: Socials) {
        guard let url = URL(string: social.getSocialURLString() + creditCell.username.shorthand) else { return }
        UIApplication.shared.open(url)
    }
}
