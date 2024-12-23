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

class CSSwitchCell: PSTableCell {
    
    //MARK: - Propertys
    private lazy var cellTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = traitCollection.userInterfaceStyle == .light ? UIColor.black : UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let cellSubtitleLabel: MarqueeLabel = {
        let label = MarqueeLabel()
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = UIColor.gray
        label.type = .leftRight
        label.animationCurve = .easeInOut
        label.animationDelay = 1.0
        label.speed = .duration(5.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var cellSwitch: UISwitch = {
        let _switch = UISwitch()
        _switch.onTintColor = tweakColor
        _switch.addTarget(self, action: #selector(handleSwitch), for: .valueChanged)
        _switch.translatesAutoresizingMaskIntoConstraints = false
        return _switch
    }()
    
    //MARK: - Variables
    private let currentSuiteName: String = "com.pkgfiles.canvassyncprefs"
    
    //MARK: - Initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String, specifier: PSSpecifier) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        if let plistData: NSDictionary = NSDictionary(contentsOfFile: "\(plistPath)\(currentSuiteName).plist"),
           let propertyKey: String = specifier.property(forKey: "key") as? String,
           let propertyValue: Bool = plistData.value(forKey: propertyKey) as? Bool {
            cellSwitch.isOn = propertyValue
        }
        
        cellTitleLabel.text = specifier.property(forKey: "cellTitleLabel") as? String
        cellSubtitleLabel.text = specifier.property(forKey: "cellSubtitleLabel") as? String
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(cellTitleLabel)
        self.contentView.addSubview(cellSubtitleLabel)
        self.contentView.addSubview(cellSwitch)
        
        NSLayoutConstraint.activate([
            cellTitleLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor, constant: -7.5),
            cellTitleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 22.5),
            cellTitleLabel.trailingAnchor.constraint(equalTo: cellSwitch.leadingAnchor, constant: -5),
            
            cellSubtitleLabel.topAnchor.constraint(equalTo: cellTitleLabel.bottomAnchor, constant: 2),
            cellSubtitleLabel.leadingAnchor.constraint(equalTo: cellTitleLabel.leadingAnchor),
            cellSubtitleLabel.trailingAnchor.constraint(equalTo: cellSwitch.leadingAnchor, constant: -5),
            
            cellSwitch.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            cellSwitch.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -22.5)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Functions
    @objc private func handleSwitch() {
        guard let plistData: NSDictionary = NSDictionary(contentsOfFile: "\(plistPath)\(currentSuiteName).plist") else { return }
        guard let propertyKey: String = specifier.property(forKey: "key") as? String else { return }
        plistData.setValue(cellSwitch.isOn, forKey: propertyKey)
        plistData.write(toFile: "\(plistPath)\(currentSuiteName).plist", atomically: true)
    }
}
