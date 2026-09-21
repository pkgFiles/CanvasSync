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

class CSSingleCreditCell: PSTableCell {
    
    //MARK: - Propertys
    private let twitterCellView: CSCreditView = .init(frame: .zero)
    
    private lazy var kofiSupportImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(contentsOfFile: JailbreakTweakManager.shared.prefsAssetsPath + "/Support/support_me_on_kofi_\(self.traitCollection.userInterfaceStyle == .light ? "dark" : "beige").png"))
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    //MARK: - Variables
    weak var delegate: CSSingleCreditCellDelegate?
    
    //MARK: - Initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String, specifier: PSSpecifier) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Functions
    private func setupCell() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(twitterCellView)
        self.contentView.addSubview(kofiSupportImageView)
        
        let twitterRecognizer: UITapGestureRecognizer = .init(target: self, action: #selector(didTapCell))
        let kofiRecognizer: UITapGestureRecognizer = .init(target: self, action: #selector(didTapKofiButton))
        twitterCellView.addGestureRecognizer(twitterRecognizer)
        kofiSupportImageView.addGestureRecognizer(kofiRecognizer)
        
        NSLayoutConstraint.activate([
            twitterCellView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            twitterCellView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            twitterCellView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            twitterCellView.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.725),
            
            kofiSupportImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 15),
            kofiSupportImageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -15),
            kofiSupportImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -15),
            kofiSupportImageView.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.275),
        ])
    }
    
    func configure(for developer: Developer, with defaultAvatar: UIImage?) { twitterCellView.configure(with: developer, defaultAvatar: defaultAvatar) }
    
    //MARK: - Actions
    @objc private func didTapCell() { delegate?.openWebsite(.twitterX) }
    @objc private func didTapKofiButton() { delegate?.openWebsite(.kofi) }
}
