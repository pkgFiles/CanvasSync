import Preferences
import CanvasSyncPrefsC

class CanvasSyncAppearanceVC: PSListController {

    let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 275))
    
    override init(forContentSize contentSize: CGSize) {
        super.init(forContentSize: contentSize)
        
        let bannerImageView = UIImageView(frame: headerView.bounds)
        bannerImageView.contentMode = .scaleAspectFill
        bannerImageView.image = UIImage(contentsOfFile: prefsAssetsPath + "CSAppearanceBanner.png")
        bannerImageView.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(bannerImageView)
        
        NSLayoutConstraint.activate( [
            bannerImageView.topAnchor.constraint(equalTo: headerView.topAnchor),
            bannerImageView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            bannerImageView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            bannerImageView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor),
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NavigationBarManager.setNavBarThemed(enabled: true, vc: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NavigationBarManager.setNavBarThemed(enabled: false, vc: self)
    }
    
    //MARK: - Overrides
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }

    //MARK: - TableView
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.tableHeaderView = headerView
        return super.tableView(tableView, cellForRowAt: indexPath)
    }
    
    //MARK: - Required
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
}
