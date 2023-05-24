

import UIKit
import SnapKit
import SDWebImage

class CryptocurrencyExchangeRateViewController: UIViewController, UISearchBarDelegate {
    
    // MARK: - Properties
    
    var viewModel = CryptoViewModel()
    var isSearching = false
    let refreshControl = UIRefreshControl()
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
        
    }
    
    // MARK: - UI Properties
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("Trending Coins", comment: "") 
        label.textAlignment = .left
        label.font = .boldSystemFont(ofSize: 28)
        label.textColor = .white
        return label
    }()
    
    private let backgroundview: UIView = {
        let view = UIView()
        view.layer.zPosition = 1
        view.backgroundColor = .clear
        return view
    }()
    
    private let backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.zPosition = 0
        imageView.image = UIImage(named: "bg")
        imageView.alpha = 1
        return imageView
    }()
    
    private lazy var searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10
        button.layer.borderColor = UIColor(red: 255, green: 255, blue: 255, alpha: 1).cgColor
        button.setImage(UIImage(named: "glass"), for: .normal)
        button.addTarget(self, action: #selector(searchButtonClicked), for: .touchUpInside)
        return button
    }()
    
    private let cryptoRateTableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .clear
        return table
    }()
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupUI()
        viewModel.fetchCrypto(tableView: cryptoRateTableView)
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        definesPresentationContext = true
        searchController.searchBar.tintColor = .white
        navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.isNavigationBarHidden = true
        
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        cryptoRateTableView.frame = backgroundview.bounds
    }
    
    // MARK: - Setup UI
    
    func setupUI() {
        view.backgroundColor = UIColor(red: 0.118, green: 0.118, blue: 0.118, alpha: 0.5)
        setupBlur()
        setupConstraints()
    }
    
    private func setupBlur() {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = backgroundImage.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backgroundImage.addSubview(blurEffectView)
    }
    
    private func setupTableView() {
        cryptoRateTableView.register(CryptoRateTableViewCell.self, forCellReuseIdentifier: CryptoRateTableViewCell.identifier)
        cryptoRateTableView.backgroundColor = .clear
        cryptoRateTableView.delegate = self
        cryptoRateTableView.dataSource = self
        cryptoRateTableView.addSubview(refreshControl)
    }
    
    private func setupConstraints() {
        self.view.addSubview(backgroundImage)
        backgroundImage.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
        
        self.view.addSubview(backgroundview)
        backgroundview.snp.makeConstraints { make in
            make.top.equalTo(view).offset(80)
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
        
        self.backgroundview.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(backgroundview).offset(0)
            make.left.equalTo(backgroundview).offset(20)
            make.size.equalTo(CGSize(width: 213, height: 29))
        }
        
        self.backgroundview.addSubview(searchButton)
        searchButton.snp.makeConstraints { make in
            make.top.equalTo(backgroundview).offset(-10)
            make.right.equalTo(backgroundview).offset(-20)
            make.size.equalTo(CGSize(width: 40, height: 40))
        }
        
        self.backgroundview.addSubview(cryptoRateTableView)
        cryptoRateTableView.snp.makeConstraints { make in
            make.top.equalTo(backgroundview).offset(50)
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
    }
    
    // MARK: - Action Methods
    
    @objc func searchButtonClicked() {
        print(viewModel.filteredAssets)
        UIView.animate(withDuration: 0.3, animations: {
            self.navigationItem.searchController = self.searchController
            self.navigationController?.isNavigationBarHidden = false
            self.titleLabel.isHidden = true
            self.searchButton.isHidden = true
            self.view.layoutIfNeeded()
        })
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        UIView.animate(withDuration: 0.4, animations: {
            self.navigationController?.isNavigationBarHidden = true
            self.titleLabel.isHidden = false
            self.searchButton.isHidden = false
            self.view.layoutIfNeeded()
        })
        print("Cancel button clicked!")
    }
    
    @objc private func refreshData(_ sender: UIRefreshControl) {
        viewModel.fetchCrypto(tableView: cryptoRateTableView)
        sender.endRefreshing()
    }
    
}

// MARK: - Esxtensions

extension CryptocurrencyExchangeRateViewController: UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            if !isSearching {
                isSearching = true
                viewModel.fetchAllAssets(tableView: cryptoRateTableView)
            }
            viewModel.filteredAssets = viewModel.cryptoRait.filter { crypto in
                guard let id  = crypto.id else { return false }
                return id.lowercased().contains(searchText.lowercased())
            }
        } else {
            isSearching = false
            viewModel.filteredAssets = viewModel.cryptoRait
        }
        DispatchQueue.main.async {
            self.cryptoRateTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return viewModel.filteredAssets.count
        }
        return viewModel.cryptoRait.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell",
                                                       for: indexPath)
                as? CryptoRateTableViewCell else { return UITableViewCell() }
        
        if viewModel.cryptoRait[indexPath.row].changePercent24Hr?.hasPrefix("-") == true {
            cell.changePercent24HrLabel.textColor = .red
        }
        
        if isFiltering {
            cell.setModel(with: viewModel.filteredAssets[indexPath.row])
            guard let symbolCrypto = viewModel.filteredAssets[indexPath.row].symbol?.lowercased() else {return  UITableViewCell()}
            let iconURL = URL(string: "https://cryptoicons.org/api/color/\(symbolCrypto)/40/ff00ff")
            cell.iconImage.sd_setImage(with: iconURL)
            return cell
        } else {
            cell.backgroundColor = .clear
            cell.setModel(with: viewModel.cryptoRait[indexPath.row])
            guard let symbolCrypto = viewModel.cryptoRait[indexPath.row].symbol?.lowercased() else {return  UITableViewCell()}
            let iconURL = URL(string: "https://cryptoicons.org/api/color/\(symbolCrypto)/40/ff00ff")
            cell.iconImage.sd_setImage(with: iconURL)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.cryptoRait.count - 1 {
            viewModel.fetchCrypto(tableView: cryptoRateTableView)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailScreenViewController()
        if viewModel.cryptoRait[indexPath.row].changePercent24Hr?.hasPrefix("-") == true {
            vc.percentLabel.textColor = .red
        }
        if isFiltering {
            vc.setModelDetail(with: viewModel.filteredAssets[indexPath.row])
        } else {
            vc.setModelDetail(with: viewModel.cryptoRait[indexPath.row])
        }
        self.navigationController?.pushViewController(vc, animated: false)
        print("TAPPPPPP")
    }
    
}
